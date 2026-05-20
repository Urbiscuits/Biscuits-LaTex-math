\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{biscuits}[2026/05/17 v1.5 Custom exercise class]

% ========== 键值对选项 ==========
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=biscuits, prefix=biscuits@}
\DeclareBoolOption{juemi}          % 绝密开关，默认 false
\DeclareBoolOption{zhuyishixiang}  % 注意事项开关，默认 false
\DeclareBoolOption{noexample}      % 隐藏题目来源信息开关，默认 false
\newif\ifshowanswers               % 保留原判断命令
\DeclareBoolOption{showanswers}    % 生成 \ifbiscuits@showanswers
\DeclareStringOption[red]{answercolor}
\DeclareStringOption[blue]{numbercolor}
\DeclareStringOption[a4]{paper}    % 允许 paper=a4 或 paper=a3，默认 a4
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessKeyvalOptions{biscuits}

% 将 kvoptions 的布尔值同步给 \ifshowanswers
\ifbiscuits@showanswers
  \showanswerstrue
\else
  \showanswersfalse
\fi

% 加载基础文档类
\LoadClass[a4paper]{ctexbook}

% ========== 必需宏包 ==========
\RequirePackage{amsmath,amsthm,amssymb}

\RequirePackage{geometry}
% 声明布尔条件变量
\newif\ifbiscuits@isathree
\biscuits@isathreefalse

\def\biscuits@paper@a{a4}
\def\biscuits@paper@b{a3}
\ifx\biscuits@paper\biscuits@paper@a
    \geometry{a4paper,margin=1in}
\else
    \ifx\biscuits@paper\biscuits@paper@b
        \biscuits@isathreetrue
        \geometry{a3paper,twocolumn,landscape,hmargin={3.5cm,1.3cm},
                  vmargin={1.5cm,1.5cm},footskip=0.85cm,headsep=0.25cm,columnsep=2cm} 
    \else
        % 未知值则回退到 A4
        \geometry{a4paper,margin=1in}
    \fi
\fi

\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{booktabs}
\RequirePackage{hyperref}
\RequirePackage{cite}
\RequirePackage{fancyhdr}

\RequirePackage{enumitem}
\setlist[enumerate,1]{label=(\arabic*)}
\setlist[enumerate,2]{label=(\roman*)}
\RequirePackage{environ}
\RequirePackage{xcolor}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins}
\RequirePackage{tikz}
\RequirePackage{pgfplots}
\RequirePackage{tikz-3dplot}
\pgfplotsset{compat=1.17}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\RequirePackage{ifthen}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{caption}
\RequirePackage{cleveref}
\RequirePackage{mathrsfs}
\RequirePackage{xparse}
\RequirePackage{totcount}

% 注册统计器，用于检测文档中是否存在 subsection
\regtotcounter{subsection}

% ========== 自适应逻辑页码与试卷切分算法 ==========
\newcounter{biscuits@paperblock}        % 当前第几套独立试卷
\setcounter{biscuits@paperblock}{0}
\newcounter{biscuits@startlogicpage}    % 当前试卷开始时的全局逻辑页码
\setcounter{biscuits@startlogicpage}{1}

% 辅助内部计算变量
\newcount\biscuits@cur@logicpage
\newcount\biscuits@shipped@logicpages
\newcount\biscuits@tmp@div
\newcount\biscuits@tmp@rem
\newcount\biscuits@padcnt
\newcount\biscuits@final@shipped

% 算法：自动补白页至 4 的倍数逻辑页，并向 aux 写入当前套题的真实总逻辑页数
\newcommand{\biscuits@pad@block}{%
  \ifnum\value{biscuits@paperblock}>0\relax
    % 确保之前的文本全部输出，并获取末尾处的逻辑页
    \clearpage
    \ifbiscuits@isathree
      % A3 下 \clearpage 会强制刷出新物理页，需要取上一页右栏结束后的逻辑页码
      \biscuits@cur@logicpage=\numexpr(\value{page}-1)*2\relax
    \else
      \biscuits@cur@logicpage=\numexpr\value{page}-1\relax
    \fi
    % 计算当前试卷块一共生成了多少个逻辑页
    \biscuits@shipped@logicpages=\numexpr\biscuits@cur@logicpage - \value{biscuits@startlogicpage} + 1\relax
    % 计算模 4 的余数
    \biscuits@tmp@div=\biscuits@shipped@logicpages
    \divide\biscuits@tmp@div by 4\relax
    \multiply\biscuits@tmp@div by 4\relax
    \biscuits@tmp@rem=\numexpr\biscuits@shipped@logicpages - \biscuits@tmp@div\relax
    % 如果不是 4 的倍数，则进行逻辑页/栏位补白
    \ifnum\biscuits@tmp@rem>0\relax
      \biscuits@padcnt=\numexpr4 - \biscuits@tmp@rem\relax
      \loop
      \ifnum\biscuits@padcnt>0\relax
        \ifbiscuits@isathree
          % A3 双栏下，插入一个空白栏位推进
          \null\vfill\eject
        \else
          % A4 单栏下，插入一整张物理白页
          \null\clearpage
        \fi
        \advance\biscuits@padcnt by -1\relax
      \repeat
    \fi
    % 补白完成后，再次清空获取最终准确的总共逻辑页数
    \clearpage
    \ifbiscuits@isathree
      \biscuits@cur@logicpage=\numexpr(\value{page}-1)*2\relax
    \else
      \biscuits@cur@logicpage=\numexpr\value{page}-1\relax
    \fi
    \biscuits@final@shipped=\numexpr\biscuits@cur@logicpage - \value{biscuits@startlogicpage} + 1\relax
    % 写入 .aux 供下一次编译精确定位每套题对应的 “共 x 页”
    \immediate\write\@auxout{\string\gdef\string\biscuits@blocktotal@\the\value{biscuits@paperblock}{\the\biscuits@final@shipped}}%
  \fi
}

% 开启新的一套试卷块
\newcommand{\biscuits@start@block}{%
  \biscuits@pad@block
  \stepcounter{biscuits@paperblock}%
  \ifnum\value{page}=1\relax
    \setcounter{biscuits@startlogicpage}{1}%
  \else
    \ifbiscuits@isathree
      \setcounter{biscuits@startlogicpage}{\numexpr\value{page}*2 - 1\relax}%
    \else
      \setcounter{biscuits@startlogicpage}{\value{page}}%
    \fi
  \fi
}

% ========== 绝密★启用前 ==========
\newcommand{\juemi}{%
  \par\vspace{1ex}
  \noindent{\heiti\zihao{-4} 绝密$\bigstar$启用前}%
  \par\vspace{1ex}
}

% ========== 注意事项 ==========
\newcommand{\zhuyishixiang}{%
  \par\vspace{1ex}
  \centerline{\Huge 数\quad\quad 学} % 居中显示数学，并使用 \quad 产生间隔
  \vspace{1ex} % 在标题与注意事项之间增加适当的间距
  \noindent{\heiti\large 注意事项}%
  \vspace{0.5ex}\par
  \begin{enumerate}[label=\arabic*., leftmargin=2em, labelsep=0.5em, itemsep=-0.3em, topsep=0pt]
    \item 答卷前，考生务必将自己的姓名和准考证号填写在答题卡上。
    \item 回答选择题时，选出每小题答案后，用铅笔把答题卡对应题目的答案标号涂黑。如需改动，用橡皮擦干净后，再选涂其它答案标号。回答非选择题时，将答案写在答题卡上。写在本试卷上无效。
    \item 考试结束后，将本试卷和答题卡一并交回。
    \item 请认真核对监考员在答题卡上所粘贴的条形码上的姓名、准考证号与您本人是否相符。
  \end{enumerate}
  \vspace{1ex}
}

% ========== 自适应大题自动化封装（彻底解决 titlesec 钩子冲突） ==========
\let\biscuits@old@section\section
\RenewDocumentCommand{\section}{s o m}{%
  \ifnum\totvalue{subsection}=0\relax
    \biscuits@start@block
    \ifbiscuits@juemi\juemi\fi
  \fi
  \IfBooleanTF{#1}{%
    \biscuits@old@section*{#3}%
    \setcounter{example}{0}%     % 重置例题计数器
    \setcounter{partnum}{0}%     % 重置大题序号计数器
  }{%
    \IfValueTF{#2}{%
      \biscuits@old@section[#2]{#3}%
    }{%
      \biscuits@old@section{#3}%
    }%
  }%
  \ifnum\totvalue{subsection}=0\relax
    \ifbiscuits@zhuyishixiang\zhuyishixiang\fi
  \fi
}

\let\biscuits@old@subsection\subsection
\RenewDocumentCommand{\subsection}{s o m}{%
  \ifnum\totvalue{subsection}>0\relax
    \biscuits@start@block
    \ifbiscuits@juemi\juemi\fi
  \fi
  \IfBooleanTF{#1}{%
    \biscuits@old@subsection*{#3}%
    \setcounter{example}{0}%
    \setcounter{partnum}{0}%
  }{%
    \IfValueTF{#2}{%
      \biscuits@old@subsection[#2]{#3}%
    }{%
      \biscuits@old@subsection{#3}%
    }%
  }%
  \ifnum\totvalue{subsection}>0\relax
    \ifbiscuits@zhuyishixiang\zhuyishixiang\fi
  \fi
}

\AtEndDocument{\biscuits@pad@block}

% ========== 页脚动态渲染（完美解决 A3 双栏左右独立居中） ==========
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\ifbiscuits@isathree
  \fancyfoot[L]{%
    \ifnum\value{biscuits@paperblock}>0\relax
      \def\biscuits@tmp@blockid{\the\value{biscuits@paperblock}}%
      \def\biscuits@tmp@total{4}%
      \ifcsname biscuits@blocktotal@\biscuits@tmp@blockid\endcsname
        \edef\biscuits@tmp@total{\csname biscuits@blocktotal@\biscuits@tmp@blockid\endcsname}%
      \fi
      \def\biscuits@left@page{\numexpr\value{page}*2 - 1\relax}%
      \def\biscuits@rel@left{\numexpr\biscuits@left@page - \value{biscuits@startlogicpage} + 1\relax}%
      \def\biscuits@right@page{\numexpr\value{page}*2\relax}%
      \def\biscuits@rel@right{\numexpr\biscuits@right@page - \value{biscuits@startlogicpage} + 1\relax}%
      \parbox{\textwidth}{%
        \parbox{\columnwidth}{\hfil 数学试卷\quad 第\the\biscuits@rel@left 页(共\biscuits@tmp@total 页)\hfil}%
        \hfill
        \parbox{\columnwidth}{\hfil 数学试卷\quad 第\the\biscuits@rel@right 页(共\biscuits@tmp@total 页)\hfil}%
      }%
    \fi
  }
\else
  \fancyfoot[C]{%
    \ifnum\value{biscuits@paperblock}>0\relax
      \def\biscuits@tmp@blockid{\the\value{biscuits@paperblock}}%
      \def\biscuits@tmp@total{4}%
      \ifcsname biscuits@blocktotal@\biscuits@tmp@blockid\endcsname
        \edef\biscuits@tmp@total{\csname biscuits@blocktotal@\biscuits@tmp@blockid\endcsname}%
      \fi
      数学试卷\quad 第\the\numexpr\value{page} - \value{biscuits@startlogicpage} + 1\relax 页(共\biscuits@tmp@total 页)%
    \fi
  }
\fi


% ========== 定理类环境 ==========
\theoremstyle{plain}
\newtheorem{theorem}{定理}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{命题}
\newtheorem{corollary}[theorem]{推论}

\theoremstyle{definition}
\newtheorem{definition}{定义}[section]
\newtheorem{exercise}{练习}[section]
\newtheorem{conclusion}{总结}[section]
\newtheorem{property}{性质}[section]

\theoremstyle{remark}
\newtheorem{remark}{remark}
\RequirePackage{pifont}   

% 带圈数字列表环境（① ② ③ …）
\newlist{quan}{enumerate}{1}
\setlist[quan]{
    label=\ding{\numexpr171+\value{quani}\relax},
    leftmargin=2em,
    labelsep=0.5em,
}

% 单个带圈数字命令 \quannum{1} → ①
\newcommand{\quannum}[1]{\ding{\numexpr171+#1\relax}}

% ===== 代码高亮配置（listings 宏包）=====
\RequirePackage{listings}   

% 定义代码背景与字体颜色
\definecolor{codegreen}{rgb}{0,0.6,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.58,0,0.82}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}

% 自定义 LaTeX 代码样式
\lstdefinestyle{mylatex}{
    language=[LaTeX]TeX,
    backgroundcolor=\color{backcolour},   
    commentstyle=\color{codegreen},
    keywordstyle=\color{magenta},
    numberstyle=\tiny\color{codegray},
    stringstyle=\color{codepurple},
    basicstyle=\ttfamily\small,
    breaklines=true,
    captionpos=b,
    keepspaces=true,
    numbers=left,
    numbersep=5pt,
    showspaces=false,
    showstringspaces=false,
    showtabs=false,
    tabsize=2,
    frame=single,
    rulecolor=\color{black!30},
    morekeywords={usepackage, documentclass, begin, end, usepackage, 
        title, author, date, maketitle, tableofcontents, 
        chapter, section, subsection, subsubsection, 
        parttitle, example, proof, kaodian, answer, solutions,
        choices, choice, quan, quannum, hezi, blankline, blankbox,
        xsection, xsubsection, xsubsubsection, newtcbcolor, 
        setlist, NewEnviron, NewDocumentEnvironment, renewenvironment,
        newcommand, renewcommand, usetikzlibrary, 
        definecolor, lstdefinestyle, lstset, lstinputlisting},
    emph={[1]argument, optional, mandatory, default},
    emphstyle={[1]\color{orange}},
}

\lstset{style=mylatex}

% ========== 例题计数器与题型统计 ==========
\newcounter{example}
\renewcommand{\theexample}{\arabic{example}}
\@addtoreset{example}{subsection}
\@addtoreset{example}{section}

\newtotcounter{totalSingle}
\newtotcounter{totalMulti}
\newtotcounter{totalFill}
\newtotcounter{totalAnswer}

\def\biscuits@exampletype{0}

% ========== example 环境 (添加 noexample 选项控制) ==========
\NewDocumentEnvironment{example}{ m O{} O{} O{} O{} O{} O{} +b }
{%
    \stepcounter{example}%
    \def\biscuits@exampletype{#1}%
    \ifnum#1=1 \stepcounter{totalSingle}\fi
    \ifnum#1=2 \stepcounter{totalMulti}\fi
    \ifnum#1=3 \stepcounter{totalFill}\fi
    \ifnum#1=4 \stepcounter{totalAnswer}\fi
    \par\noindent\textcolor{\biscuits@numbercolor}{\textbf{\theexample.}}\space
    \ifbiscuits@noexample\else
      \begingroup
      \def\@fieldA{}%
      \ifx\relax#2\relax\else \edef\@fieldA{#2}\fi
      \ifx\relax#3\relax\else \edef\@fieldA{\@fieldA#3}\fi
      \def\@fieldB{}%
      \ifx\relax#4\relax\else \edef\@fieldB{\@fieldB#4}\fi
      \ifx\relax#5\relax\else \edef\@fieldB{\@fieldB#5}\fi
      \def\@tmplist{}%
      \def\@tmpflag{0}%
      \ifx\@fieldA\@empty\else
          \edef\@tmplist{\@fieldA}\def\@tmpflag{1}%
      \fi
      \ifx\@fieldB\@empty\else
          \if1\@tmpflag\edef\@tmplist{\@tmplist.\@fieldB}\else
          \edef\@tmplist{\@fieldB}\def\@tmpflag{1}\fi
      \fi
      \ifx\relax#6\relax\else
          \if1\@tmpflag\edef\@tmplist{\@tmplist.#6}\else
          \edef\@tmplist{#6}\def\@tmpflag{1}\fi
      \fi
      \ifx\relax#7\relax\else
          \edef\@tmplist{\@tmplist(#7)}\fi
      \ifx\@tmplist\@empty\else
          （\@tmplist）\space
      \fi
      \endgroup
    \fi
    \ignorespaces
    #8%
    \par
}
{%
    \smallskip
}

% ========== 数学符号与空白 ==========
\newcommand{\R}{\mathbb{R}}
\newcommand{\N}{\mathbb{N}}
\newcommand{\E}{\mathbb{E}}
\everymath{\displaystyle}

\newcommand{\blankbox}{（\hspace{1.5em}）}
\newcommand{\eblankbox}{(\hspace{1.5em})}
\newcommand{\blankline}{\underline{\hspace{3em}}}
\newcommand{\noreftitle}[1]{\par\textbf{#1}\par}

% ========== 答案显隐与题型区分 ==========
\RenewEnviron{proof}{%
  \edef\@currentexampletype{\biscuits@exampletype}%  
  \ifshowanswers
    \par\vspace{\parsep}%
    \color{\biscuits@answercolor}%
    \BODY
    \par
  \else
    \ifnum\@currentexampletype<4
      \relax
    \else
      \begingroup
      \color{white}%
      \par\noindent
      \BODY
      \par
      \endgroup
    \fi
  \fi
}

% ========== 考点、答案、解析 ==========
\newcommand{\kaodian}[1]{%
    \ifshowanswers
    \par\noindent\textbf{【考点】：}#1\par
    \fi
}
\NewEnviron{answer}{\par\noindent\textbf{【答案】：}\BODY\par}
\NewEnviron{solutions}{\par\noindent\textbf{【解析】：}\BODY\par}

% ========== 带星号章节 ==========
\let\oldthesubsection\thesubsection
\newcommand{\xsubsection}[1]{%
    \renewcommand{\thesubsection}{\oldthesubsection*}%
    \subsection{#1}%
    \renewcommand{\thesubsection}{\oldthesubsection}%
}
\renewcommand{\cftsubsecnumwidth}{3em}

\let\oldthesection\thesection
\newcommand{\xsection}[1]{%
    \renewcommand{\thesection}{\oldthesection*}%
    \section{#1}%
    \renewcommand{\thesection}{\oldthesection}%
}
\renewcommand{\cftsecnumwidth}{3em}

\let\oldthesubsubsection\thesubsubsection
\newcommand{\xsubsubsection}[1]{%
    \renewcommand{\thesubsubsection}{\oldthesubsubsection*}%
    \subsubsection{#1}%
    \renewcommand{\thesubsubsection}{\oldthesubsubsection}%
}
\renewcommand{\cftsecnumwidth}{3em}

% ========== 彩色盒子 ==========
\definecolor{boxframe}{HTML}{1A9D8F}
\definecolor{boxbg}{HTML}{E8F4F1}
\newtcolorbox{hezi}[1][]{
    enhanced,
    frame hidden,
    left=4mm,
    colback=boxbg,
    borderline west={2mm}{0mm}{boxframe},
    title=#1,
    fonttitle=\bfseries\color{boxframe},
    titlerule=0pt,
    toptitle=2mm,
    bottomtitle=2mm,
}

\usetikzlibrary{positioning}
\usetikzlibrary{calc, intersections}
\usetikzlibrary{patterns}

% ========== 选择题排版 ==========
\newlength{\choicelengtha}
\newlength{\choicelengthb}
\newlength{\choicelengthc}
\newlength{\choicelengthd}
\newlength{\maxlength}

% 修改这里：去除括号前缀，将后缀改为“.”
\def\@optprefix{}
\def\@optsuffix{.}

\newcommand{\onech}[4]{\par
    \settowidth{\choicelengtha}{\@optprefix A\@optsuffix~#1}
    \settowidth{\choicelengthb}{\@optprefix B\@optsuffix~#2}
    \settowidth{\choicelengthc}{\@optprefix C\@optsuffix~#3}
    \settowidth{\choicelengthd}{\@optprefix D\@optsuffix~#4}
    \ifthenelse{\lengthtest{\choicelengtha>\choicelengthb}}
    {\setlength{\maxlength}{\choicelengtha}}
    {\setlength{\maxlength}{\choicelengthb}}
    \ifthenelse{\lengthtest{\choicelengthc>\maxlength}}
    {\setlength{\maxlength}{\choicelengthc}}{}
    \ifthenelse{\lengthtest{\choicelengthd>\maxlength}}
    {\setlength{\maxlength}{\choicelengthd}}{}
    \ifthenelse{\lengthtest{\maxlength>0.4\linewidth}}
    {%
        \begin{tabularx}{\linewidth}{X}
            \setlength\tabcolsep{0pt}
            \@optprefix A\@optsuffix~#1\\
            \@optprefix B\@optsuffix~#2\\
            \@optprefix C\@optsuffix~#3\\
            \@optprefix D\@optsuffix~#4\\
        \end{tabularx}
    }
    {%
        \ifthenelse{\lengthtest{\maxlength>0.2\linewidth}}
        {%
            \begin{tabularx}{\linewidth}{XX}
                \setlength\tabcolsep{0pt}
                \@optprefix A\@optsuffix~#1 & \@optprefix B\@optsuffix~#2\\
                \@optprefix C\@optsuffix~#3 & \@optprefix D\@optsuffix~#4\\
            \end{tabularx}
        }
        {%
            \begin{tabularx}{\linewidth}{XXXX}
                \setlength\tabcolsep{0pt}
                \@optprefix A\@optsuffix~#1 & \@optprefix B\@optsuffix~#2 & \@optprefix C\@optsuffix~#3 & \@optprefix D\@optsuffix~#4\\
            \end{tabularx}
        }
    }
    \unskip\unskip
}

\newcommand{\choice@A}{}
\newcommand{\choice@B}{}
\newcommand{\choice@C}{}
\newcommand{\choice@D}{}
\newcounter{choicecnt}
\newcommand{\choice@reset}{\setcounter{choicecnt}{0}}

\NewEnviron{choices}{%
    \choice@reset
    \def\choice##1{%
        \stepcounter{choicecnt}%
        \ifnum\value{choicecnt}=1 \gdef\choice@A{##1}\fi
        \ifnum\value{choicecnt}=2 \gdef\choice@B{##1}\fi
        \ifnum\value{choicecnt}=3 \gdef\choice@C{##1}\fi
        \ifnum\value{choicecnt}=4 \gdef\choice@D{##1}\fi
    }%
    \BODY
    \onech{\choice@A}{\choice@B}{\choice@C}{\choice@D}%
}

% ========== 大题序号 ==========
\newcounter{partnum}
\@addtoreset{partnum}{section}
\@addtoreset{partnum}{subsection}
\@addtoreset{partnum}{subsubsection}

\newcommand{\parttitle}[1]{%
    \stepcounter{partnum}%
    \vspace{1ex}%
    \noindent
    {\bfseries\heiti\large\chinese{partnum}、#1\par}
    \vspace{1ex}%
    \nopagebreak[3]%
}
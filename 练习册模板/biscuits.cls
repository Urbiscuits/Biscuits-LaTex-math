\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{biscuits}[Custom exercise class]

% ========== 键值对选项 ==========
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=biscuits, prefix=biscuits@}
\DeclareBoolOption{noexample}      % 隐藏题目来源信息开关，默认 false
\newif\ifshowanswers               % 保留原判断命令
\DeclareBoolOption{showanswers}    % 生成 \ifbiscuits@showanswers
\DeclareStringOption[red]{answercolor}
\DeclareStringOption[blue]{numbercolor}
\DeclareStringOption[blue]{examplecolor}     % 例题专属颜色
\DeclareStringOption[blue]{exercisecolor}    % 练习专属颜色
\DeclareStringOption[blue]{bianshicolor}     % 新增：变式训练专属颜色
\DeclareStringOption[blue]{sectioncolor}     % 章节标题颜色，默认蓝色
\DeclareStringOption[blue]{subsectioncolor}  % 子章节标题颜色，默认蓝色
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

% 根据纸张选项设置几何参数（无补白逻辑）
\def\biscuits@paper@a{a4}
\def\biscuits@paper@b{a3}
\ifx\biscuits@paper\biscuits@paper@a
    \geometry{a4paper,margin=1in}
\else
    \ifx\biscuits@paper\biscuits@paper@b
        \geometry{a3paper,twocolumn,landscape,hmargin={3.5cm,1.3cm},
                  vmargin={1.5cm,1.5cm},footskip=0.85cm,headsep=0.25cm,columnsep=2cm}
    \else
        % 未知值则回退到 A4
        \geometry{a4paper,margin=1in}
    \fi
\fi

% ========== 章节标题颜色设置 ==========
\RequirePackage{titlesec}
\RequirePackage{xcolor}

% 设置 chapter 标题颜色
\titleformat{\chapter}
  {\normalfont\Huge\bfseries\color{\biscuits@sectioncolor}}
  {\thechapter}{1em}{}

% 设置 section 标题颜色
\titleformat{\section}
  {\normalfont\Large\bfseries\color{\biscuits@sectioncolor}}
  {\thesection}{1em}{}

% 设置 subsection 标题颜色
\titleformat{\subsection}
  {\normalfont\large\bfseries\color{\biscuits@subsectioncolor}}
  {\thesubsection}{1em}{}

% 设置 subsubsection 标题颜色
\titleformat{\subsubsection}
  {\normalfont\normalsize\bfseries\color{\biscuits@subsectioncolor}}
  {\thesubsubsection}{1em}{}

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
\RequirePackage{tcolorbox}
\tcbuselibrary{skins}
\RequirePackage{tikz}
\RequirePackage{pgfplots}
\RequirePackage{tikz-3dplot}
\pgfplotsset{compat=1.17}
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

% ========== 自适应大题自动化封装 ==========
\let\biscuits@old@section\section
\RenewDocumentCommand{\section}{s o m}{%
  \IfBooleanTF{#1}{%
    \biscuits@old@section*{#3}%
    \setcounter{example}{0}%     % 重置例题计数器
    \setcounter{exe}{0}%         % 重置练习计数器
    \setcounter{bianshi}{0}%     % 重置变式计数器
    \setcounter{partnum}{0}%     % 重置大题序号计数器
  }{%
    \IfValueTF{#2}{%
      \biscuits@old@section[#2]{#3}%
    }{%
      \biscuits@old@section{#3}%
    }%
  }%
}

\let\biscuits@old@subsection\subsection
\RenewDocumentCommand{\subsection}{s o m}{%
  \IfBooleanTF{#1}{%
    \biscuits@old@subsection*{#3}%
    \setcounter{example}{0}%
    \setcounter{exe}{0}%
    \setcounter{bianshi}{0}%
    \setcounter{partnum}{0}%
  }{%
    \IfValueTF{#2}{%
      \biscuits@old@subsection[#2]{#3}%
    }{%
      \biscuits@old@subsection{#3}%
    }%
  }%
}

% ========== 页面样式 ==========
\pagestyle{empty}

% ========== 定理类环境 ==========
\theoremstyle{plain}
\newtheorem{theorem}{定理}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{命题}
\newtheorem{corollary}[theorem]{推论}

\theoremstyle{definition}
\newtheorem{definition}{定义}[section]
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
\newcommand{\quannum}[1]{\ding{\numexpr171+#1\relax}\quad}

% ===== 代码高亮配置 =====
\RequirePackage{listings}   

\definecolor{codegreen}{rgb}{0,0.6,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.58,0,0.82}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}

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
        parttitle, example, exercise, bianshi, proof, kaodian, answer, solutions,
        choices, choice, quan, quannum, hezi, blankline, blankbox,
        xsection, xsubsection, xsubsubsection, newtcbcolor, 
        setlist, NewEnviron, NewDocumentEnvironment, renewenvironment,
        newcommand, renewcommand, usetikzlibrary, 
        definecolor, lstdefinestyle, lstset, lstinputlisting},
    emph={[1]argument, optional, mandatory, default},
    emphstyle={[1]\color{orange}},
}
\lstset{style=mylatex}

% ========== 序号层级自动检测逻辑 ==========
\newcommand{\biscuits@getlabel}{%
  \ifnum\value{subsection}>0 
    \thesubsection.%
  \else
    \ifnum\value{section}>0 
      \thesection.%
    \else
        \ifnum\value{chapter}>0 
          \thechapter.%
        \fi
    \fi
  \fi
}

% ========== 各环境计数器配置 ==========
\newcounter{example}
\@addtoreset{example}{subsection}
\@addtoreset{example}{section}
\@addtoreset{example}{chapter}

\newcounter{exe}
\@addtoreset{exe}{subsection}
\@addtoreset{exe}{section}
\@addtoreset{exe}{chapter}

\newcounter{bianshi}
\@addtoreset{bianshi}{subsection}
\@addtoreset{bianshi}{section}
\@addtoreset{bianshi}{chapter}

\newtotcounter{totalSingle}
\newtotcounter{totalMulti}
\newtotcounter{totalFill}
\newtotcounter{totalAnswer}

\def\biscuits@exampletype{0}

% ========== 来源标签统一解析命令 ==========
\newcommand{\biscuits@printsource}[7]{%
  \begingroup
  \color{#1}%
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
}

% ========== 例题 (example) 环境 ==========
\NewDocumentEnvironment{example}{ m O{} O{} O{} O{} O{} O{} +b }
{%
    \stepcounter{example}%
    \def\biscuits@exampletype{#1}%
    \ifnum#1=1 \stepcounter{totalSingle}\fi
    \ifnum#1=2 \stepcounter{totalMulti}\fi
    \ifnum#1=3 \stepcounter{totalFill}\fi
    \ifnum#1=4 \stepcounter{totalAnswer}\fi
    \par\noindent\textcolor{\biscuits@examplecolor}{\textbf{例题~\biscuits@getlabel\arabic{example}.}}\space
    \ifbiscuits@noexample\else
      \biscuits@printsource{\biscuits@examplecolor}{#2}{#3}{#4}{#5}{#6}{#7}%
    \fi
    \ignorespaces
    #8%
    \par
}
{%
    \smallskip
}

% ========== 巩固练习 (exercise) 环境 ==========
\NewDocumentEnvironment{exercise}{ m O{} O{} O{} O{} O{} O{} +b }
{%
    \stepcounter{exe}%
    \def\biscuits@exampletype{#1}%
    \ifnum#1=1 \stepcounter{totalSingle}\fi
    \ifnum#1=2 \stepcounter{totalMulti}\fi
    \ifnum#1=3 \stepcounter{totalFill}\fi
    \ifnum#1=4 \stepcounter{totalAnswer}\fi
    \par\noindent\textcolor{\biscuits@exercisecolor}{\textbf{巩固练习~\biscuits@getlabel\arabic{exe}.}}\space
    \ifbiscuits@noexample\else
      \biscuits@printsource{\biscuits@exercisecolor}{#2}{#3}{#4}{#5}{#6}{#7}%
    \fi
    \ignorespaces
    #8%
    \par
}
{%
    \smallskip
}

% ========== 变式训练 (bianshi) 环境 ==========
\NewDocumentEnvironment{bianshi}{ m O{} O{} O{} O{} O{} O{} +b }
{%
    \stepcounter{bianshi}%
    \def\biscuits@exampletype{#1}%
    \ifnum#1=1 \stepcounter{totalSingle}\fi
    \ifnum#1=2 \stepcounter{totalMulti}\fi
    \ifnum#1=3 \stepcounter{totalFill}\fi
    \ifnum#1=4 \stepcounter{totalAnswer}\fi
    \par\noindent\textcolor{\biscuits@bianshicolor}{\textbf{变式训练~\arabic{bianshi}.}}\space % <-- 这里改为了纯数字序号
    \ifbiscuits@noexample\else
      \biscuits@printsource{\biscuits@bianshicolor}{#2}{#3}{#4}{#5}{#6}{#7}%
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
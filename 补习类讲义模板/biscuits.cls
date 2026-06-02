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
\DeclareStringOption[blue]{bianshicolor}     % 变式训练专属颜色
\DeclareStringOption[blue]{sectioncolor}     % 章节标题颜色
\DeclareStringOption[blue]{subsectioncolor}  % 子章节标题颜色
\DeclareStringOption[a4]{paper}    % 允许 paper=a4 或 paper=a3
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
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{xcolor}

% ========== 颜色定义（用于样式框） ==========
\definecolor{mainteal}{RGB}{23,172,158}
\definecolor{orangecorner}{RGB}{247,151,50}
\definecolor{mainteal2}{RGB}{135,206,235}   % 天空蓝
% 根据纸张选项设置几何参数
\def\biscuits@paper@a{a4}
\def\biscuits@paper@b{a3}
\ifx\biscuits@paper\biscuits@paper@a
    \geometry{a4paper,margin=1in}
\else
    \ifx\biscuits@paper\biscuits@paper@b
        \geometry{a3paper,twocolumn,landscape,hmargin={3.5cm,1.3cm},
                  vmargin={1.5cm,1.5cm},footskip=0.85cm,headsep=0.25cm,columnsep=2cm}
    \else
        \geometry{a4paper,margin=1in}
    \fi
\fi

% ========== 章节标题颜色设置 ==========
\RequirePackage{titlesec}
\titleformat{\chapter}
  {\normalfont\Huge\bfseries\color{\biscuits@sectioncolor}}
  {\thechapter}{1em}{}
\titleformat{\section}
  {\normalfont\Large\bfseries\color{\biscuits@sectioncolor}}
  {\thesection}{1em}{}
\titleformat{\subsection}
  {\normalfont\large\bfseries\color{\biscuits@subsectioncolor}}
  {\thesubsection}{1em}{}
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

% 注册统计器
\regtotcounter{subsection}

% ========== 题型标题命令 \tixing ==========
% 自动输出带橙色角的标题框，右侧一条横线装饰，并重置 example 和 exe 计数器
\newcommand{\tixing}[1]{%
  \par\vspace{0.4cm}\noindent
  \setcounter{example}{0}%      % 重置例题计数器（每题型下例题从1开始）
  \setcounter{exe}{0}%          % 重置练习计数器
  % \setcounter{bianshi}{0}%    % 变式计数器会随每个 example 自动重置，不需手动
  \begin{tikzpicture}[baseline=(A.base)]
    \node[draw=mainteal!55, rounded corners=3pt, fill=white, thick,
          inner xsep=7pt, inner ysep=3pt, minimum height=8.5mm,
          text=mainteal!70!black, font=\bfseries\zihao{-4}] (A)
          {题型\chinese{section}：#1};% 这里使用 section 计数器，可按需改为 topic
    \fill[orangecorner] ($(A.north east)+(-0.5pt,-0.5pt)$) --
                        ($(A.north east)+(-0.5pt,-5.5pt)$) --
                        ($(A.north east)+(-5.5pt,-0.5pt)$) -- cycle;
  \end{tikzpicture}%
  \hfill{\rule{8.0cm}{0.4pt}}%
  \par\vspace{0.25em}%
  \vspace{1.5em}
}

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

% ========== 计数器配置（重置逻辑由 \tixing 和 \example 控制） ==========
\newcounter{example}           % 例题计数器，每题型下由 \tixing 重置为0
\newcounter{exe}               % 练习计数器，每题型下由 \tixing 重置为0
\newcounter{bianshi}[example]  % 变式计数器，每道例题自动重置（父计数器为 example）

\newtotcounter{totalSingle}
\newtotcounter{totalMulti}
\newtotcounter{totalFill}
\newtotcounter{totalAnswer}

\def\biscuits@exampletype{0}

% ========== 例题 (example) 环境 ==========
% 样式：填充色方框，序号为纯数字（每题型下独立编号）
\NewDocumentEnvironment{example}{ m O{} O{} O{} O{} O{} O{} +b }
{%
    \stepcounter{example}%
    \def\biscuits@exampletype{#1}%
    \ifnum#1=1 \stepcounter{totalSingle}\fi
    \ifnum#1=2 \stepcounter{totalMulti}\fi
    \ifnum#1=3 \stepcounter{totalFill}\fi
    \ifnum#1=4 \stepcounter{totalAnswer}\fi
    \par\noindent
    \begin{tikzpicture}[baseline=(X.base)]
      \node[fill=mainteal!92!black, rounded corners=3pt,
            minimum width=1.55cm, minimum height=0.62cm,
            text=white, font=\bfseries\small, inner xsep=6pt] (X)
            {例题\arabic{example}};
    \end{tikzpicture}%
    \hspace{0.4em}%
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
% ========== 巩固练习 (exercise) 环境 ==========
% 样式：与例题相同（填充色方框、白色文字），序号随 \tixing 重置
\NewDocumentEnvironment{exercise}{ m O{} O{} O{} O{} O{} O{} +b }
{%
    \stepcounter{exe}%
    \def\biscuits@exampletype{#1}%
    \ifnum#1=1 \stepcounter{totalSingle}\fi
    \ifnum#1=2 \stepcounter{totalMulti}\fi
    \ifnum#1=3 \stepcounter{totalFill}\fi
    \ifnum#1=4 \stepcounter{totalAnswer}\fi
    \par\noindent
    \begin{tikzpicture}[baseline=(X.base)]
      \node[fill=orange, rounded corners=3pt,
            minimum width=1.55cm, minimum height=0.62cm,
            text=white, font=\bfseries\small, inner xsep=6pt] (X)
            {巩固练习\arabic{exe}};
    \end{tikzpicture}%
    \hspace{0.4em}%
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
% 样式：带边框白色框，序号为纯数字（每道例题下从1开始，因父计数器为 example）
\NewDocumentEnvironment{bianshi}{ m O{} O{} O{} O{} O{} O{} +b }
{%
    \stepcounter{bianshi}%
    \def\biscuits@exampletype{#1}%
    \ifnum#1=1 \stepcounter{totalSingle}\fi
    \ifnum#1=2 \stepcounter{totalMulti}\fi
    \ifnum#1=3 \stepcounter{totalFill}\fi
    \ifnum#1=4 \stepcounter{totalAnswer}\fi
    \par\noindent
    \begin{tikzpicture}[baseline=(X.base)]
      \node[draw=mainteal!55, rounded corners=3pt, fill=white, thick,
            inner xsep=5pt, inner ysep=2pt, minimum height=8.5mm,
            text=mainteal!70!black, font=\bfseries\zihao{-4}] (X)
            {变式\arabic{bianshi}};
    \end{tikzpicture}%
    \hspace{0.5em}%
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
\usetikzlibrary{intersections}
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
    {\bfseries\heiti\large\chinese{partnum}、#1}
   \hfill\textcolor{teal!70!black}{\rule{6cm}{0.8pt}}\par 
    \vspace{1ex}%
    \nopagebreak[3]%
}

\endinput

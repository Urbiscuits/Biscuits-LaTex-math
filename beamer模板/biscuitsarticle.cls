% biscuitsarticle.cls
% 基于 biscuitsbeamer 的数学教学文稿模板（article 版）
% 页面比例 16:9，适合屏幕阅读
% 作者：Biscuits
% 日期：2025-09-20

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{biscuitsarticle}[2025/09/20 Biscuits Article Class for Math Teaching (16:9)]

% -----------------------------
% 传递选项给 ctexart
% -----------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessOptions\relax
\LoadClass[11pt]{ctexart}

% -----------------------------
% 页面设置：16:9 比例
% -----------------------------
\RequirePackage{geometry}
\geometry{
    paperwidth=24cm,
    paperheight=13.5cm,
    margin=1.2cm,
    bottom=1.0cm,
    top=1.0cm,
    headheight=0.5cm,
    headsep=0.3cm,
    footskip=0.5cm
}

% -----------------------------
% 基本宏包（与 beamer 版同步）
% -----------------------------
\RequirePackage{amsmath,amssymb,mathtools,bm}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{tikz}
\usetikzlibrary{calc,decorations.pathmorphing,positioning,shapes.geometric,arrows.meta}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}
\RequirePackage{xcolor}
\RequirePackage{microtype}
\RequirePackage{hyperref}
\RequirePackage{pifont}       % 提供 \ding 命令（带圈数字）
\RequirePackage{listings}     % 代码高亮
\RequirePackage{tabularx}     % 选择题表格
\RequirePackage{ifthen}       % 条件判断
\RequirePackage{environ}      % \NewEnviron
\RequirePackage{xparse}       % 定义带多个可选参数的环境
\RequirePackage{etoolbox}     % \ifblank 等
\RequirePackage[normalem]{ulem} % 处理下划线
\RequirePackage{titlesec}     % 标题样式
\RequirePackage{titletoc}     % 目录样式
\RequirePackage{fancyhdr}     % 页眉页脚
\RequirePackage{enumitem}     % 列表格式

% 数学字体：数学部分使用衬线字体
\RequirePackage{fontspec}
\setmainfont{Latin Modern Roman}
\renewcommand{\familydefault}{\rmdefault}

% -----------------------------
% 颜色：以清爽绿色为主，轻微灰白底色
% -----------------------------
\definecolor{PrimaryGreen}{HTML}{0B7A43}
\definecolor{DeepGreen}{HTML}{085A31}
\definecolor{SoftGreen}{HTML}{EAF5EF}
\definecolor{MintGreen}{HTML}{DFF1E7}
\definecolor{WarmGray}{HTML}{666666}
\definecolor{LightGray}{HTML}{F6F7F7}
\definecolor{LineGray}{HTML}{B9BFC3}
\definecolor{TitleGray}{HTML}{2F3A3A}

% 各环境专用颜色
\definecolor{DefinitionFrame}{HTML}{0B7A43}
\definecolor{DefinitionBg}{HTML}{EAF5EF}
\definecolor{TheoremFrame}{HTML}{9B59B6}
\definecolor{TheoremBg}{HTML}{F3E5F5}
\definecolor{TipFrame}{HTML}{3498DB}
\definecolor{TipBg}{HTML}{EBF5FB}
\definecolor{ProofRed}{HTML}{C0392B}
\definecolor{ProofRedBg}{HTML}{FDEDEC}
\definecolor{RemarkFrame}{HTML}{3498DB}
\definecolor{RemarkBg}{HTML}{EBF5FB}
\definecolor{ExampleFrame}{HTML}{F1C40F}
\definecolor{ExampleBg}{HTML}{FEF9E7}
\definecolor{ExerciseFrame}{HTML}{F1C40F}
\definecolor{ExerciseBg}{HTML}{FEF9E7}

% -----------------------------
% 全局样式
% -----------------------------
\pagecolor{white}
\color{TitleGray}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.6ex plus 0.3ex minus 0.2ex}
\setlength{\abovedisplayskip}{6pt plus 2pt minus 2pt}
\setlength{\belowdisplayskip}{6pt plus 2pt minus 2pt}
\setlength{\abovedisplayshortskip}{3pt plus 1pt minus 1pt}
\setlength{\belowdisplayshortskip}{3pt plus 1pt minus 1pt}

% -----------------------------
% 页眉页脚
% -----------------------------
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhead[L]{\small\color{PrimaryGreen}\leftmark}
\fancyhead[R]{\small\color{WarmGray}\thepage}
\fancyfoot[C]{\color{LineGray}\rule{0.3\linewidth}{0.5pt}}

% -----------------------------
% 节标题样式
% -----------------------------
\titleformat{\section}[block]
    {\normalfont\Large\bfseries\color{PrimaryGreen}}
    {\thesection}{1em}{}
    [{\color{LineGray}\rule{\linewidth}{0.8pt}}]
\titlespacing{\section}{0pt}{1.5ex plus 0.5ex minus 0.3ex}{1.2ex plus 0.3ex}

\titleformat{\subsection}[block]
    {\normalfont\large\bfseries\color{PrimaryGreen!80}}
    {\thesubsection}{1em}{}
\titlespacing{\subsection}{0pt}{1.2ex plus 0.3ex}{0.8ex plus 0.2ex}

% -----------------------------
% 项目符号风格
% -----------------------------
\setlist[itemize,1]{label=\small\raise0.15ex\hbox{\color{PrimaryGreen}\textbullet}, leftmargin=1.5em}
\setlist[itemize,2]{label=\tiny\raise0.25ex\hbox{\color{PrimaryGreen}\textbullet}, leftmargin=1.5em}
\setlist[enumerate,1]{label=\arabic*., leftmargin=1.8em, font=\color{PrimaryGreen}\bfseries}
\setlist[enumerate,2]{label=(\alph*), leftmargin=1.8em}

% 带圈数字列表（① ② ③ …）
\newcounter{quani}
\newenvironment{quan}{%
    \begin{list}{\ding{\numexpr171+\value{quani}\relax}}{%
            \usecounter{quani}%
            \setlength{\leftmargin}{2em}%
            \setlength{\labelsep}{0.5em}%
        }%
    }{%
    \end{list}%
}
\newcommand{\quannum}[1]{\ding{\numexpr171+#1\relax}\quad}

% -----------------------------
% 选择题排版（源自 beamer 版）
% -----------------------------
\makeatletter
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
\makeatother

% -----------------------------
% 各环境专用盒子定义（与 beamer 版一致）
% -----------------------------
\newtcolorbox{definitionbox}[1][]{%
    enhanced, breakable,
    colback=DefinitionBg,
    colframe=DefinitionFrame,
    coltitle=white,
    fonttitle=\bfseries,
    boxrule=0.55pt, arc=2.2mm,
    left=2mm, right=2mm, top=1.2mm, bottom=1.2mm,
    before skip=2.5mm, after skip=2.5mm,
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=DefinitionFrame, colframe=DefinitionFrame, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
    title={#1}
}

\newtcolorbox{theorembox}[1][]{%
    enhanced, breakable,
    colback=TheoremBg,
    colframe=TheoremFrame,
    coltitle=white,
    fonttitle=\bfseries,
    boxrule=0.55pt, arc=2.2mm,
    left=2mm, right=2mm, top=1.2mm, bottom=1.2mm,
    before skip=2.5mm, after skip=2.5mm,
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=TheoremFrame, colframe=TheoremFrame, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
    title={#1}
}

\newtcolorbox{proofbox}[1][]{%
    enhanced,
    breakable,
    colback=ProofRedBg,
    colframe=ProofRed,
    coltitle=white,
    fonttitle=\bfseries,
    boxrule=0.7pt,
    arc=2.2mm,
    left=2mm, right=2mm, top=1.2mm, bottom=1.2mm,
    before skip=2.5mm, after skip=2.5mm,
    title={#1},
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=ProofRed, colframe=ProofRed, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
}

% 便签风格 tipbox
\newtcolorbox{tipbox}[1][提示]{%
    enhanced, 
    breakable,
    colback=white,
    colframe=white,
    fonttitle=\bfseries\color{TipFrame},
    title={#1},
    attach title to upper,    
    after title={\newline},   
    before skip=3mm, 
    after skip=3mm,
    overlay={%
        \begin{tcbclipinterior}
            \draw[TipFrame!50, dashed, thin] 
            let \p1=(interior.south west), \p2=(interior.north west), \p3=(interior.east) 
            in 
            foreach \y in {0.5, 1.5, ..., 20} { 
                (\x1, \y1 + \y*1.2em) -- (\x3, \y1 + \y*1.2em) 
            };
        \end{tcbclipinterior}
    }
}

\newtcolorbox{remarkbox}[1][]{%
    enhanced, breakable,
    colback=RemarkBg,
    colframe=RemarkFrame,
    coltitle=white,
    fonttitle=\bfseries,
    boxrule=0.55pt, arc=2.2mm,
    left=2mm, right=2mm, top=1.2mm, bottom=1.2mm,
    before skip=2.5mm, after skip=2.5mm,
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=RemarkFrame, colframe=RemarkFrame, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
    title={#1}
}

\newtcolorbox{examplebox}[1][]{%
    enhanced, breakable,
    colback=ExampleBg,
    colframe=ExampleFrame,
    coltitle=TitleGray,
    fonttitle=\bfseries,
    boxrule=0.55pt, arc=2.2mm,
    left=2mm, right=2mm, top=1.2mm, bottom=1.2mm,
    before skip=2.5mm, after skip=2.5mm,
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=ExampleFrame, colframe=ExampleFrame, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
    title={#1}
}

\newtcolorbox{exercisebox}[1][]{%
    enhanced, breakable,
    colback=ExerciseBg,
    colframe=ExerciseFrame,
    coltitle=TitleGray,
    fonttitle=\bfseries,
    boxrule=0.55pt, arc=2.2mm,
    left=2mm, right=2mm, top=1.2mm, bottom=1.2mm,
    before skip=2.5mm, after skip=2.5mm,
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=ExerciseFrame, colframe=ExerciseFrame, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
    title={#1}
}

% 思考环境
\newtcolorbox{sikao}[1][思考]{%
    enhanced, 
    breakable,
    colback=red!10,
    colframe=white,
    borderline={0.5pt}{0pt}{red!30},
    fonttitle=\bfseries\color{red!70!black},
    title={#1},
    attach title to upper,
    after title={\newline},
    before skip=3mm, 
    after skip=3mm,
    overlay={%
        \node[anchor=north east, red!30, font=\fontsize{40}{40}\bfseries] 
        at ([xshift=-2mm, yshift=-2mm]frame.north east) {?};
    }
}

% -----------------------------
% 基础环境定义（article 下重新定义）
% -----------------------------
\makeatletter
\@ifundefined{definition}{%
    \newenvironment{definition}[1][定义]{\begin{definitionbox}[#1]}{\end{definitionbox}}
}{%
    \renewenvironment{definition}[1][定义]{\begin{definitionbox}[#1]}{\end{definitionbox}}
}
\@ifundefined{theorem}{%
    \newenvironment{theorem}[1][定理]{\begin{theorembox}[#1]}{\end{theorembox}}
}{%
    \renewenvironment{theorem}[1][定理]{\begin{theorembox}[#1]}{\end{theorembox}}
}
\@ifundefined{remark}{%
    \newenvironment{remark}[1][注]{\begin{remarkbox}[#1]}{\end{remarkbox}}
}{%
    \renewenvironment{remark}[1][注]{\begin{remarkbox}[#1]}{\end{remarkbox}}
}

\@ifundefined{tip}{%
    \newenvironment{tip}[1][提示]{\begin{tipbox}[#1]}{\end{tipbox}}
}{%
    \renewenvironment{tip}[1][提示]{\begin{tipbox}[#1]}{\end{tipbox}}
}

% 证明环境
\let\proof\relax
\let\endproof\relax
\NewDocumentEnvironment{proof}{O{证明}}{%
    \par\medskip
    \noindent{\color{ProofRed}\bfseries #1：}%
    \par\vspace{0.3em}%
    \ignorespaces
}{%
    \par\medskip
}

% 答案与解析环境
\newenvironment{answer}{%
    \par\medskip
    \noindent{\color{ProofRed}\bfseries【答案】：}
    \par\vspace{0.3em}
}{%
    \par\medskip
}
\newenvironment{solutions}{%
    \par\medskip
    \noindent{\color{ProofRed}\bfseries【解析】：}
    \par\vspace{0.3em}
}{%
    \par\medskip
}
\makeatother

% -----------------------------
% 例题/练习环境（带来源标注，与 beamer 版一致）
% -----------------------------
\makeatletter
\newcounter{examplectr}
\newcounter{exercisectr}
\renewcommand{\theexamplectr}{\arabic{examplectr}}
\renewcommand{\theexercisectr}{\arabic{exercisectr}}

\newcommand{\build@example@title}[6]{%
    \def\@titletext{#1}%
    \def\@suffix{}%
    \ifblank{#2}{}{\def\@partA{#2}}%
    \ifblank{#3}{}{\ifblank{#2}{\def\@partA{#3}}{\def\@partA{#2#3}}}%
    \ifblank{#4}{}{\def\@partB{#4}}%
    \ifblank{#5}{}{\ifblank{#4}{\def\@partB{#5}}{\def\@partB{#4#5}}}%
    \def\@partC{#6}%
    \ifdefvoid{\@partA}{}{\ifdefvoid{\@suffix}{}{\edef\@suffix{\@suffix, }}\edef\@suffix{\@suffix\@partA}}%
    \ifdefvoid{\@partB}{}{\ifdefvoid{\@suffix}{}{\edef\@suffix{\@suffix, }}\edef\@suffix{\@suffix\@partB}}%
    \ifblank{#6}{}{\ifdefvoid{\@suffix}{}{\edef\@suffix{\@suffix, }}\edef\@suffix{\@suffix\@partC}}%
    \ifdefvoid{\@suffix}{}{%
        \edef\@titletext{\@titletext ：(\@suffix)}%
    }%
    \gdef\@temp@title{\@titletext}%
}

\NewDocumentEnvironment{example}{m O{} O{} O{} O{} O{}}{%
    \stepcounter{examplectr}%
    \build@example@title{例题\theexamplectr}{#2}{#3}{#4}{#5}{#6}%
    \begin{examplebox}[\@temp@title]%
}{%
    \end{examplebox}%
}

\NewDocumentEnvironment{exercise}{m O{} O{} O{} O{} O{}}{%
    \stepcounter{exercisectr}%
    \build@example@title{练习题\theexercisectr}{#2}{#3}{#4}{#5}{#6}%
    \begin{exercisebox}[\@temp@title]%
}{%
    \end{exercisebox}%
}
\makeatother

% -----------------------------
% 标题页艺术元素（与 beamer 相同）
% -----------------------------
\newcommand{\TitlePageArtwork}{%
    \begin{tikzpicture}[remember picture,overlay]
        \begin{scope}[shift={($(current page.south east)+(-0.9cm,0.55cm)$)}]
            \foreach \x in {-6.8,-6.4,...,0} {
                \draw[LineGray!12,line width=0.2pt] (\x,0) -- (\x,5.0);
            }
            \foreach \y in {0.4,0.8,...,4.8} {
                \draw[LineGray!12,line width=0.2pt] (-7.0,\y) -- (0,\y);
            }
            \draw[LineGray!45,line width=0.45pt] (-5.1,2.5) circle (1.55);
            \draw[PrimaryGreen!70,line width=0.7pt]
                (-5.1,2.5) ++(20:0.22) arc[start angle=20,end angle=320,radius=0.22]
                arc[start angle=320,end angle=620,radius=0.45]
                arc[start angle=620,end angle=940,radius=0.68]
                arc[start angle=940,end angle=1280,radius=0.92];
            \draw[LineGray!32,line width=0.3pt] (-5.1,2.5)--(-3.95,3.55);
            \draw[LineGray!32,line width=0.3pt] (-5.1,2.5)--(-6.15,3.15);
            \draw[LineGray!32,line width=0.3pt] (-5.1,2.5)--(-4.0,1.45);
            \begin{scope}[shift={(-1.65,0.95)}]
                \draw[LineGray!60,line width=0.4pt,-{Latex[length=2mm]}] (-1.7,0)--(1.7,0);
                \draw[LineGray!60,line width=0.4pt,-{Latex[length=2mm]}] (0,-0.4)--(0,2.2);
                \draw[LineGray!75,line width=0.7pt,samples=100,domain=-1.4:1.4]
                    plot (\x,{0.42*sin(140*\x r)+1.1});
                \draw[PrimaryGreen!75,line width=0.75pt,samples=100,domain=-1.15:1.15]
                    plot (\x,{0.52*(\x*\x)+0.15});
                \fill[PrimaryGreen!90] (0,0.15) circle (0.045);
            \end{scope}
            \draw[LineGray!38,line width=0.35pt] (-6.5,0.65)--(-5.4,1.65)--(-4.8,0.55)--cycle;
            \draw[PrimaryGreen!60,line width=0.5pt] (-6.5,0.65)--(-4.8,0.55);
            \draw[LineGray!35,line width=0.3pt] (-5.4,1.65)--(-5.4,0.55);
            \draw[LineGray!35,line width=0.3pt,rounded corners=1pt] (-6.5,4.15) rectangle (-4.55,4.78);
            \node[font=\scriptsize,text=LineGray!85] at (-5.52,4.47) {$e^{i\pi}+1=0$};
            \draw[LineGray!35,line width=0.3pt,rounded corners=1pt] (-4.05,3.95) rectangle (-1.45,4.72);
            \node[font=\scriptsize,text=LineGray!82] at (-2.75,4.34)
                {$\displaystyle \int_a^b f(x)\,\mathrm{d}x$};
            \draw[LineGray!40,line width=0.35pt] (-0.75,2.95) circle (0.72);
            \node[font=\Large\bfseries,text=PrimaryGreen!75] at (-0.75,2.95) {$\pi$};
            \draw[LineGray!25,line width=0.25pt] (-0.75,2.95)--(-0.1,3.4);
            \draw[LineGray!25,line width=0.25pt] (-0.75,2.95)--(-0.05,2.95);
            \draw[LineGray!25,line width=0.25pt] (-0.75,2.95)--(-0.18,2.35);
            \foreach \p in {
                (-6.4,2.2),(-6.0,2.7),(-5.7,1.9),(-4.7,3.6),(-3.9,2.1),
                (-2.9,1.0),(-2.2,1.5),(-1.2,1.8),(-0.4,1.2)
            }{
                \fill[LineGray!40] \p circle (0.02);
            }
        \end{scope}
        \fill[PrimaryGreen] ($(current page.north west)+(1.0cm,-0.9cm)$) rectangle ++(1.55cm,-1.55cm);
        \node[white,font=\bfseries\Large] at ($(current page.north west)+(1.78cm,-1.68cm)$) {MATH};
    \end{tikzpicture}%
}

% 重定义 \maketitle
\renewcommand{\maketitle}{%
    \thispagestyle{empty}
    \TitlePageArtwork
    \vspace*{1.6cm}
    \hspace*{1.25cm}
    \begin{minipage}[t]{0.50\paperwidth}
        \vspace{0.5cm}
        {\color{PrimaryGreen}\bfseries\fontsize{24}{30}\selectfont \@title\par}
        \vspace{0.2cm}
        {\color{WarmGray}\Large \@date\par}
        \vspace{0.55cm}
        {\Large \@author\par}
    \end{minipage}
    \clearpage
}

% -----------------------------
% 数学样式：强制使用显示样式与上下限
% -----------------------------
\let\oldsum\sum
\renewcommand{\sum}{\displaystyle\oldsum\limits}
\let\oldprod\prod
\renewcommand{\prod}{\displaystyle\oldprod\limits}
\let\oldlim\lim
\renewcommand{\lim}{\displaystyle\oldlim\limits}
\let\oldmax\max
\renewcommand{\max}{\displaystyle\oldmax\limits}
\let\oldmin\min
\renewcommand{\min}{\displaystyle\oldmin\limits}
\let\oldfrac\frac
\renewcommand{\frac}{\dfrac}

% -----------------------------
% 辅助命令
% -----------------------------
\newcommand{\kaodian}[1]{\par\noindent\textbf{【考点】：}#1\par}
\newcommand{\blankbox}{（\hspace{1.5em}）}
\newcommand{\eblankbox}{(\hspace{1.5em})}
\newcommand{\blankline}{\underline{\hspace{3em}}}

% 章节页样式：在 \section 后自动插入装饰条（可选）
% 此处仅用 titlesec 定义美观标题，不强制分页

\endinput
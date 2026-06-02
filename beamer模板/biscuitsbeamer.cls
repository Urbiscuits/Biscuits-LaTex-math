% biscuitsbeamer.cls
% 基于 ctexbeamer 封装的数学教学演示文稿模板
% 作者：Biscuits
% 日期：2025-09-20

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{biscuitsbeamer}[2025/09/20 Biscuits Beamer Class for Math Teaching]

% -----------------------------
% 传递选项给 ctexbeamer
% -----------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbeamer}}
\ProcessOptions\relax
\LoadClass[aspectratio=169,11pt]{ctexbeamer}

% -----------------------------
% 基本宏包
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
\RequirePackage{pifont}     % 提供 \ding 命令（带圈数字）
\RequirePackage{listings}   % 代码高亮
\RequirePackage{tabularx}   % 选择题表格
\RequirePackage{ifthen}     % 条件判断
\RequirePackage{environ}    % \NewEnviron
\RequirePackage{xparse}     % 定义带多个可选参数的环境
\RequirePackage{etoolbox}   % \ifblank 等
\RequirePackage[normalem]{ulem} % 处理下划线

% 数学字体：仅数学部分使用衬线字体
\usefonttheme[onlymath]{serif}

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
\setbeamertemplate{navigation symbols}{}
\setbeamersize{text margin left=11mm, text margin right=11mm}

\setbeamerfont{structure}{series=\bfseries}
\setbeamercolor{normal text}{fg=TitleGray,bg=white}
\setbeamercolor{frametitle}{fg=PrimaryGreen,bg=white}
\setbeamercolor{title}{fg=PrimaryGreen}
\setbeamercolor{subtitle}{fg=WarmGray}
\setbeamercolor{author}{fg=TitleGray}
\setbeamercolor{date}{fg=WarmGray}

\setbeamercolor{block title}{fg=white,bg=PrimaryGreen}
\setbeamercolor{block body}{fg=TitleGray,bg=SoftGreen}
\setbeamercolor{block title alerted}{fg=white,bg=DeepGreen}
\setbeamercolor{block body alerted}{fg=TitleGray,bg=LightGray}
\setbeamercolor{itemize item}{fg=PrimaryGreen}
\setbeamercolor{itemize subitem}{fg=PrimaryGreen}
\setbeamercolor{itemize subsubitem}{fg=PrimaryGreen}
\setbeamercolor{section in toc}{fg=TitleGray}
\setbeamercolor{subsection in toc}{fg=WarmGray}

\setbeamerfont{title}{series=\bfseries,size=\LARGE}
\setbeamerfont{subtitle}{size=\large}
\setbeamerfont{frametitle}{series=\bfseries,size=\large}
\setbeamerfont{author}{size=\normalsize}
\setbeamerfont{date}{size=\normalsize}

% -----------------------------
% 项目符号风格
% -----------------------------
\setbeamertemplate{itemize item}{\small\raise0.15ex\hbox{\color{PrimaryGreen}\textbullet}}
\setbeamertemplate{itemize subitem}{\tiny\raise0.25ex\hbox{\color{PrimaryGreen}\textbullet}}
\setbeamertemplate{itemize subsubitem}{\tiny\raise0.25ex\hbox{\color{PrimaryGreen}\textbullet}}

% -----------------------------
% 页脚开关：控制短标题显示
% -----------------------------
\newif\ifshowfoottitle
\showfoottitlefalse   % 默认关闭

% 设置短标题的命令
\newcommand{\setfoottitle}{\showfoottitletrue}

% -----------------------------
% 页眉/页脚
% -----------------------------
\setbeamertemplate{headline}{}
\setbeamertemplate{footline}{%
    \leavevmode
    \hbox{%
        \begin{beamercolorbox}[wd=.12\paperwidth,ht=0.72cm,dp=0.18cm,leftskip=0.25cm,rightskip=0.1cm]{}
            \color{PrimaryGreen}\rule{0.95\linewidth}{1.2pt}
        \end{beamercolorbox}
        \begin{beamercolorbox}[wd=.74\paperwidth,ht=0.72cm,dp=0.18cm,leftskip=0.15cm,rightskip=0.15cm]{}
            \ifshowfoottitle
            \usebeamerfont{title}\color{WarmGray}\insertshorttitle
            \fi
            \hfill
        \end{beamercolorbox}
        \begin{beamercolorbox}[wd=.14\paperwidth,ht=0.72cm,dp=0.18cm,center]{}
            \usebeamerfont{date}\color{WarmGray}\insertframenumber\,/\,\inserttotalframenumber
        \end{beamercolorbox}
    }
}

% -----------------------------
% frametitle 版式：左侧标题 + 右侧细线
% -----------------------------
\setbeamertemplate{frametitle}{%
    \vspace{0.15cm}
    \begin{beamercolorbox}[wd=\paperwidth,ht=1.05cm,dp=0.18cm,leftskip=0.15cm,rightskip=0.15cm]{frametitle}
        \usebeamerfont{frametitle}\color{PrimaryGreen}\insertframetitle
        \hfill
        {\color{LineGray}\rule{0.18\paperwidth}{0.6pt}}
    \end{beamercolorbox}
    \vspace{-0.1cm}
}

% -----------------------------
% 带圈数字列表（① ② ③ …）
% -----------------------------
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
% 选择题排版
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
% 各环境专用盒子定义
% -----------------------------
\newtcolorbox{definitionbox}[1][]{%
    enhanced, breakable,
    colback=DefinitionBg,
    colframe=DefinitionFrame,
    coltitle=white,
    fonttitle=\bfseries,
    boxrule=0.55pt, arc=2.2mm,
    left=2mm, right=2mm, top=1.2mm, bottom=1.2mm,
    before skip=1.5mm, after skip=1.5mm,
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
    before skip=1.5mm, after skip=1.5mm,
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
    before skip=1.5mm, after skip=1.5mm,
    title={#1},
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=ProofRed, colframe=ProofRed, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
}

% 便签风格 tipbox
\newtcolorbox{tipbox}[1][提示]{%
    enhanced, 
    breakable,
    colback=white,            % 背景设为白色
    colframe=white,           % 边框透明
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
    before skip=1.5mm, after skip=1.5mm,
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
    before skip=1.5mm, after skip=1.5mm,
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
    before skip=1.5mm, after skip=1.5mm,
    attach boxed title to top left={xshift=2mm,yshift*=-\tcboxedtitleheight/2},
    boxed title style={colback=ExerciseFrame, colframe=ExerciseFrame, arc=2.2mm, boxrule=0pt, left=2mm, right=2mm, top=1mm, bottom=1mm},
    title={#1}
}

% 思考环境
\newtcolorbox{sikao}[1][思考]{%
    enhanced, 
    breakable,
    beamer,
    colback=red!10,            % 背景淡红
    colframe=white,            % 边框透明
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
% 基础环境定义
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
% 例题/练习环境（带来源标注）
% -----------------------------
\makeatletter
\newcounter{examplectr}
\newcounter{exercisectr}
\renewcommand{\theexamplectr}{\arabic{examplectr}}
\renewcommand{\theexercisectr}{\arabic{exercisectr}}

\newcommand{\build@example@title}[6]{%
    % #1: 自动编号文本（如“例题1”）
    % #2: 年份, #3: 地区, #4: 年级, #5: 类别, #6: 题号
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

\RenewDocumentEnvironment{example}{m O{} O{} O{} O{} O{}}{%
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
% 章节页：将标题放置在两条横线中间
% -----------------------------
\AtBeginSection[]{%
    \begin{frame}[plain,noframenumbering]
        \begin{tikzpicture}[remember picture,overlay]
            \fill[white] (current page.south west) rectangle (current page.north east);
            \fill[SoftGreen] (current page.south west) rectangle ($(current page.north east)+(0,-0.18\paperheight)$);
            \draw[PrimaryGreen, line width=1.1pt] 
            ($(current page.center)+(-5.0cm, 1.5cm)$) -- ++(2.6cm, 0);
            \node[anchor=center, text=PrimaryGreen, font=\bfseries\Huge] 
            at (current page.center) {\insertsection};
            \draw[LineGray, line width=0.6pt] 
            ($(current page.center)+(2.4cm, -1.5cm)$) -- ++(2.6cm, 0);
        \end{tikzpicture}
    \end{frame}
}

% -----------------------------
% 标题页背景：简洁建筑线稿风格
% -----------------------------
\newcommand{\TitlePageArtwork}{%
	\begin{tikzpicture}[remember picture,overlay]
		
		% =========================================================
		% 右下主视觉
		% =========================================================
		\begin{scope}[shift={($(current page.south east)+(-0.9cm,0.55cm)$)}]
			
			% -----------------------------------------------------
			% 极淡网格背景（无绿色大矩形）
			% -----------------------------------------------------
			\foreach \x in {-6.8,-6.4,...,0} {
				\draw[LineGray!12,line width=0.2pt] (\x,0) -- (\x,5.0);
			}
			
			\foreach \y in {0.4,0.8,...,4.8} {
				\draw[LineGray!12,line width=0.2pt] (-7.0,\y) -- (0,\y);
			}
			
			% =====================================================
			% 左侧：几何圆构成
			% =====================================================
			
			\draw[LineGray!45,line width=0.45pt]
			(-5.1,2.5) circle (1.55);
			
			\draw[PrimaryGreen!70,line width=0.7pt]
			(-5.1,2.5)
			++(20:0.22)
			arc[start angle=20,end angle=320,radius=0.22]
			arc[start angle=320,end angle=620,radius=0.45]
			arc[start angle=620,end angle=940,radius=0.68]
			arc[start angle=940,end angle=1280,radius=0.92];
			
			\draw[LineGray!32,line width=0.3pt]
			(-5.1,2.5)--(-3.95,3.55);
			
			\draw[LineGray!32,line width=0.3pt]
			(-5.1,2.5)--(-6.15,3.15);
			
			\draw[LineGray!32,line width=0.3pt]
			(-5.1,2.5)--(-4.0,1.45);
			
			% =====================================================
			% 中部：函数图像
			% =====================================================
			
			\begin{scope}[shift={(-1.65,0.95)}]
				
				\draw[LineGray!60,line width=0.4pt,-{Latex[length=2mm]}]
				(-1.7,0)--(1.7,0);
				
				\draw[LineGray!60,line width=0.4pt,-{Latex[length=2mm]}]
				(0,-0.4)--(0,2.2);
				
				\draw[LineGray!75,line width=0.7pt,samples=100,domain=-1.4:1.4]
				plot (\x,{0.42*sin(140*\x r)+1.1});
				
				\draw[PrimaryGreen!75,line width=0.75pt,samples=100,domain=-1.15:1.15]
				plot (\x,{0.52*(\x*\x)+0.15});
				
				\fill[PrimaryGreen!90] (0,0.15) circle (0.045);
				
			\end{scope}
			
			% =====================================================
			% 左下：几何三角结构
			% =====================================================
			
			\draw[LineGray!38,line width=0.35pt]
			(-6.5,0.65)--(-5.4,1.65)--(-4.8,0.55)--cycle;
			
			\draw[PrimaryGreen!60,line width=0.5pt]
			(-6.5,0.65)--(-4.8,0.55);
			
			\draw[LineGray!35,line width=0.3pt]
			(-5.4,1.65)--(-5.4,0.55);
			
			% =====================================================
			% 顶部公式卡片
			% =====================================================
			
			\draw[LineGray!35,line width=0.3pt,rounded corners=1pt]
			(-6.5,4.15) rectangle (-4.55,4.78);
			
			\node[font=\scriptsize,text=LineGray!85] at (-5.52,4.47)
			{$e^{i\pi}+1=0$};
			
			\draw[LineGray!35,line width=0.3pt,rounded corners=1pt]
			(-4.05,3.95) rectangle (-1.45,4.72);
			
			\node[font=\scriptsize,text=LineGray!82] at (-2.75,4.34)
			{$\displaystyle \int_a^b f(x)\,\mathrm{d}x$};
			
			% =====================================================
			% 右上抽象结构
			% =====================================================
			
			\draw[LineGray!40,line width=0.35pt]
			(-0.75,2.95) circle (0.72);
			
			\node[font=\Large\bfseries,text=PrimaryGreen!75] at (-0.75,2.95)
			{$\pi$};
			
			\draw[LineGray!25,line width=0.25pt]
			(-0.75,2.95)--(-0.1,3.4);
			
			\draw[LineGray!25,line width=0.25pt]
			(-0.75,2.95)--(-0.05,2.95);
			
			\draw[LineGray!25,line width=0.25pt]
			(-0.75,2.95)--(-0.18,2.35);
			
			% =====================================================
			% 点阵
			% =====================================================
			
			\foreach \p in {
				(-6.4,2.2),
				(-6.0,2.7),
				(-5.7,1.9),
				(-4.7,3.6),
				(-3.9,2.1),
				(-2.9,1.0),
				(-2.2,1.5),
				(-1.2,1.8),
				(-0.4,1.2)
			}{
				\fill[LineGray!40] \p circle (0.02);
			}
			
		\end{scope}
		
		% =========================================================
		% 左上 LOGO
		% =========================================================
		
		\fill[PrimaryGreen]
		($(current page.north west)+(1.0cm,-0.9cm)$)
		rectangle ++(1.55cm,-1.55cm);
		
		\node[white,font=\bfseries\Large]
		at ($(current page.north west)+(1.78cm,-1.68cm)$)
		{MATH};
		
	\end{tikzpicture}%
}

% 重定义标题页模板
\setbeamertemplate{title page}{%
    \TitlePageArtwork
    \vspace*{1.6cm}
    \hspace*{1.25cm}
    \begin{minipage}[t]{0.50\paperwidth}
        \vspace{0.5cm}
        {\color{PrimaryGreen}\bfseries\fontsize{24}{30}\selectfont \inserttitle\par}
        \vspace{0.2cm}
        {\color{WarmGray}\Large \insertsubtitle\par}
        \vspace{0.2cm}
        {\color{WarmGray}\normalsize \insertdate\par}
        \vspace{0.55cm}
        {\Large \insertauthor\par}
    \end{minipage}
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
% 设置目录显示页码，并使用圆形数字作为编号
\setbeamertemplate{sections/subsections in toc}[ball]
\setbeamertemplate{section in toc}[sections numbered]
% 如果需要明确标注页码（通常 Beamer 默认在目录页显示 section 对应的页数）
\setbeamercolor{section in toc}{fg=PrimaryGreen}

\newcommand{\kaodian}[1]{%
	\par\noindent\textbf{【考点】：}#1\par
}
\newcommand{\blankbox}{（\hspace{1.5em}）}
\newcommand{\eblankbox}{(\hspace{1.5em})}
\newcommand{\blankline}{\underline{\hspace{3em}}}
\makeatletter
% 定义开关（默认显示编号）
\newif\ifshowexamplenumber
\showexamplenumbertrue
\newif\ifshowexercisenumber
\showexercisenumbertrue

% 重定义 example 环境
\RenewDocumentEnvironment{example}{m O{} O{} O{} O{} O{}}{%
    \ifshowexamplenumber
        \stepcounter{examplectr}%
        \build@example@title{例题\theexamplectr}{#2}{#3}{#4}{#5}{#6}%
    \else
        \build@example@title{例题}{#2}{#3}{#4}{#5}{#6}%
    \fi
    \begin{examplebox}[\@temp@title]%
}{%
    \end{examplebox}%
}

% 重定义 exercise 环境
\RenewDocumentEnvironment{exercise}{m O{} O{} O{} O{} O{}}{%
    \ifshowexercisenumber
        \stepcounter{exercisectr}%
        \build@example@title{练习题\theexercisectr}{#2}{#3}{#4}{#5}{#6}%
    \else
        \build@example@title{练习题}{#2}{#3}{#4}{#5}{#6}%
    \fi
    \begin{exercisebox}[\@temp@title]%
}{%
    \end{exercisebox}%
}
\makeatother
\endinput
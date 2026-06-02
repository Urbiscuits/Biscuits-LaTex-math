\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{paper}[2025/08/22 Kirino House clean document class]

% ----- 选项处理（6题/5题）-----
\newif\if@problem@five \@problem@fivetrue % 默认5题
\DeclareOption{problem=5}{\@problem@fivetrue}
\DeclareOption{problem=6}{\@problem@fivefalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessOptions\relax

% --------------------
%   基于 ctexbook 类
% --------------------
\LoadClass[openright]{ctexbook}

% --------------------
%     宏包导入
% --------------------
\RequirePackage{silence}         
\RequirePackage{ifthen}
\RequirePackage{xstring}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{fontspec}       
\RequirePackage{xeCJK}          
\RequirePackage{unicode-math}   
\RequirePackage{bm}             
\RequirePackage{amsmath}        
\RequirePackage{tabularx}       
\RequirePackage{setspace}       
\RequirePackage{titlesec}       
\RequirePackage{titling}        
\RequirePackage{fancyhdr}       
\RequirePackage{ragged2e}       
\RequirePackage{afterpage}      
\RequirePackage{emptypage}      
\RequirePackage{wallpaper}      
\RequirePackage{tabularray}     
\UseTblrLibrary{amsmath}
\RequirePackage{enumitem}       
\RequirePackage{enumerate}
\RequirePackage{tasks}          
\RequirePackage{multicol}   
\RequirePackage{tikz}           
\usetikzlibrary{
	shapes, shadows, arrows.meta, shapes.geometric, fit, positioning,
	decorations.pathreplacing, angles, quotes, calc
}
\RequirePackage{tcolorbox}      
\tcbuselibrary{skins, breakable, theorems}
\RequirePackage{ulem}           
\normalem
\RequirePackage{paracol}        
\RequirePackage{lipsum}         
\RequirePackage{dashrule}       
\RequirePackage{pifont}         
\RequirePackage{romannum}       
\RequirePackage{newunicodechar} 

% --------------------
%     页面设置
% --------------------
\RequirePackage{geometry}
\geometry{
	a3paper,
	landscape,
	left=2cm,
	right=2cm,
	top=1cm,
	bottom=1cm
}

\setlength{\parindent}{0pt}
\newlength{\minipageheight}
\setlength{\minipageheight}{\paperheight}

% --------------------
%     字体设置
% --------------------
\setmathfont{XITS Math}

% --------------------
%     颜色设置
% --------------------
\definecolor{dd4d49}{HTML}{DD4D49}
\definecolor{e8a6a3}{HTML}{E8A6A3}
\definecolor{c9c9c9}{HTML}{C9C9C9}

% --------------------
%   自动样式设置
% --------------------
\newcommand{\ticketlength}{10}
% 分栏调整
\setlength{\columnsep}{0cm} % 栏间距

% 多栏环境拉伸行距开关
\raggedcolumns

%% 难度星级样式 (保留宏定义兼容主文件)
%\ExplSyntaxOn
%\clist_set:Nn \l_tmpa_clist {72,72,72,72,72,73,73,73,73,73}
%\cs_new:Npn \__ljguo_get_rating:n #1 {
%	\int_set:Nn \l_tmpa_int { 6 - #1 }
%	\int_set:Nn \l_tmpb_int { 10 - #1 }
%	\group_begin:
%	\color_select:n { black }
%	\int_step_inline:nnn { \l_tmpa_int } { \l_tmpb_int }
%	{
%		\large
%		\ding{\clist_item:Nn \l_tmpa_clist { ##1 }}
%	}
%	\group_end:
%}
%\let\getRating\__ljguo_get_rating:n
%\ExplSyntaxOff

% 选择题单个题目的 A,B,C,D 四个方框横向排列
\newcommand{\drawfourrects}{
	\begin{tikzpicture}[baseline=-0.2em]
		\def\rectwidth{13pt}
		\def\rectheight{3.5mm}
		\def\spacing{2.2mm} 
		\foreach \i/\letter in {0/$\mathsf{A}$,1/$\mathsf{B}$,2/$\mathsf{C}$,3/$\mathsf{D}$} {
			\draw[thick, dd4d49] (\i*\rectwidth + \i*\spacing, 0) 
			rectangle ++(\rectwidth,\rectheight);
			\node[anchor=center] at (\i*\rectwidth + \i*\spacing + 0.5*\rectwidth, 0.5*\rectheight)
			{\textbf{\fontsize{7.5pt}{8pt}\selectfont\color{dd4d49}\letter}};
		}
	\end{tikzpicture}
}

% 添加图片命令
\newcommand{\AddImage}[3]{%
	\IfFileExists{image/#1.png}{%
		\node[anchor=north east] at #3 {%
			\includegraphics[width=#2]{image/#1.png}%
		};
	}{}%
}

% --------------------
%     动态题号计数器
% --------------------
\newcounter{bigQone}
\newcounter{bigQtwo}
\newcounter{bigQthree}
\newcounter{bigQfour}
\newcounter{bigQfive}
\newcounter{bigQsix}   % 新增第六题计数器

\newcommand{\initQnumbers}[2]{
	\def\mcqcount{#1}
	\def\blankcount{#2}
	\setcounter{bigQone}{\numexpr #1 + #2 + 1\relax}
	\setcounter{bigQtwo}{\numexpr \value{bigQone} + 1\relax}
	\setcounter{bigQthree}{\numexpr \value{bigQtwo} + 1\relax}
	\setcounter{bigQfour}{\numexpr \value{bigQthree} + 1\relax}
	\setcounter{bigQfive}{\numexpr \value{bigQfour} + 1\relax}
	\if@problem@five\else
	\setcounter{bigQsix}{\numexpr \value{bigQfive} + 1\relax}
	\fi
}

% --------------------
%     分栏样式
% --------------------

% 正面左栏内容
\newcommand{\DrawAnswerSheetA}{
	\begin{tikzpicture}[remember picture,overlay]
		
		% 页眉封线
		\draw[line width=3mm, dash pattern=on 15pt off 9.5pt]
		(36pt,0) -- (0.99*\linewidth-36pt,0);
		\draw[line width=5mm]
		(0,1mm) -- ++(25pt,0);
		\draw[line width=5mm]
		(0.99*\linewidth-25pt,1mm) -- ++(25pt,0);
		
		% 标题栏
% 主标题
\node[
anchor=north,
align=center
] at (0.5\linewidth,-1.5em)
{
	\bfseries
	\fontsize{18pt}{27pt}\selectfont
	\color{dd4d49}
	\papertitle
};

% 副标题
\node[
anchor=north,
align=center
] at (0.5\linewidth,-4.0em)
{
	\bfseries
	\fontsize{14pt}{21pt}\selectfont
	\papername\ 答题卡
};
		% 姓名栏
		\node[anchor=north west, font=\bfseries] at (0, -7em) {%
			姓\hspace{2em}名\hspace{5pt}{\color{dd4d49}\underline{\hspace{120.5pt}}}%
		};
		
		% 准考证号栏
		\node[anchor=north west, font=\bfseries] at (0, -8.5em) {%
			准考证号\hspace{2.6pt}
			\raisebox{-0.25\height}{%
				\begin{tikzpicture}
					% 保持总宽度 120pt 不变，根据位数动态计算方框边长
					\pgfmathsetmacro{\squaresize}{120 / \ticketlength}
					\newcommand{\mytext}{}
					\foreach \x in {1,...,\ticketlength} {
						\draw[thick, dd4d49, fill=white] 
						({(\x-1)*\squaresize pt}, 0) rectangle ++(\squaresize pt, \squaresize pt) 
						node[pos=0.5, anchor=center] {\color{black}$\StrChar{\mytext}{\x}$};
					}
				\end{tikzpicture}%
			}
		};
		
		% logo 栏
		\def\minipagewidth{0.475\linewidth}
		\draw[thick, dash pattern=on 1pt off 1pt, dd4d49, rounded corners]
		(0.15, -10.7em) rectangle (\minipagewidth, -16.7em);
		% 原 Logo 图片已删除，框内留空
		
		% 考场号与座位号栏 
		\draw[thick, dd4d49] (0.15, -17.4em) rectangle (\minipagewidth, -19.0em);
		\node[anchor=west, font=\bfseries\heiti\fontsize{9pt}{10pt}\selectfont] at (0.3, -18.2em) {考场号};
		\draw[thick, dd4d49] (1.5, -18.7em) rectangle ++(11pt, 11pt);
		\draw[thick, dd4d49] (2.0, -18.7em) rectangle ++(11pt, 11pt);
		
		\node[anchor=west, font=\bfseries\heiti\fontsize{9pt}{10pt}\selectfont] at (2.9, -18.2em) {座位号};
		\draw[thick, dd4d49] (4.1, -18.7em) rectangle ++(11pt, 11pt);
		\draw[thick, dd4d49] (4.6, -18.7em) rectangle ++(11pt, 11pt);
		
		% 注意事项栏
		\fill[e8a6a3!40] (1.05*\minipagewidth, -17.4em) rectangle (0.99\linewidth, -19.0em);
		\draw[thick, dd4d49] (1.05*\minipagewidth, -7em) rectangle (0.99\linewidth, -19.0em);
		\draw[thick, dd4d49] (1.05*\minipagewidth, -8.4em) -- (0.99\linewidth,-8.4em);
		\node[anchor=north west, dd4d49, font=\fontsize{7pt}{8.4pt}\selectfont] at (1.055*\minipagewidth, -7.2em) {%
			\bfseries
			\raisebox{-0.1\height}{$\blacktriangle$}\hspace{0.85em}注意事项
		};
		\node[anchor=north west, text width=4*\linewidth/8, align=left, font=\fontsize{7pt}{8.4pt}\bfseries\selectfont, text=dd4d49] at (0.97*\minipagewidth, -7.6em) {%
			\begin{itemize}[align=right, labelwidth=2em, itemsep=-0.5em]
				\item[$1.$] 答题时间$120$分钟，建议计时完成。
				\item[$2.$] 选填题建议每题不超过$3$分钟，解答题建议每题不超过$12$分钟。
				\item[$3.$] 选择题按考试标准填涂，非选择题要求书写工整清晰，有必要的文字说明。
				\item[$4.$] 答案过于潦草无法识别，或将答题区域当作草纸用于演算，试题零分处理。
			\end{itemize}
		};
		%       \node[anchor=north west, font=\fontsize{7pt}{8.4pt}\selectfont] at (1.055*\minipagewidth, -%17.6em) {%
			%           \bfseries
			%           \raisebox{-0.1\height}{$\blacktriangle$}\hspace{0.85em}求助专区
			%       };
		
		% ======================================
		% 选择题区域（全动态计算以防越界）
		% ======================================
		\pgfmathsetmacro{\mcqcols}{ceil(\mcqcount/4)}
		\pgfmathsetmacro{\mcqheight}{2.4 * 4 + 1.5} 
		\pgfmathsetmacro{\mcqbottom}{-21 - \mcqheight}
		
		\draw[thick, dd4d49, rounded corners=1em] (0.15, -21em) rectangle (0.99\linewidth, \mcqbottom em);
		
		\node[anchor=north, fill=white, font=\bfseries] at (0.5\linewidth, -20em) {\color{black}第I部分：选择题};
		
		\pgfmathsetmacro{\mcqinnerbottom}{\mcqbottom + 0.9}
		\draw[thick] (0.3, -21.6em) rectangle ({0.99\linewidth-0.15cm}, \mcqinnerbottom em);
		\pgfmathsetmacro{\mcqtexty}{\mcqbottom + 1.1}
		\node[anchor=north, dd4d49, font=\fontsize{7pt}{8.4pt}\selectfont] at (0.5\linewidth, \mcqtexty em) {%
			\bfseries
			选择题请按题号用2B铅笔填涂方框，修改时用橡皮擦干净，不留痕迹
		};
		
		% 贴边黑白红定位扫描线
		\draw[line width=3mm, dd4d49] ({0.99\linewidth-20pt},-22.5em) -- ++(15pt,0);
		\draw[line width=3mm, c9c9c9] ({0.99\linewidth-20pt},-25.0em) -- ++(15pt,0);
		\draw[line width=3mm]        ({0.99\linewidth-20pt},-27.5em) -- ++(15pt,0);
		
		% 动态铺设选择题（题目序号纵向排列，一列四个，选项横向）
		\pgfmathsetmacro{\colstep}{11.2 / \mcqcols} 
		\foreach \i in {1,...,\mcqcount} {
			\pgfmathsetmacro{\col}{int((\i-1)/4)} 
			\pgfmathsetmacro{\row}{mod(\i-1,4)}     
			\node[anchor=north west] at (0.35 + \col*\colstep, -22.0em - \row*2.4em) {
				\makebox[1.2em][r]{\textbf{\i.}}\hspace{0.2em}\drawfourrects
			};
		}
		
		% ======================================
		% 非选择题区域（自动紧跟在选择题下方衔接）
		% ======================================
		\pgfmathsetmacro{\nonmcqtop}{\mcqbottom - 1}
		\draw[thick, dd4d49, fill=e8a6a3!40, rounded corners=1em] (0.15, \nonmcqtop em) rectangle (0.99\linewidth, -\textheight-0.35em);%底部填充高代
		\pgfmathsetmacro{\nonmcqinnertop}{\nonmcqtop - 2}%顶部填充高代
		\draw[thick, fill=white] (0.3, \nonmcqinnertop em) rectangle ({0.99\linewidth-0.15cm}, -\textheight+1.3em);
		
		% 【修改】非选择题大标题：居中、黑体、Huge
		\node[anchor=north, fill=e8a6a3!40, font=\bfseries] at (0.5\linewidth, \nonmcqtop em) {\color{black}第II部分：非选择题};
		
		\pgfmathsetmacro{\nonmcqtexty}{\nonmcqtop - 0.85}  % 增加一点垂直间距
		\node[anchor=north, font=\bfseries\fontsize{7pt}{8.4pt}\selectfont] at (0.5\linewidth, \nonmcqtexty em) {\color{dd4d49}（注意：请使用0.5毫米黑色墨水签字笔书写）};
		
		\pgfmathsetmacro{\blanktitley}{\nonmcqtop - 2}
		\node[anchor=north west, font=\bfseries] at (0.3, \blanktitley em) {填空题：每题5分};
		
		% 动态铺设填空题（一排两个）
		\pgfmathsetmacro{\blankstarty}{\blanktitley - 1.5}
		\foreach \j in {1,...,\blankcount} {
			\pgfmathsetmacro{\qnum}{int(\mcqcount + \j)}
			\pgfmathsetmacro{\col}{mod(\j-1,2)}
			\pgfmathsetmacro{\row}{int((\j-1)/2)}
			\node[anchor=north west] at (0.5 + \col*5.5, \blankstarty em - \row*2.5em) {
				\textbf{\qnum.} {\color{dd4d49}\underline{\hspace{4.0cm}}}
			};
		}
		
		% 动态铺设解答题分割线与第一道大题
		\pgfmathsetmacro{\blankrows}{ceil(\blankcount/2)}
		\pgfmathsetmacro{\splitliney}{\blankstarty - \blankrows*2.5 - 0.5}
		\draw[thick] (0.3, \splitliney em) -- ({0.99\linewidth-0.15cm}, \splitliney em);
		
		\pgfmathsetmacro{\bigqoney}{\splitliney - 1}
		\node[anchor=north west, font=\bfseries] at (0.4, \bigqoney em) {$\arabic{bigQone}.$};
		\AddImage{\arabic{bigQone}}{\imgwidthA}{({0.99\linewidth-0.3cm}, \bigqoney em)}
		
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, -\textheight+1.4em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
		
	\end{tikzpicture}
}

% 正面中栏内容
\newcommand{\DrawAnswerSheetB}{
	\begin{tikzpicture}[remember picture,overlay]
		\draw[thick, dd4d49, fill=e8a6a3!40, rounded corners=1em] (0.15, -0em) rectangle (0.99\linewidth, -\textheight);
		\draw[thick, fill=white] (0.3, -1.3em) rectangle ({0.99\linewidth-0.15cm}, -\textheight+1.3em);
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, 0.1em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
		\node[anchor=north west, dd4d49, font=\bfseries] at (0.4, -2.3em) {（续$\arabic{bigQone}$题）};
		\draw[thick] (0.3, -23em) -- ({0.99\linewidth-0.15cm},-23em);
		\node[anchor=north west, font=\bfseries] at (0.4, -24em) {$\arabic{bigQtwo}.$};
		\AddImage{\arabic{bigQtwo}}{\imgwidthB}{({0.99\linewidth-0.3cm},-24em)}
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, -\textheight+1.4em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
	\end{tikzpicture}
}

% 正面右栏内容
\newcommand{\DrawAnswerSheetC}{
	\begin{tikzpicture}[remember picture,overlay]
		\draw[thick, dd4d49, fill=e8a6a3!40, rounded corners=1em] (0.15, -0em) rectangle (0.99\linewidth, -\textheight);
		\draw[thick, fill=white] (0.3, -1.3em) rectangle ({0.99\linewidth-0.15cm}, -\textheight+1.3em);
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, 0.1em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
		\node[anchor=north west, font=\bfseries] at (0.4, -2.3em) {$\arabic{bigQthree}.$};
		\AddImage{\arabic{bigQthree}}{\imgwidthC}{({0.99\linewidth-0.3cm},-2.3em)}
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, -\textheight+1.4em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
	\end{tikzpicture}
}

% 背面左栏内容
\newcommand{\DrawAnswerSheetD}{
	\begin{tikzpicture}[remember picture,overlay]
		\draw[thick, dd4d49, fill=e8a6a3!40, rounded corners=1em] (0.15, -0em) rectangle (0.99\linewidth, -\textheight);
		\draw[thick, fill=white] (0.3, -1.3em) rectangle ({0.99\linewidth-0.15cm}, -\textheight+1.3em);
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, 0.1em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
		\node[anchor=north west, font=\bfseries] at (0.4, -2.3em) {$\arabic{bigQfour}.$};
		\AddImage{\arabic{bigQfour}}{\imgwidthD}{({0.99\linewidth-0.3cm},-2.3em)}
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, -\textheight+1.4em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
	\end{tikzpicture}
}

% 背面中栏内容（根据 problem 选项自动切换布局）
\newcommand{\DrawAnswerSheetE}{
	\begin{tikzpicture}[remember picture,overlay]
		\draw[thick, dd4d49, fill=e8a6a3!40, rounded corners=1em] (0.15, -0em) rectangle (0.99\linewidth, -\textheight);
		\draw[thick, fill=white] (0.3, -1.3em) rectangle ({0.99\linewidth-0.15cm}, -\textheight+1.3em);
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, 0.1em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
		\if@problem@five
		% 5题模式：续第四题 + 第五题
		\node[anchor=north west, dd4d49, font=\bfseries] at (0.4, -2.3em) {（续$\arabic{bigQfour}$题）};
		\draw[thick] (0.3, -0.5\textheight) -- ({0.99\linewidth-0.15cm},-0.5\textheight);
		\node[anchor=north west, font=\bfseries] at (0.4, -0.5\textheight-1em) {$\arabic{bigQfive}.$};
		\AddImage{\arabic{bigQfive}}{\imgwidthE}{({0.99\linewidth-0.3cm},-0.5\textheight-1em)}
		\else
		% 6题模式：只有第五题
		\node[anchor=north west, font=\bfseries] at (0.4, -2.3em) {$\arabic{bigQfive}.$};
		\AddImage{\arabic{bigQfive}}{\imgwidthE}{({0.99\linewidth-0.3cm},-2.3em)}
		\fi
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, -\textheight+1.4em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
	\end{tikzpicture}
}

% 背面右栏内容（根据 problem 选项自动切换布局）
\newcommand{\DrawAnswerSheetF}{
	\begin{tikzpicture}[remember picture,overlay]
		\draw[thick, dd4d49, fill=e8a6a3!40, rounded corners=1em] (0.15, -0em) rectangle (0.99\linewidth, -\textheight);
		\draw[thick, fill=white] (0.3, -1.3em) rectangle ({0.99\linewidth-0.15cm}, -\textheight+1.3em);
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, 0.1em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
		\if@problem@five
		% 5题模式：续第五题
		\node[anchor=north west, dd4d49, font=\bfseries] at (0.4, -2.3em) {（续$\arabic{bigQfive}$题）};
		\else
		% 6题模式：第六题
		\node[anchor=north west, font=\bfseries] at (0.4, -2.3em) {$\arabic{bigQsix}.$};
		\AddImage{\arabic{bigQsix}}{\imgwidthF}{({0.99\linewidth-0.3cm},-2.3em)}
		\fi
		\node[anchor=north, dd4d49, font=\fontsize{10pt}{12pt}\selectfont] at (0.5\linewidth, -\textheight+1.4em) {%
			\bfseries
			请在各题指定区域内答题，超出黑色矩形边框限定区域的答案无效
		};
	\end{tikzpicture}
}
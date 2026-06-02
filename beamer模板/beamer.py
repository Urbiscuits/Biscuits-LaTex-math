import re
import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext

# ------------------------- 核心转换逻辑 -------------------------
def remove_parttitle(text):
    """删除所有 \parttitle{...} 命令及其内容"""
    return re.sub(r'\\parttitle\{[^}]*\}', '', text)

def parse_required_brace(text, start):
    """
    从 start 位置解析一个 { ... } 必选参数
    返回 (content, next_pos)
    """
    if start >= len(text) or text[start] != '{':
        raise ValueError(f"位置 {start} 需要 '{{'")
    depth = 1
    i = start + 1
    while i < len(text) and depth > 0:
        if text[i] == '{':
            depth += 1
        elif text[i] == '}':
            depth -= 1
        i += 1
    content = text[start+1:i-1]
    return content, i

def parse_optional_args(text, start):
    """解析多个连续的 [ ... ] 可选参数"""
    args = []
    i = start
    while i < len(text) and text[i] == '[':
        depth = 1
        j = i + 1
        while j < len(text) and depth > 0:
            if text[j] == '[':
                depth += 1
            elif text[j] == ']':
                depth -= 1
            j += 1
        arg = text[i+1:j-1]
        args.append(arg)
        i = j
        # 跳过空白
        while i < len(text) and text[i].isspace():
            i += 1
    return args, i

def find_matching_end(text, start, env_name):
    """找到匹配的 \end{env_name} (考虑嵌套)"""
    open_tag = f'\\begin{{{env_name}}}'
    close_tag = f'\\end{{{env_name}}}'
    depth = 1
    i = start
    while i < len(text):
        if text.startswith(open_tag, i):
            depth += 1
            i += len(open_tag)
        elif text.startswith(close_tag, i):
            depth -= 1
            i += len(close_tag)
            if depth == 0:
                return i
        else:
            i += 1
    raise ValueError(f"找不到匹配的 {close_tag}")

def extract_environment(text, pos):
    """
    从 pos 位置解析一个完整的 LaTeX 环境（支持必选参数 + 可选参数）
    返回 (env_name, required_arg, optional_args, content_start, end_tag_start)
    content_start 指向环境内容开始（可选参数之后）
    end_tag_start 指向 \end{env_name} 的开始位置
    """
    # 匹配 \begin{name}
    m = re.match(r'\\begin\{([a-zA-Z]+)\}', text[pos:])
    if not m:
        raise ValueError(f"位置 {pos} 没有找到 \\begin")
    env_name = m.group(1)
    name_end = pos + m.end()

    # 解析必选参数 { ... }
    required_arg, after_required = parse_required_brace(text, name_end)

    # 解析可选参数 [ ... ]
    optional_args, after_optional = parse_optional_args(text, after_required)

    content_start = after_optional
    end_pos = find_matching_end(text, content_start, env_name)
    # 找到 \end{env_name} 的开始位置
    end_tag_start = text.rfind(f'\\end{{{env_name}}}', 0, end_pos)
    return env_name, required_arg, optional_args, content_start, end_tag_start

def extract_proof_content(proof_text):
    """从 proof 内部提取 answer 和 solutions 内容"""
    answer_content = ""
    solutions_content = ""
    ans_pattern = re.compile(r'\\begin\{answer\}(.*?)\\end\{answer\}', re.DOTALL)
    sol_pattern = re.compile(r'\\begin\{solutions\}(.*?)\\end\{solutions\}', re.DOTALL)
    ans_match = ans_pattern.search(proof_text)
    if ans_match:
        answer_content = ans_match.group(1).strip()
    sol_match = sol_pattern.search(proof_text)
    if sol_match:
        solutions_content = sol_match.group(1).strip()
    return answer_content, solutions_content

def get_title_from_opt_args(opt_args):
    """从可选参数中提取标题（包含“第x题”的项）"""
    for arg in opt_args:
        if '第' in arg and '题' in arg:
            match = re.search(r'第\d+题', arg)
            if match:
                return match.group(0)
    return "题目"

def process_file(input_path, output_path, log_callback=None):
    """
    主转换函数：忽略所有外部文本，只将 example/exercise/sikao 环境转换为 frame
    """
    try:
        with open(input_path, 'r', encoding='utf-8') as f:
            content = f.read()
        if log_callback:
            log_callback(f"已读取输入文件：{input_path}")
    except Exception as e:
        raise Exception(f"读取输入文件失败：{e}")

    # 删除所有 \parttitle{} 命令
    content = remove_parttitle(content)
    if log_callback:
        log_callback("已删除所有 \\parttitle{} 命令")

    env_names = ['example', 'exercise', 'sikao']
    processed_env_count = 0
    out_frames = []          # 只存储生成的 frame 字符串

    idx = 0
    n = len(content)

    while idx < n:
        # 寻找下一个需要转换的环境
        found = False
        for env in env_names:
            pattern = re.compile(r'\\begin\{' + env + r'\}')
            m_env = pattern.search(content, idx)
            if m_env:
                found = True
                try:
                    (env_name, required_arg, opt_args,
                     cont_start, cont_end) = extract_environment(content, m_env.start())

                    # 环境内部完整文本（不含 \end{...}）
                    full_env_content = content[cont_start:cont_end]

                    # 分离题目与 proof
                    proof_pos = full_env_content.find('\\begin{proof}')
                    if proof_pos == -1:
                        question_text = full_env_content.strip()
                        answer_text = ""
                        solutions_text = ""
                    else:
                        question_text = full_env_content[:proof_pos].strip()
                        proof_end_pos = full_env_content.find('\\end{proof}', proof_pos)
                        if proof_end_pos == -1:
                            raise ValueError("proof 没有正确闭合")
                        proof_inner = full_env_content[proof_pos + len('\\begin{proof}'):proof_end_pos]
                        answer_text, solutions_text = extract_proof_content(proof_inner)

                    # 获取标题（从可选参数中提取“第x题”）
                    title = get_title_from_opt_args(opt_args)

                    # 重建环境开头，保留原始参数
                    env_open = f"\\begin{{{env_name}}}{{{required_arg}}}"
                    for opt in opt_args:
                        env_open += f"[{opt}]"

                    # 根据是否存在 answer/solutions 决定生成一个或两个 frame
                    has_answer_or_sol = bool(answer_text or solutions_text)

                    # Frame 1: 只有题目（总是生成）
                    frame1 = f"\\begin{{frame}}[allowframebreaks]{{{title}}}\n"
                    frame1 += f"{env_open}\n{question_text}\n\\end{{{env_name}}}\n"
                    frame1 += "\\end{frame}\n"
                    out_frames.append(frame1)

                    if has_answer_or_sol:
                        # Frame 2: 题目 + 答案 + 解析
                        frame2 = f"\\begin{{frame}}[allowframebreaks]{{{title}}}\n"
                        frame2 += f"{env_open}\n{question_text}\n\\end{{{env_name}}}\n"
                        if answer_text:
                            frame2 += f"\\begin{{answer}}\n{answer_text}\n\\end{{answer}}\n"
                        if solutions_text:
                            frame2 += f"\\begin{{solutions}}\n{solutions_text}\n\\end{{solutions}}\n"
                        frame2 += "\\end{frame}\n"
                        out_frames.append(frame2)

                    processed_env_count += 1
                    if log_callback:
                        log_callback(f"已处理：{env_name} 环境 (类型={required_arg}, 标题={title})" +
                                     (" [含答案/解析]" if has_answer_or_sol else " [仅题目]"))

                    # 移动到环境之后继续扫描
                    idx = cont_end + len(f'\\end{{{env_name}}}')
                except Exception as e:
                    err_msg = f"解析环境出错，跳过该环境：{e}"
                    if log_callback:
                        log_callback(err_msg)
                    # 尝试跳过这个环境
                    try:
                        _, _, _, _, end_tag = extract_environment(content, m_env.start())
                        idx = end_tag + len(f'\\end{{{env_name}}}')
                    except:
                        idx = m_env.start() + 1
                break  # 找到环境后跳出 for 循环

        if not found:
            # 没有找到更多环境，直接结束
            break

    # 写入输出文件（只包含生成的 frame）
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(''.join(out_frames))
        if log_callback:
            log_callback(f"转换完成！共处理 {processed_env_count} 个环境。输出文件：{output_path}")
        return True
    except Exception as e:
        raise Exception(f"写入输出文件失败：{e}")

# ------------------------- GUI 界面 -------------------------
class TeXConverterApp:
    def __init__(self, root):
        self.root = root
        self.root.title("LaTeX 环境转换器 (仅保留 Frame)")
        self.root.geometry("700x500")
        self.root.resizable(True, True)

        # 输入文件
        tk.Label(root, text="输入 .tex 文件：").grid(row=0, column=0, sticky='w', padx=5, pady=5)
        self.input_entry = tk.Entry(root, width=60)
        self.input_entry.grid(row=0, column=1, padx=5, pady=5)
        tk.Button(root, text="浏览...", command=self.select_input).grid(row=0, column=2, padx=5, pady=5)

        # 输出文件
        tk.Label(root, text="输出 .tex 文件：").grid(row=1, column=0, sticky='w', padx=5, pady=5)
        self.output_entry = tk.Entry(root, width=60)
        self.output_entry.grid(row=1, column=1, padx=5, pady=5)
        tk.Button(root, text="浏览...", command=self.select_output).grid(row=1, column=2, padx=5, pady=5)

        # 转换按钮
        self.convert_btn = tk.Button(root, text="开始转换", command=self.start_conversion,
                                     bg="#4CAF50", fg="white", font=("Arial", 10, "bold"))
        self.convert_btn.grid(row=2, column=1, pady=10)

        # 日志区域
        tk.Label(root, text="转换日志：").grid(row=3, column=0, sticky='nw', padx=5)
        self.log_area = scrolledtext.ScrolledText(root, width=80, height=25, wrap=tk.WORD)
        self.log_area.grid(row=4, column=0, columnspan=3, padx=5, pady=5, sticky='nsew')
        self.log_area.config(state=tk.DISABLED)

        root.grid_rowconfigure(4, weight=1)
        root.grid_columnconfigure(1, weight=1)

    def log(self, message):
        self.log_area.config(state=tk.NORMAL)
        self.log_area.insert(tk.END, message + "\n")
        self.log_area.see(tk.END)
        self.log_area.config(state=tk.DISABLED)
        self.root.update_idletasks()

    def select_input(self):
        filename = filedialog.askopenfilename(filetypes=[("TeX files", "*.tex"), ("All files", "*.*")])
        if filename:
            self.input_entry.delete(0, tk.END)
            self.input_entry.insert(0, filename)
            if not self.output_entry.get():
                out_file = filename.rsplit('.', 1)[0] + "_frames_only.tex"
                self.output_entry.insert(0, out_file)

    def select_output(self):
        filename = filedialog.asksaveasfilename(defaultextension=".tex", filetypes=[("TeX files", "*.tex"), ("All files", "*.*")])
        if filename:
            self.output_entry.delete(0, tk.END)
            self.output_entry.insert(0, filename)

    def start_conversion(self):
        input_path = self.input_entry.get().strip()
        output_path = self.output_entry.get().strip()
        if not input_path:
            messagebox.showerror("错误", "请选择输入文件")
            return
        if not output_path:
            messagebox.showerror("错误", "请指定输出文件")
            return

        self.convert_btn.config(state=tk.DISABLED, text="转换中...")
        self.log_area.config(state=tk.NORMAL)
        self.log_area.delete(1.0, tk.END)
        self.log_area.config(state=tk.DISABLED)

        try:
            process_file(input_path, output_path, log_callback=self.log)
            messagebox.showinfo("完成", "转换成功完成！")
        except Exception as e:
            self.log(f"转换失败：{e}")
            messagebox.showerror("转换失败", str(e))
        finally:
            self.convert_btn.config(state=tk.NORMAL, text="开始转换")

if __name__ == "__main__":
    root = tk.Tk()
    app = TeXConverterApp(root)
    root.mainloop()

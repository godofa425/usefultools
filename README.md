# Gemini API 脚本工具

一个简单易用的 Gemini API 调用脚本，支持视频内容分析和文本生成。

## 安装方式

### 方式1: 一键安装（推荐）
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/godofa425/usefultools/main/install.sh)
```

### 方式2: 交互式安装（支持API key设置）
```bash
curl -O https://raw.githubusercontent.com/godofa425/usefultools/main/install.sh
chmod +x install.sh && ./install.sh
```

## 使用方法

### 基本使用
```bash
# 使用默认提示（总结视频）
./gemini.sh

# 自定义提示和视频链接
./gemini.sh "请详细分析这个视频的内容" "https://www.youtube.com/watch?v=your-video-id"
```

### 首次设置
1. **安装时设置**: 使用一键安装命令时会提示输入 API Key
2. **或运行时设置**: 首次运行脚本时会提示输入 API Key
3. 访问 [Google AI Studio](https://aistudio.google.com/u/1/apikey) 创建 API Key
4. 输入后会自动保存，按提示运行 `source` 命令（仅需一次）
5. 之后可直接使用 `gemini.sh` 命令

## 输出文件

脚本会自动生成两个文件：
- `gemini_response_YYYYMMDD_HHMMSS.txt` - 完整的 API 响应
- `gemini_text_YYYYMMDD_HHMMSS.txt` - 提取的生成内容

## 系统要求

- macOS 或 Linux

## 获取帮助

```bash
./gemini.sh --help
```

or 

如果你在使用过程中遇到问题或有任何建议，欢迎联系我：

**X**: [CallMeYC](https://x.com/SGodofa425)

## 直接运行（无需安装）

```bash
curl -fsSL https://raw.githubusercontent.com/godofa425/usefultools/main/gemini.sh | bash
```

---

**注意**: 首次使用需要 Google Gemini API Key。免费额度足够个人使用。

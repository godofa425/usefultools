# Gemini API 脚本工具

一个简单易用的 Gemini API 调用脚本，支持视频内容分析和文本生成。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/godofa425/usefultools/main/install.sh | bash
```

## 使用方法

### 基本使用
```bash
# 使用默认提示（总结视频）
./gemini.sh

# 自定义提示和视频链接
./gemini.sh "请详细分析这个视频的内容" "https://www.youtube.com/watch?v=your-video-id"
```

### 首次运行
1. 脚本会提示你输入 Gemini API Key
2. 访问 [Google AI Studio](https://aistudio.google.com/u/1/apikey) 创建 API Key
3. 输入 API Key 后，脚本会自动保存到你的 shell 配置文件
4. 按提示重新加载配置即可使用

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

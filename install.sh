#!/bin/bash

# Gemini API Script Installer
# 一键安装 Gemini API 脚本

set -e

SCRIPT_NAME="gemini.sh"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_URL="https://raw.githubusercontent.com/godofa425/usefultools/main/gemini.sh"

echo "正在安装 Gemini API 脚本..."
echo ""

# Create install directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "创建安装目录: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Download the script
echo "正在下载脚本..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$SCRIPT_URL" -O "$INSTALL_DIR/$SCRIPT_NAME"
else
    echo "错误: 需要 curl 或 wget 来下载脚本"
    exit 1
fi

# Make executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Check if install directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "注意: $INSTALL_DIR 不在你的 PATH 中"
    echo ""
    
    # Detect shell and add to appropriate config file
    if [[ "$SHELL" == */zsh ]]; then
        config_file="$HOME/.zshrc"
    elif [[ "$SHELL" == */bash ]]; then
        config_file="$HOME/.bash_profile"
    else
        config_file="$HOME/.profile"
    fi
    
    echo "正在添加到 $config_file..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$config_file"
    echo "PATH 已更新"
    echo ""
    echo "请运行以下命令使更改生效:"
    echo "  source $config_file"
    echo ""
fi

# Setup API key
echo "正在设置 Gemini API Key..."
echo ""
echo "请访问以下链接创建 API Key: https://aistudio.google.com/u/1/apikey"
echo ""

# Check if API key already exists
if [ -z "$GEMINI_API_KEY" ]; then
    # Always try to read from /dev/tty first
    if [ -t 0 ] || [ -e /dev/tty ]; then
        echo -n "请输入您的 Gemini API Key (留空跳过): "
        if read -s api_key </dev/tty 2>/dev/null; then
            echo ""
        else
            # Fallback to normal read
            read -s api_key
            echo ""
        fi
    else
        echo "无法在当前环境中交互输入 API Key"
        echo "请稍后运行 gemini.sh 时手动设置"
        echo ""
        api_key=""
    fi
    
    if [ -n "$api_key" ]; then
        # Detect shell and save API key
        if [[ "$SHELL" == */zsh ]]; then
            config_file="$HOME/.zshrc"
            source_cmd="source ~/.zshrc"
        elif [[ "$SHELL" == */bash ]]; then
            config_file="$HOME/.bash_profile"
            source_cmd="source ~/.bash_profile"
        else
            config_file="$HOME/.profile"
            source_cmd="source ~/.profile"
        fi
        
        # Save API key
        if ! grep -q "export GEMINI_API_KEY=" "$config_file" 2>/dev/null; then
            echo "export GEMINI_API_KEY=\"$api_key\"" >> "$config_file"
            echo "API Key 已保存到 $config_file"
        else
            # Update existing key
            grep -v "export GEMINI_API_KEY=" "$config_file" > "$config_file.tmp" 2>/dev/null || touch "$config_file.tmp"
            echo "export GEMINI_API_KEY=\"$api_key\"" >> "$config_file.tmp"
            mv "$config_file.tmp" "$config_file"
            echo "API Key 已更新"
        fi
        
        api_key_set=true
    else
        echo "跳过 API Key 设置，稍后首次运行时会提示设置"
        api_key_set=false
    fi
else
    echo "检测到现有的 GEMINI_API_KEY"
    api_key_set=true
fi

echo ""
echo "安装完成!"
echo ""
echo "使用方法:"
echo "  $SCRIPT_NAME \"用中文输出这个视频的文字脚本，无需时间戳\" \"https://www.youtube.com/watch?v=9hE5-98ZeCg\" "
echo ""

# Show next steps
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]] || [ "$api_key_set" = true ]; then
    echo "请运行以下命令使更改生效:"
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo "  $source_cmd"
    else
        echo "  source $config_file  # 加载 API Key"
    fi
    echo ""
    echo "然后就可以直接运行: $SCRIPT_NAME"
else
    echo "你现在可以直接运行: $SCRIPT_NAME"
fi

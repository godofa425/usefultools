#!/bin/bash

# Gemini API Script Installer
# 一键安装 Gemini API 脚本

set -e

SCRIPT_NAME="gemini.sh"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_URL="https://raw.githubusercontent.com/godofa425/usefultools/main/gemini.sh"

echo "🚀 正在安装 Gemini API 脚本..."
echo ""

# Create install directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📁 创建安装目录: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Download the script
echo "⬇️  正在下载脚本..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$SCRIPT_URL" -O "$INSTALL_DIR/$SCRIPT_NAME"
else
    echo "❌ 错误: 需要 curl 或 wget 来下载脚本"
    exit 1
fi

# Make executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Check if install directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠️  注意: $INSTALL_DIR 不在你的 PATH 中"
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
    echo "✅ PATH 已更新"
    echo ""
    echo "请运行以下命令使更改生效:"
    echo "  source $config_file"
    echo ""
fi

echo "🎉 安装完成!"
echo ""
echo "使用方法:"
echo "  $SCRIPT_NAME                    # 使用默认提示"
echo "  $SCRIPT_NAME \"你的提示\" \"视频链接\"   # 自定义提示"
echo ""

# If PATH was updated, suggest sourcing
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "💡 提示: 重新加载shell配置后，你可以在任何地方运行 '$SCRIPT_NAME'"
else
    echo "💡 你现在可以在任何地方运行 '$SCRIPT_NAME'"
fi

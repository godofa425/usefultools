#!/bin/bash

# Gemini API Script
# This script calls the Gemini API to generate content based on text and file inputs

# Function to check and set API key
check_api_key() {
    if [ -z "$GEMINI_API_KEY" ]; then
        echo "未找到 GEMINI_API_KEY 环境变量。"
        echo ""
        echo "请访问以下链接创建新的 API key: https://aistudio.google.com/u/1/apikey"
        echo ""
        read -p "请输入您的 Gemini API key: " -s api_key
        echo
        
        if [ -z "$api_key" ]; then
            echo "错误: 未提供 API key，退出程序。"
            exit 1
        fi
        
        # Detect shell and save API key to appropriate config file
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
            echo "✓ API key 已保存到 $config_file"
        else
            # Update existing key
            grep -v "export GEMINI_API_KEY=" "$config_file" > "$config_file.tmp" 2>/dev/null || touch "$config_file.tmp"
            echo "export GEMINI_API_KEY=\"$api_key\"" >> "$config_file.tmp"
            mv "$config_file.tmp" "$config_file"
            echo "✓ API key 已更新到 $config_file"
        fi
        
        echo ""
        echo "==============================================="
        echo "           API Key 设置完成!"
        echo "==============================================="
        echo ""
        echo "首次使用前，请先运行以下命令:"
        echo ""
        echo "    $source_cmd"
        echo ""
        echo "注意: 上述命令只需执行一次！"
        echo ""
        echo "==============================================="
        echo "然后就可以重新运行:"
        echo "  ./gemini.sh 或 gemini.sh (如果在PATH中)"
        echo ""
        exit 0
    else
        echo "使用现有的 GEMINI_API_KEY 环境变量。"
    fi
}

# Function to call Gemini API
call_gemini_api() {
    local text_prompt="${1:-请用中文, 3句话总结这个视频。}"
    local file_uri="${2:-https://www.youtube.com/watch?v=9hE5-98ZeCg}"
    
    echo "正在调用 Gemini API..."
    echo "Prompt: $text_prompt"
    echo "文件链接: $file_uri"
    echo "----------------------------------------"
    
    # Make the API call and capture response
    local response=$(curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent" \
        -H "x-goog-api-key: $GEMINI_API_KEY" \
        -H 'Content-Type: application/json' \
        -X POST \
        -d "{
          \"contents\": [{
            \"parts\":[
                {\"text\": \"$text_prompt\"},
                {
                  \"file_data\": {
                    \"file_uri\": \"$file_uri\"
                  }
                }
            ]
          }]
        }" 2>/dev/null)
    
    # Check if curl was successful
    if [ $? -ne 0 ]; then
        echo "错误: 调用 Gemini API 失败"
        exit 1
    fi
    
    # Generate timestamp for filename
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local output_file="gemini_response_${timestamp}.txt"
    
    # Write the full response to file
    echo "$response" > "$output_file"
    
    # Parse and display the response
    echo "API 响应:"
    echo "----------------------------------------"
    
    # Try to extract the text content using basic text processing
    # This assumes the response contains a "text" field with the generated content
    local generated_text=$(echo "$response" | grep -o '"text"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"text"[[:space:]]*:[[:space:]]*"//g' | sed 's/"$//g')
    
    if [ -n "$generated_text" ]; then
        echo "生成内容:"
        echo "$generated_text"
        
        # Also write just the generated text to a separate file
        local text_file="gemini_text_${timestamp}.txt"
        echo "$generated_text" > "$text_file"
        echo "生成的文本已保存到: $text_file"
    else
        echo "原始响应:"
        echo "$response" | python3 -m json.tool 2>/dev/null || echo "$response"
    fi
    
    echo "----------------------------------------"
    echo "完整响应已保存到: $output_file"
}

# Function to show usage
show_usage() {
    echo "用法: $0 [文本提示] [文件链接]"
    echo ""
    echo "示例:"
    echo "  $0"
    echo "  $0 \"描述这个视频\" \"https://www.youtube.com/watch?v=example\""
    echo ""
}

# Main execution
main() {
    # Show usage if help requested
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi
    
    # Check and set API key
    check_api_key
    
    # Call the API
    call_gemini_api "$1" "$2"
}

# Run main function with all arguments
main "$@"

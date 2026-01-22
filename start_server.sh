#!/bin/bash

# 启动本地HTTP服务器脚本

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

# 检查端口是否被占用
if lsof -ti:8000 > /dev/null 2>&1; then
    echo "端口8000已被占用，正在清理..."
    lsof -ti:8000 | xargs kill -9 2>/dev/null
    sleep 1
fi

# 启动服务器
echo "正在启动HTTP服务器..."
echo "访问地址: http://localhost:8000/compliance_agent_solution.html"
echo "按 Ctrl+C 停止服务器"
echo ""

python3 -m http.server 8000






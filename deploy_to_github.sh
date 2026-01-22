#!/bin/bash

# 部署合规智能体方案到 GitHub
# 仓库: https://github.com/kehan857/heguiagent.git

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

# 检查文件是否存在
if [ ! -f "compliance_agent_solution.html" ]; then
    echo "错误: compliance_agent_solution.html 文件不存在"
    exit 1
fi

# 初始化 Git 仓库（如果还没有）
if [ ! -d ".git" ]; then
    echo "初始化 Git 仓库..."
    git init
fi

# 添加远程仓库
git remote remove origin 2>/dev/null
git remote add origin https://github.com/kehan857/heguiagent.git

# 添加文件
echo "添加文件到 Git..."
git add compliance_agent_solution.html

# 提交更改
echo "提交更改..."
git commit -m "更新合规智能体方案：添加知识库维护、人工审核、一键修改等功能" || echo "没有新更改或已提交"

# 设置分支并推送
echo "推送到 GitHub..."
git branch -M main
git push -u origin main --force

echo "完成！文件已推送到 https://github.com/kehan857/heguiagent.git"






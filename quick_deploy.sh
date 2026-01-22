#!/bin/bash
set -e

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

echo "=== 开始部署到 GitHub ==="
echo ""

# 初始化 Git
if [ ! -d ".git" ]; then
    echo "1. 初始化 Git 仓库..."
    git init
fi

# 配置远程仓库
echo "2. 配置远程仓库..."
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/kehan857/heguiagent.git

# 添加文件
echo "3. 添加文件..."
git add compliance_agent_solution.html

# 提交
echo "4. 提交更改..."
git commit -m "更新合规智能体方案：添加知识库维护、人工审核、一键修改等功能" || echo "   (没有新更改或已提交)"

# 设置分支并推送
echo "5. 推送到 GitHub..."
git branch -M main
git push -u origin main --force

echo ""
echo "=== 部署完成！ ==="
echo "访问: https://github.com/kehan857/heguiagent"






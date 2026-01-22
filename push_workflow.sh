#!/bin/bash
set -e

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

echo "=========================================="
echo "  推送 GitHub Actions 工作流"
echo "=========================================="
echo ""

# 检查工作流文件
if [ ! -f ".github/workflows/deploy.yml" ]; then
    echo "❌ 错误: 工作流文件不存在"
    exit 1
fi
echo "✓ 工作流文件存在"

# 初始化 Git
if [ ! -d ".git" ]; then
    git init
fi

# 配置远程
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/kehan857/heguiagent.git 2>/dev/null || git remote set-url origin https://github.com/kehan857/heguiagent.git

# 添加所有文件
echo ""
echo "添加文件到 Git..."
git add .
git status --short

# 提交
echo ""
echo "提交更改..."
git commit -m "添加GitHub Actions工作流和合规智能体方案

- 添加 GitHub Pages 自动部署工作流
- 更新合规智能体方案页面
- 添加知识库维护、人工审核等功能" || echo "   (可能没有新更改)"

# 推送
echo ""
echo "推送到 GitHub..."
git branch -M main
git push -u origin main --force

echo ""
echo "=========================================="
echo "  ✓ 推送完成！"
echo "=========================================="
echo ""
echo "请访问以下链接检查:"
echo "  📦 仓库: https://github.com/kehan857/heguiagent"
echo "  ⚙️  Actions: https://github.com/kehan857/heguiagent/actions"
echo "  🌐 Pages: https://kehan857.github.io/heguiagent/"
echo ""
echo "如果 Actions 中没有看到工作流，请:"
echo "  1. 刷新 Actions 页面"
echo "  2. 检查 .github/workflows/ 目录是否在仓库中"
echo "  3. 手动触发: Actions → 选择工作流 → Run workflow"
echo ""






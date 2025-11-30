#!/bin/bash
set -e

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

echo "=========================================="
echo "  部署合规智能体方案到 GitHub Pages"
echo "=========================================="
echo ""

# 检查文件
if [ ! -f "compliance_agent_solution.html" ]; then
    echo "❌ 错误: compliance_agent_solution.html 不存在"
    exit 1
fi
echo "✓ 文件检查通过"

# 初始化 Git
if [ ! -d ".git" ]; then
    echo ""
    echo "1. 初始化 Git 仓库..."
    git init
fi

# 配置远程仓库
echo ""
echo "2. 配置远程仓库..."
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/kehan857/heguiagent.git 2>/dev/null || git remote set-url origin https://github.com/kehan857/heguiagent.git

# 确保工作流目录存在
mkdir -p .github/workflows

# 添加所有文件
echo ""
echo "3. 添加文件到 Git..."
git add compliance_agent_solution.html
git add .github/workflows/ 2>/dev/null || true
git add .nojekyll 2>/dev/null || true

# 显示状态
echo ""
echo "4. Git 状态:"
git status --short

# 提交
echo ""
echo "5. 提交更改..."
git commit -m "添加GitHub Actions工作流和更新合规智能体方案

- 添加知识库维护功能
- 添加人工审核功能
- 添加一键修改功能
- 添加内容对比查看和导出功能
- 优化审核建议展示
- 添加GitHub Actions自动部署工作流" || echo "   (可能没有新更改)"

# 设置分支
echo ""
echo "6. 设置主分支..."
git branch -M main

# 推送
echo ""
echo "7. 推送到 GitHub..."
echo "   这可能需要几秒钟..."
git push -u origin main --force

echo ""
echo "=========================================="
echo "  ✓ 部署完成！"
echo "=========================================="
echo ""
echo "📦 仓库地址: https://github.com/kehan857/heguiagent"
echo "🌐 GitHub Pages: https://kehan857.github.io/heguiagent/"
echo "⚙️  Actions: https://github.com/kehan857/heguiagent/actions"
echo ""
echo "提示: 如果 Actions 没有自动运行，请检查:"
echo "  1. GitHub Pages 设置中 Source 是否设置为 'Deploy from a branch'"
echo "  2. Branch 是否设置为 'main' 和 '/ (root)'"
echo "  3. 访问 Actions 标签页查看工作流状态"
echo ""


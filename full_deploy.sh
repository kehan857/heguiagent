#!/bin/bash

# 完整部署脚本 - 包含详细输出
set -e

WORK_DIR="/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
cd "$WORK_DIR"

echo "=========================================="
echo "  完整部署到 GitHub"
echo "=========================================="
echo ""
echo "工作目录: $(pwd)"
echo ""

# 1. 检查文件
echo "1. 检查文件..."
if [ ! -f "compliance_agent_solution.html" ]; then
    echo "❌ 错误: compliance_agent_solution.html 不存在"
    exit 1
fi
echo "   ✓ compliance_agent_solution.html 存在"

if [ ! -d ".github/workflows" ]; then
    echo "   ⚠ 创建 .github/workflows 目录..."
    mkdir -p .github/workflows
fi
echo "   ✓ .github/workflows 目录存在"
echo ""

# 2. 初始化 Git
echo "2. 初始化 Git 仓库..."
if [ ! -d ".git" ]; then
    git init
    echo "   ✓ Git 仓库已初始化"
else
    echo "   ✓ Git 仓库已存在"
fi
echo ""

# 3. 配置远程仓库
echo "3. 配置远程仓库..."
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/kehan857/heguiagent.git 2>/dev/null || git remote set-url origin https://github.com/kehan857/heguiagent.git
echo "   ✓ 远程仓库已配置: $(git remote get-url origin)"
echo ""

# 4. 创建 index.html（如果需要）
if [ ! -f "index.html" ]; then
    echo "4. 创建 index.html..."
    cp compliance_agent_solution.html index.html
    echo "   ✓ index.html 已创建"
else
    echo "4. index.html 已存在"
fi
echo ""

# 5. 添加所有文件
echo "5. 添加文件到 Git..."
git add .
echo "   已添加的文件:"
git status --short
echo ""

# 6. 提交
echo "6. 提交更改..."
git commit -m "添加合规智能体方案和GitHub Actions工作流

- 添加合规智能体方案页面（compliance_agent_solution.html）
- 添加知识库维护功能
- 添加人工审核功能
- 添加一键修改功能
- 添加内容对比查看和导出功能
- 添加GitHub Actions自动部署工作流" || {
    echo "   ⚠ 提交失败或没有新更改"
    echo "   检查状态..."
    git status
}
echo ""

# 7. 设置分支
echo "7. 设置主分支..."
git branch -M main
echo "   ✓ 当前分支: $(git branch --show-current)"
echo ""

# 8. 推送
echo "8. 推送到 GitHub..."
echo "   这可能需要几秒钟，请稍候..."
if git push -u origin main --force; then
    echo ""
    echo "=========================================="
    echo "  ✅ 推送成功！"
    echo "=========================================="
    echo ""
    echo "📦 仓库地址: https://github.com/kehan857/heguiagent"
    echo "⚙️  Actions: https://github.com/kehan857/heguiagent/actions"
    echo "🌐 GitHub Pages: https://kehan857.github.io/heguiagent/"
    echo ""
    echo "请访问 Actions 页面查看工作流运行状态"
else
    echo ""
    echo "❌ 推送失败"
    echo "可能的原因:"
    echo "  1. 需要身份认证（GitHub 用户名和密码/Token）"
    echo "  2. 网络连接问题"
    echo ""
    echo "解决方法:"
    echo "  1. 配置 GitHub Personal Access Token"
    echo "  2. 或使用 SSH 密钥"
    echo "  3. 手动执行: git push -u origin main --force"
fi
echo ""


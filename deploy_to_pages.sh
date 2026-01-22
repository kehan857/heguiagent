#!/bin/bash
# 完整部署到GitHub Pages脚本

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

echo "========================================="
echo "开始部署到 GitHub Pages"
echo "========================================="

# 1. 确保index.html是最新的
echo ""
echo "1. 更新 index.html..."
cp compliance_agent_solution.html index.html
if [ $? -eq 0 ]; then
    echo "✓ index.html 已更新"
else
    echo "✗ 更新失败"
    exit 1
fi

# 2. 检查Git状态
echo ""
echo "2. 检查Git状态..."
git status --short

# 3. 添加所有更改
echo ""
echo "3. 添加文件到Git..."
git add index.html compliance_agent_solution.html .github/workflows/pages.yml

# 4. 提交更改
echo ""
echo "4. 提交更改..."
git commit -m "部署更新: 确保GitHub Pages可访问 $(date '+%Y-%m-%d %H:%M:%S')" || echo "没有新更改"

# 5. 推送到GitHub
echo ""
echo "5. 推送到GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "✓ 推送成功！"
    echo "========================================="
    echo ""
    echo "下一步操作："
    echo "1. 访问 GitHub Actions: https://github.com/kehan857/heguiagent/actions"
    echo "2. 确认 'Deploy to GitHub Pages' 工作流正在运行"
    echo "3. 等待1-2分钟部署完成"
    echo "4. 访问页面: https://kehan857.github.io/heguiagent/"
    echo ""
    echo "如果页面无法访问，请检查："
    echo "- GitHub Pages设置: https://github.com/kehan857/heguiagent/settings/pages"
    echo "- Source 必须设置为 'GitHub Actions'"
    echo ""
else
    echo ""
    echo "✗ 推送失败，请检查错误信息"
    exit 1
fi

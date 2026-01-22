#!/bin/bash
# 更新index.html脚本

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

echo "正在更新 index.html..."
cp compliance_agent_solution.html index.html

echo "检查更新结果..."
if grep -q "天九网科企业数字化转型服务" index.html; then
    echo "✓ index.html 已更新为新内容"
else
    echo "✗ 更新失败"
    exit 1
fi

echo ""
echo "提交并推送..."
git add index.html
git commit -m "更新index.html以匹配最新内容" || echo "没有新更改"
git push origin main

echo ""
echo "完成！等待1-2分钟后访问: https://kehan857.github.io/heguiagent/"






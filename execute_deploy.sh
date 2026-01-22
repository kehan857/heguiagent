#!/bin/bash
# 完整部署脚本

set -x  # 显示执行的命令

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

echo "=== 步骤 1: 初始化 Git ==="
git init

echo "=== 步骤 2: 配置远程仓库 ==="
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/kehan857/heguiagent.git 2>/dev/null || git remote set-url origin https://github.com/kehan857/heguiagent.git

echo "=== 步骤 3: 创建 index.html ==="
cp compliance_agent_solution.html index.html

echo "=== 步骤 4: 添加文件 ==="
git add .

echo "=== 步骤 5: 查看状态 ==="
git status

echo "=== 步骤 6: 提交更改 ==="
git commit -m "添加合规智能体方案和GitHub Actions工作流" || echo "提交失败或没有新更改"

echo "=== 步骤 7: 设置主分支 ==="
git branch -M main

echo "=== 步骤 8: 推送到 GitHub ==="
git push -u origin main --force

echo "=== 完成 ==="






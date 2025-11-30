#!/bin/bash

# 快速推送脚本（无交互，使用默认提交信息）

cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

# 确保在main分支
git checkout -b main 2>/dev/null || git checkout main 2>/dev/null

# 添加所有更改
git add .

# 提交（使用时间戳作为提交信息）
COMMIT_MSG="更新: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG" || echo "没有需要提交的更改"

# 推送到远程
git push -u origin main --force

echo "推送完成！"


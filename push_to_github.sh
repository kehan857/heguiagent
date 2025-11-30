#!/bin/bash

# Git推送脚本 - 推送代码到GitHub
# 仓库地址: https://github.com/kehan857/heguiagent.git

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 项目目录
PROJECT_DIR="/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
REPO_URL="https://github.com/kehan857/heguiagent.git"

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Git 推送脚本${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# 进入项目目录
cd "$PROJECT_DIR"
echo -e "${GREEN}✓ 已进入项目目录${NC}"
echo "  目录: $PROJECT_DIR"
echo ""

# 检查Git是否已初始化
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}初始化Git仓库...${NC}"
    git init
    echo -e "${GREEN}✓ Git仓库已初始化${NC}"
    echo ""
fi

# 检查远程仓库
echo -e "${YELLOW}检查远程仓库配置...${NC}"
if ! git remote | grep -q "origin"; then
    echo -e "${YELLOW}添加远程仓库...${NC}"
    git remote add origin "$REPO_URL"
    echo -e "${GREEN}✓ 远程仓库已添加${NC}"
else
    # 更新远程仓库URL（如果需要）
    git remote set-url origin "$REPO_URL"
    echo -e "${GREEN}✓ 远程仓库已配置${NC}"
fi
echo "  远程仓库: $REPO_URL"
echo ""

# 检查当前分支
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
if [ -z "$CURRENT_BRANCH" ]; then
    echo -e "${YELLOW}创建main分支...${NC}"
    git checkout -b main
    CURRENT_BRANCH="main"
fi

# 显示Git状态
echo -e "${YELLOW}检查文件状态...${NC}"
git status --short
echo ""

# 检查是否有更改
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}没有需要提交的更改${NC}"
    echo ""
else
    # 添加所有更改
    echo -e "${YELLOW}添加所有更改的文件...${NC}"
    git add .
    echo -e "${GREEN}✓ 文件已添加到暂存区${NC}"
    echo ""
    
    # 生成提交信息
    COMMIT_MSG="更新合规智能体方案"
    
    # 如果有未提交的更改，询问是否自定义提交信息
    if [ -t 0 ]; then  # 检查是否在交互式终端
        echo -e "${YELLOW}请输入提交信息（直接回车使用默认信息）:${NC}"
        echo -e "${YELLOW}默认: $COMMIT_MSG${NC}"
        read -r USER_MSG
        if [ -n "$USER_MSG" ]; then
            COMMIT_MSG="$USER_MSG"
        fi
    fi
    
    # 提交更改
    echo -e "${YELLOW}提交更改...${NC}"
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}✓ 更改已提交${NC}"
    echo ""
fi

# 显示提交历史
echo -e "${YELLOW}最近的提交记录:${NC}"
git log --oneline -5
echo ""

# 推送到远程仓库
echo -e "${YELLOW}推送到远程仓库...${NC}"
echo -e "${YELLOW}分支: $CURRENT_BRANCH${NC}"

# 尝试推送
if git push -u origin "$CURRENT_BRANCH" 2>&1; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✓ 推送成功！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "仓库地址: ${GREEN}$REPO_URL${NC}"
    echo -e "分支: ${GREEN}$CURRENT_BRANCH${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}推送失败，尝试强制推送...${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    read -p "是否要强制推送？(y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push -u origin "$CURRENT_BRANCH" --force
        echo -e "${GREEN}✓ 强制推送成功${NC}"
    else
        echo -e "${YELLOW}已取消推送${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}完成！${NC}"


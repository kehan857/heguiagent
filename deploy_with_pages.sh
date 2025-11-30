#!/bin/bash

# 完整部署脚本 - 包含GitHub Pages自动部署
# 仓库地址: https://github.com/kehan857/heguiagent.git

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
REPO_URL="https://github.com/kehan857/heguiagent.git"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  合规智能体方案 - GitHub Pages 部署${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

cd "$PROJECT_DIR"

# 1. 确保关键文件存在
echo -e "${YELLOW}[1/7] 检查文件...${NC}"
if [ ! -f "compliance_agent_solution.html" ]; then
    echo -e "${RED}❌ compliance_agent_solution.html 不存在${NC}"
    exit 1
fi

# 确保index.html存在（如果不存在，复制compliance_agent_solution.html）
if [ ! -f "index.html" ]; then
    echo -e "${YELLOW}   创建 index.html...${NC}"
    cp compliance_agent_solution.html index.html
fi

# 确保.nojekyll存在
if [ ! -f ".nojekyll" ]; then
    echo -e "${YELLOW}   创建 .nojekyll...${NC}"
    touch .nojekyll
fi

# 确保工作流目录存在
mkdir -p .github/workflows

echo -e "${GREEN}✓ 文件检查完成${NC}"
echo ""

# 2. 初始化Git（如果需要）
echo -e "${YELLOW}[2/7] 检查Git仓库...${NC}"
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✓ Git仓库已初始化${NC}"
else
    echo -e "${GREEN}✓ Git仓库已存在${NC}"
fi
echo ""

# 3. 配置远程仓库
echo -e "${YELLOW}[3/7] 配置远程仓库...${NC}"
if ! git remote | grep -q "origin"; then
    git remote add origin "$REPO_URL"
    echo -e "${GREEN}✓ 远程仓库已添加${NC}"
else
    git remote set-url origin "$REPO_URL"
    echo -e "${GREEN}✓ 远程仓库已更新${NC}"
fi
echo "  远程: $REPO_URL"
echo ""

# 4. 确保在main分支
echo -e "${YELLOW}[4/7] 检查分支...${NC}"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ -z "$CURRENT_BRANCH" ]; then
    git checkout -b main
    CURRENT_BRANCH="main"
elif [ "$CURRENT_BRANCH" != "main" ]; then
    git checkout -b main 2>/dev/null || git checkout main
    CURRENT_BRANCH="main"
fi
echo -e "${GREEN}✓ 当前分支: $CURRENT_BRANCH${NC}"
echo ""

# 5. 添加所有文件
echo -e "${YELLOW}[5/7] 添加文件到Git...${NC}"
git add .
git add compliance_agent_solution.html
git add index.html
git add .nojekyll
git add .github/ 2>/dev/null || true

echo -e "${GREEN}✓ 文件已添加${NC}"
echo ""

# 显示状态
echo -e "${YELLOW}文件状态:${NC}"
git status --short | head -10
echo ""

# 6. 提交更改
echo -e "${YELLOW}[6/7] 提交更改...${NC}"
COMMIT_MSG="更新合规智能体方案并部署到GitHub Pages

- 更新审核案例为企业数字化转型服务
- 增强知识库维护功能
- 优化GitHub Pages部署配置
- 更新时间: $(date '+%Y-%m-%d %H:%M:%S')"

if git commit -m "$COMMIT_MSG" 2>&1; then
    echo -e "${GREEN}✓ 更改已提交${NC}"
else
    echo -e "${YELLOW}⚠ 没有新更改或提交失败${NC}"
fi
echo ""

# 7. 推送到GitHub
echo -e "${YELLOW}[7/7] 推送到GitHub...${NC}"
if git push -u origin main --force 2>&1; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✓ 推送成功！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${BLUE}📦 仓库地址:${NC} https://github.com/kehan857/heguiagent"
    echo -e "${BLUE}🌐 GitHub Pages:${NC} https://kehan857.github.io/heguiagent/"
    echo -e "${BLUE}⚙️  Actions:${NC} https://github.com/kehan857/heguiagent/actions"
    echo ""
    echo -e "${YELLOW}下一步:${NC}"
    echo -e "1. 访问 Actions 页面查看部署状态"
    echo -e "2. 等待 1-2 分钟让 GitHub Pages 自动部署"
    echo -e "3. 访问 GitHub Pages 查看更新后的页面"
    echo ""
    echo -e "${YELLOW}如果页面未更新，请检查:${NC}"
    echo -e "  - GitHub 仓库 Settings → Pages"
    echo -e "  - Source 应设置为 'GitHub Actions'"
    echo -e "  - 检查 Actions 工作流是否成功运行"
    echo ""
else
    echo -e "${RED}❌ 推送失败${NC}"
    echo ""
    echo -e "${YELLOW}可能的原因:${NC}"
    echo -e "  1. 需要身份认证（GitHub Token）"
    echo -e "  2. 网络连接问题"
    echo ""
    echo -e "${YELLOW}解决方法:${NC}"
    echo -e "  手动执行: git push -u origin main --force"
    exit 1
fi

echo -e "${GREEN}完成！${NC}"


# GitHub Pages 部署配置说明

## 快速部署

使用完整部署脚本（推荐）：

```bash
cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
./deploy_with_pages.sh
```

或使用推送脚本：

```bash
./push_to_github.sh
```

## GitHub Pages 配置步骤

推送代码后，需要确保 GitHub Pages 正确配置：

### 1. 检查仓库设置

访问：https://github.com/shangbian/heguiagent/settings/pages

### 2. 配置 Pages 源

- 进入 Settings → Pages
- Source 选择：**GitHub Actions**
- 不要选择 "Deploy from a branch"

### 3. 检查 Actions 工作流

访问：https://github.com/shangbian/heguiagent/actions

确保：
- `Deploy to GitHub Pages` 工作流已运行
- 工作流状态为 ✅ 成功（绿色）
- 如果失败，点击查看错误信息

### 4. 手动触发部署（如果需要）

如果自动部署没有触发：

1. 访问 Actions 页面
2. 选择 "Deploy to GitHub Pages" 工作流
3. 点击 "Run workflow"
4. 选择 main 分支
5. 点击 "Run workflow" 按钮

### 5. 访问 GitHub Pages

部署成功后，访问：
- https://shangbian.github.io/heguiagent/
- https://shangbian.github.io/heguiagent/compliance_agent_solution.html

## 文件说明

- `compliance_agent_solution.html` - 主页面文件
- `index.html` - GitHub Pages 入口文件（自动重定向到主页面）
- `.nojekyll` - 禁用 Jekyll 处理，确保所有文件正常显示
- `.github/workflows/pages.yml` - GitHub Actions 工作流配置

## 常见问题

### 问题1：页面没有更新

**解决方法：**
1. 清除浏览器缓存（Cmd+Shift+R）
2. 检查 Actions 工作流是否成功运行
3. 等待 1-2 分钟让 GitHub Pages 更新

### 问题2：404 错误

**解决方法：**
1. 确保 `index.html` 文件存在
2. 确保 `.nojekyll` 文件存在
3. 检查 GitHub Pages 设置中的 Source 是否为 "GitHub Actions"

### 问题3：工作流没有运行

**解决方法：**
1. 检查 `.github/workflows/` 目录是否在仓库中
2. 确保工作流文件语法正确
3. 手动触发工作流（见步骤4）

### 问题4：样式或功能不正常

**解决方法：**
1. 确保所有资源文件都在仓库中
2. 检查浏览器控制台是否有错误
3. 确保 `.nojekyll` 文件存在（禁用 Jekyll 处理）

## 验证部署

部署成功后，应该能看到：
- ✅ 页面正常显示
- ✅ 所有功能正常工作
- ✅ 审核案例显示为"天九网科企业数字化转型服务"
- ✅ 知识库维护功能正常

## 更新流程

每次更新代码后：

1. 运行部署脚本：`./deploy_with_pages.sh`
2. 等待 GitHub Actions 自动部署（1-2分钟）
3. 访问 GitHub Pages 查看更新

## 联系支持

如果遇到问题，请检查：
- GitHub Actions 日志
- 浏览器控制台错误
- GitHub Pages 设置






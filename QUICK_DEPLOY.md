# GitHub Pages 快速部署指南

## 🚀 一键部署

运行以下命令即可完成部署：

```bash
./deploy_with_pages.sh
```

## 📋 部署前检查清单

- [x] ✅ `index.html` 文件存在
- [x] ✅ `compliance_agent_solution.html` 文件存在
- [x] ✅ `.nojekyll` 文件存在
- [x] ✅ `.github/workflows/pages.yml` 工作流配置存在
- [x] ✅ Git 远程仓库已配置为 `shangbian/heguiagent`

## 🔧 GitHub 仓库设置

部署后，需要在 GitHub 仓库中完成以下设置：

### 1. 启用 GitHub Pages

1. 访问：https://github.com/shangbian/heguiagent/settings/pages
2. 在 **Source** 部分选择：**GitHub Actions**
3. 保存设置

### 2. 检查部署状态

1. 访问：https://github.com/shangbian/heguiagent/actions
2. 查看 "Deploy to GitHub Pages" 工作流
3. 确保状态为 ✅ 成功（绿色）

### 3. 访问页面

部署成功后（通常需要 1-2 分钟），访问：
- **主页**：https://shangbian.github.io/heguiagent/
- **方案页面**：https://shangbian.github.io/heguiagent/compliance_agent_solution.html

## ⚠️ 常见问题

### 问题1：页面显示 404

**解决方法：**
1. 检查 GitHub Pages 设置中的 Source 是否为 "GitHub Actions"
2. 等待 1-2 分钟让 GitHub Pages 更新
3. 清除浏览器缓存（Cmd+Shift+R 或 Ctrl+Shift+R）

### 问题2：工作流没有运行

**解决方法：**
1. 检查 `.github/workflows/pages.yml` 文件是否在仓库中
2. 手动触发工作流：
   - 访问 Actions 页面
   - 选择 "Deploy to GitHub Pages"
   - 点击 "Run workflow"
   - 选择 main 分支
   - 点击 "Run workflow" 按钮

### 问题3：样式或功能不正常

**解决方法：**
1. 确保 `.nojekyll` 文件存在（禁用 Jekyll 处理）
2. 检查浏览器控制台是否有错误
3. 确保所有资源文件都在仓库中

## 📝 更新流程

每次更新代码后：

1. 运行部署脚本：`./deploy_with_pages.sh`
2. 等待 GitHub Actions 自动部署（1-2分钟）
3. 访问 GitHub Pages 查看更新

## 🔗 相关链接

- **仓库地址**：https://github.com/shangbian/heguiagent
- **GitHub Pages**：https://shangbian.github.io/heguiagent/
- **Actions 页面**：https://github.com/shangbian/heguiagent/actions
- **详细配置**：[GITHUB_PAGES_SETUP.md](./GITHUB_PAGES_SETUP.md)

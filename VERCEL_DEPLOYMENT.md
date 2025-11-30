# Vercel 部署指南

## 📋 前置条件

- ✅ GitHub 账号
- ✅ Vercel 账号（可使用 GitHub 账号登录）
- ✅ 代码已提交到 Git 仓库

## 🚀 部署步骤

### 步骤 1: 推送代码到 GitHub

如果还没有推送到远程仓库，执行：

```bash
git push origin main
```

如果远程仓库是其他名称，请替换 `origin` 为对应的远程名称。

### 步骤 2: 登录 Vercel

1. 访问 [https://vercel.com](https://vercel.com)
2. 点击右上角 **"Sign Up"** 或 **"Log In"**
3. 选择 **"Continue with GitHub"**，使用 GitHub 账号登录

### 步骤 3: 导入项目

1. 登录后，点击 **"Add New..."** → **"Project"**
2. 在 **"Import Git Repository"** 中，选择你的 GitHub 仓库
   - 如果看不到仓库，点击 **"Adjust GitHub App Permissions"** 授权访问
3. 选择包含 `report.html` 的仓库

### 步骤 4: 配置项目

Vercel 会自动检测项目配置：

- **Framework Preset**: 选择 **"Other"** 或 **"Static Site"**
- **Root Directory**: 如果 `report.html` 在子目录，设置正确的路径
- **Build Command**: 留空（静态文件无需构建）
- **Output Directory**: 留空或设置为 `.`（当前目录）

### 步骤 5: 环境变量（可选）

本项目不需要环境变量，直接跳过。

### 步骤 6: 部署

1. 点击 **"Deploy"** 按钮
2. 等待部署完成（通常 1-2 分钟）
3. 部署成功后，Vercel 会提供一个预览 URL，格式如：
   ```
   https://your-project-name.vercel.app
   ```

## 📝 项目配置说明

### vercel.json

已配置 `vercel.json`，将根路径 `/` 重定向到 `/report.html`，这样访问网站根目录时会自动显示报告页面。

### 访问地址

部署成功后，你可以通过以下方式访问：

- **生产环境**: `https://your-project-name.vercel.app`
- **预览环境**: 每次推送代码会自动创建新的预览链接

## 🔄 更新部署

每次你推送代码到 GitHub 的 `main` 分支时，Vercel 会自动重新部署。

手动触发部署：
1. 在 Vercel 项目页面
2. 点击 **"Deployments"** 标签
3. 点击右上角 **"Redeploy"**

## 🎯 自定义域名（可选）

1. 在 Vercel 项目设置中
2. 进入 **"Domains"** 标签
3. 添加你的自定义域名
4. 按照提示配置 DNS 记录

## ❓ 常见问题

### Q: 页面显示 404？
A: 检查 `vercel.json` 配置是否正确，确保路径映射正确。

### Q: 样式没有加载？
A: 确保所有 CSS 都在 HTML 文件内部（内联样式），或者检查资源路径。

### Q: 如何查看部署日志？
A: 在 Vercel 项目页面，点击 **"Deployments"** → 选择部署 → 查看 **"Build Logs"**。

## 📞 需要帮助？

如果遇到问题，可以：
1. 查看 Vercel 文档：https://vercel.com/docs
2. 检查部署日志中的错误信息
3. 确认 GitHub 仓库权限设置正确


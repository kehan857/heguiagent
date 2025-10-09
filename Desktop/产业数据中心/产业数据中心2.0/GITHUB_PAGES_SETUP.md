# GitHub Pages 部署设置指南

## 项目已成功推送到GitHub

✅ **仓库地址**: https://github.com/kehan857/chanyeshujuzhongxin4.0.git

## 启用GitHub Pages的步骤

### 1. 访问仓库设置
1. 打开 https://github.com/kehan857/chanyeshujuzhongxin4.0
2. 点击仓库页面顶部的 **Settings** 标签

### 2. 配置Pages设置
1. 在左侧菜单中找到 **Pages** 选项
2. 在 **Source** 部分选择 **GitHub Actions**
3. 保存设置

### 3. 等待自动部署
- GitHub Actions工作流会自动触发
- 构建和部署过程大约需要2-5分钟
- 可以在 **Actions** 标签页查看部署进度

### 4. 访问网站
部署完成后，您的网站将在以下地址可用：
**https://kehan857.github.io/chanyeshujuzhongxin4.0/**

## 自动部署功能

项目已配置了GitHub Actions工作流，具有以下特性：

- ✅ 自动构建Vue.js项目
- ✅ 自动部署到GitHub Pages
- ✅ 每次推送到main分支时自动更新
- ✅ 使用最新的Node.js和npm缓存

## 手动部署（可选）

如果需要手动部署，可以使用以下命令：

```bash
npm run deploy
```

## 故障排除

如果遇到问题：

1. 检查GitHub Actions日志
2. 确保仓库设置中已启用GitHub Actions
3. 确保Pages源设置为"GitHub Actions"
4. 检查构建日志中的错误信息

## 项目信息

- **项目名称**: 天云产业数据中心2.0
- **技术栈**: Vue.js 3 + Vite + Ant Design Vue
- **部署方式**: GitHub Pages + GitHub Actions
- **构建命令**: `npm run build`
- **输出目录**: `dist/`
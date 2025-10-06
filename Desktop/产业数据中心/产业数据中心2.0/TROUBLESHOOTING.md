# GitHub Pages 故障排除指南

## 当前状态检查

### 1. 检查仓库设置
- 仓库地址: https://github.com/kehan857/chanyeshujuzhongxin-2.0
- 仓库状态: 应该是公开的 (Public)

### 2. 检查GitHub Pages设置
访问: https://github.com/kehan857/chanyeshujuzhongxin-2.0/settings/pages

**正确设置应该是:**
- Source: Deploy from a branch
- Branch: gh-pages
- Folder: / (root)

### 3. 检查Actions部署状态
访问: https://github.com/kehan857/chanyeshujuzhongxin-2.0/actions

**应该看到:**
- "Deploy to GitHub Pages" 工作流
- 状态应该是绿色的 ✅ (成功)

## 常见问题解决

### 问题1: 404 Not Found
**可能原因:**
1. GitHub Pages设置错误
2. Actions部署失败
3. 仓库不是公开的

**解决步骤:**
1. 确认仓库是公开的
2. 检查Pages设置是否正确
3. 查看Actions是否有错误

### 问题2: 页面空白
**可能原因:**
1. JavaScript错误
2. 资源路径错误
3. 浏览器缓存

**解决步骤:**
1. 打开浏览器开发者工具 (F12)
2. 查看Console是否有错误
3. 清除浏览器缓存
4. 尝试无痕模式

### 问题3: 路由不工作
**可能原因:**
1. SPA路由配置问题
2. 404.html重定向失败

**解决步骤:**
1. 直接访问根路径: https://kehan857.github.io/chanyeshujuzhongxin-2.0/
2. 如果根路径可以访问，说明路由重定向有问题

## 手动部署测试

如果自动部署有问题，可以尝试手动部署：

### 1. 本地构建
```bash
npm run build
```

### 2. 检查构建结果
```bash
ls -la dist/
```
应该看到:
- index.html
- 404.html
- assets/ 目录

### 3. 本地预览
```bash
npm run preview
```
访问: http://localhost:4173/chanyeshujuzhongxin-2.0/

## 联系支持

如果以上步骤都无法解决问题，请提供以下信息：

1. 仓库设置截图
2. Actions页面截图
3. 浏览器控制台错误信息
4. 具体的错误页面截图

## 备用方案

如果GitHub Pages持续有问题，可以考虑其他部署平台：

### Vercel
1. 连接GitHub仓库
2. 自动部署
3. 访问: https://vercel.com

### Netlify
1. 拖拽dist文件夹
2. 或连接GitHub仓库
3. 访问: https://netlify.com

### 阿里云/腾讯云
1. 上传dist文件夹到静态网站托管
2. 配置自定义域名


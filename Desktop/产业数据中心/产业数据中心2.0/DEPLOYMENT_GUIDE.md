# GitHub Pages 部署完整指南

## 🎯 项目信息
- **项目名称**: 天云产业数据中心
- **GitHub仓库**: https://github.com/kehan857/chanyeshujuzhongxin4.0.git
- **部署地址**: https://kehan857.github.io/chanyeshujuzhongxin4.0/
- **技术栈**: Vue.js 3 + Vite + Ant Design Vue

## 📋 部署前检查清单

### 1. 项目配置检查
- [ ] `vite.config.js` 中 `base` 路径正确设置
- [ ] `package.json` 中部署脚本正确
- [ ] 项目依赖完整安装

### 2. 关键配置文件

#### `vite.config.js` 配置
```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  // 关键：生产环境base路径必须与仓库名一致
  base: process.env.NODE_ENV === 'production' ? '/chanyeshujuzhongxin4.0/' : '/',
  server: {
    port: 3000,
    open: true,
  },
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: `@use "@/styles/variables.scss" as *;`,
        api: 'modern-compiler'
      }
    }
  }
})
```

#### `package.json` 部署脚本
```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "deploy": "npm run build && gh-pages -d dist",
    "deploy:force": "npm run build && gh-pages -d dist --remove"
  },
  "devDependencies": {
    "gh-pages": "^6.3.0"
  }
}
```

## 🚀 标准部署流程

### 方法一：使用 gh-pages 工具（推荐）

```bash
# 1. 确保在main分支
git checkout main

# 2. 安装依赖（如果需要）
npm install

# 3. 构建项目
npm run build

# 4. 部署到GitHub Pages
npm run deploy
```

### 方法二：使用GitHub Actions（自动化）

创建 `.github/workflows/deploy.yml`:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Build
      run: npm run build
      
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      if: github.ref == 'refs/heads/main'
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./dist
        force_orphan: true
        user_name: 'github-actions[bot]'
        user_email: 'github-actions[bot]@users.noreply.github.com'
```

## 🔧 常见问题及解决方案

### 问题1: 资源路径404错误
**症状**: 浏览器控制台显示资源加载失败
**原因**: `vite.config.js` 中 `base` 路径配置错误
**解决**: 确保 `base` 路径与GitHub仓库名完全一致

### 问题2: SPA路由404错误
**症状**: 直接访问子路由返回404
**解决**: 创建 `public/404.html` 文件，内容与 `index.html` 相同

### 问题3: GitHub Pages CDN缓存问题
**症状**: 即使推送了正确内容，网站仍显示旧内容
**解决方案**:
```bash
# 1. 完全删除gh-pages分支
git push origin --delete gh-pages

# 2. 重新部署
npm run deploy

# 3. 如果仍有问题，强制推送
git checkout gh-pages
git push origin gh-pages --force
```

### 问题4: 代理服务器干扰
**症状**: DevTools显示 `Remote Address: 127.0.0.1:7890`
**解决**: 
- 关闭本地代理软件
- 清除代理缓存
- 使用无痕模式或不同网络环境测试

## 📝 部署后验证

### 1. 检查部署状态
- 访问: https://github.com/kehan857/chanyeshujuzhongxin4.0/actions
- 确保部署工作流成功运行

### 2. 验证网站内容
```bash
# 使用curl检查返回内容
curl -s https://kehan857.github.io/chanyeshujuzhongxin4.0/ | head -15
```

### 3. 检查关键元素
- [ ] 页面标题正确
- [ ] 资源路径正确
- [ ] 样式和脚本加载正常
- [ ] 路由功能正常

## 🎯 最佳实践

### 1. 部署前准备
- 确保本地开发环境正常
- 运行 `npm run preview` 测试构建结果
- 检查所有依赖是否最新

### 2. 部署流程
- 始终从 `main` 分支部署
- 使用 `npm run deploy` 而不是手动操作
- 部署后等待2-5分钟再检查结果

### 3. 问题排查
- 优先检查 `vite.config.js` 配置
- 查看GitHub Actions日志
- 使用不同浏览器和网络环境测试

### 4. 缓存处理
- 遇到缓存问题时，等待10-30分钟
- 使用无痕模式测试
- 必要时强制刷新gh-pages分支

## 🔄 快速部署命令

```bash
# 一键部署（推荐）
npm run deploy

# 强制重新部署（解决缓存问题）
npm run deploy:force

# 手动部署流程
git checkout main
npm install
npm run build
npx gh-pages -d dist
```

## 📞 紧急情况处理

如果遇到严重问题，按以下顺序尝试：

1. **重新配置GitHub Pages**
   - 访问仓库设置页面
   - 重新选择gh-pages分支
   - 保存设置

2. **完全重建gh-pages分支**
   ```bash
   git push origin --delete gh-pages
   npm run deploy
   ```

3. **使用替代部署方案**
   - Vercel: https://vercel.com
   - Netlify: https://netlify.com
   - 创建新的GitHub仓库

## ✅ 成功部署标志

- GitHub Actions显示绿色✅
- 网站URL可以正常访问
- 页面标题和内容正确显示
- 所有资源（CSS、JS、图片）正常加载
- 路由功能正常工作

---

**记住**: 大多数部署问题都是由于配置错误或缓存问题导致的。按照本指南操作，99%的情况下都能一次部署成功！🎉

# 天云产业数据中心 2.0

## 项目简介

天云产业数据中心是一个基于Vue 3 + Ant Design Vue构建的现代化产业数据管理平台，旨在为天云产业提供全面的数据服务和智能分析能力。

## 技术栈

- **前端框架**: Vue 3 (Composition API)
- **UI组件库**: Ant Design Vue 4.0
- **构建工具**: Vite
- **状态管理**: Pinia
- **路由管理**: Vue Router 4
- **样式预处理**: Sass
- **开发语言**: JavaScript

## 功能特性

### 核心功能
- 🏠 **门户首页**: 产品愿景展示和核心功能介绍
- 🏢 **企业库**: 360度全景企业画像
- 🚀 **方案库**: 行业解决方案知识库
- 📚 **知识库**: 行业标准和知识管理
- 👥 **人才库**: 人才信息管理
- 📦 **产品库**: 产品信息管理
- 🔗 **产业链库**: 产业链关系管理
- 🛒 **需求库**: 需求信息管理
- 📋 **政策库**: 政策信息管理
- ❓ **行业问题库**: 行业问题管理

### 企业库特色功能
- **基本信息**: 工商信息、股东信息、主要人员
- **产品方案**: 核心产品、解决方案展示
- **荣誉标签**: 企业资质和荣誉展示
- **产业链位置**: 上下游企业关系可视化
- **行业标准**: 适配的行业标准展示
- **行业方案**: 可适配的解决方案
- **问题关联**: 行业问题关联分析
- **政策适配**: 可申报政策推荐
- **招投标信息**: 历史招投标记录
- **人才信息**: 关键人员信息展示

## 项目结构

```
src/
├── components/          # 公共组件
│   └── Header.vue      # 顶部导航组件
├── views/              # 页面组件
│   ├── Home.vue        # 首页
│   └── libraries/      # 九大库页面
│       ├── EnterpriseLibrary.vue    # 企业库
│       ├── EnterpriseDetail.vue     # 企业详情
│       ├── SolutionLibrary.vue      # 方案库
│       ├── KnowledgeLibrary.vue     # 知识库
│       ├── TalentLibrary.vue        # 人才库
│       ├── ProductLibrary.vue       # 产品库
│       ├── IndustryChainLibrary.vue # 产业链库
│       ├── DemandLibrary.vue        # 需求库
│       ├── PolicyLibrary.vue        # 政策库
│       └── IndustryProblemLibrary.vue # 行业问题库
├── router/             # 路由配置
├── styles/             # 样式文件
└── main.js            # 应用入口
```

## 快速开始

### 环境要求
- Node.js >= 16.0.0
- npm >= 8.0.0

### 安装依赖
```bash
npm install
```

### 开发环境运行
```bash
npm run dev
```

访问 http://localhost:5000

### 生产环境构建
```bash
npm run build
```

### 预览构建结果
```bash
npm run preview
```

## 在线预览

🌐 **GitHub Pages**: https://kehan857.github.io/chanyeshujuzhongxin-2.0/

> 如果页面显示空白，请清除浏览器缓存或等待几分钟让CDN更新。

## GitHub Pages 部署设置

### 启用 GitHub Pages

1. 进入仓库设置页面：https://github.com/kehan857/chanyeshujuzhongxin-2.0/settings/pages

2. 在 "Source" 部分选择：
   - **Source**: Deploy from a branch
   - **Branch**: gh-pages
   - **Folder**: / (root)

3. 点击 "Save" 保存设置

### 自动部署

项目已配置 GitHub Actions 工作流，每次推送到 `main` 分支时会自动：
- 构建项目
- 部署到 `gh-pages` 分支
- 更新 GitHub Pages 站点

### 手动触发部署

如果需要手动触发部署，可以：
1. 进入 Actions 页面：https://github.com/kehan857/chanyeshujuzhongxin-2.0/actions
2. 选择 "Deploy to GitHub Pages" 工作流
3. 点击 "Run workflow" 按钮

## 开发指南

### 添加新的库页面
1. 在 `src/views/libraries/` 目录下创建新的Vue组件
2. 在 `src/router/index.js` 中添加路由配置
3. 在 `src/components/Header.vue` 中添加导航菜单项

### 样式规范
- 使用Sass预处理器
- 遵循Ant Design设计规范
- 响应式设计，支持移动端
- 使用CSS变量统一管理主题色彩

### 组件开发
- 使用Vue 3 Composition API
- 遵循组件化开发原则
- 合理使用Ant Design Vue组件
- 保持代码简洁和可维护性

## 部署说明

### GitHub Pages部署
项目已配置GitHub Actions自动部署到GitHub Pages。

1. 推送代码到main分支
2. GitHub Actions会自动构建并部署
3. 访问 https://kehan857.github.io/chanyeshujuzhongxin-2.0/

### 其他部署方式
- **Vercel**: 连接GitHub仓库自动部署
- **Netlify**: 拖拽dist文件夹或连接GitHub仓库
- **阿里云/腾讯云**: 上传dist文件夹到静态网站托管

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 联系方式

如有问题或建议，请通过以下方式联系：
- 提交 Issue
- 发送邮件至项目维护者

---

**天云产业数据中心 2.0** - 让产业数据更智能，让决策更精准！# Trigger deployment Fri Oct 10 14:29:53 CST 2025

# 天云产业数据中心 - 部署指南

## 📋 部署经验总结

基于多次部署实践，总结出以下关键成功要素和最佳实践。

## 🔑 关键成功要素

### 1. 正确的配置
- **vite.config.js** 中的 `base` 路径必须与仓库名完全一致
  - 生产环境：`/chanyeshujuzhongxin4.0/`
  - 开发环境：`/`
- **public/404.html** 文件必须存在，用于SPA路由重定向
- **GitHub Actions** 工作流配置正确

### 2. 标准部署流程
```bash
# 标准部署
npm run build && npm run deploy

# 强制重新部署（清除缓存）
npm run deploy:force
```

### 3. 缓存问题处理
- GitHub Pages CDN缓存非常顽固
- 必要时需要强制重建gh-pages分支
- 等待时间：2-30分钟

## 🚨 常见陷阱及解决方案

### 问题1: 资源路径错误
**症状**: 请求URL包含错误的路径（如 `guohua_knowledge`）
**解决方案**:
1. 检查 `vite.config.js` 中的 `base` 配置
2. 确保与仓库名完全一致
3. 重新构建和部署

### 问题2: SPA路由404
**症状**: 直接访问子路由返回404
**解决方案**:
1. 确保 `public/404.html` 文件存在
2. 检查404.html中的重定向逻辑
3. 验证路径配置正确

### 问题3: CDN缓存问题
**症状**: 部署后页面没有更新
**解决方案**:
1. 使用 `npm run deploy:force` 强制重新部署
2. 等待更长时间（最多30分钟）
3. 使用无痕模式测试

### 问题4: 代理服务器干扰
**症状**: Remote Address 显示 `127.0.0.1:7890`
**解决方案**:
1. 关闭本地代理设置
2. 关闭浏览器代理扩展
3. 关闭VPN或科学上网工具
4. 使用无痕模式测试

## 🎯 下次部署的最佳实践

### 部署前检查清单
- [ ] 确保 `vite.config.js` 配置正确
- [ ] 验证 `public/404.html` 文件存在
- [ ] 本地预览测试通过
- [ ] 检查依赖完整性
- [ ] 关闭本地代理

### 标准部署流程
```bash
# 1. 切换到主分支
git checkout main

# 2. 拉取最新代码
git pull origin main

# 3. 标准部署
npm run deploy

# 4. 验证部署结果
curl -s https://kehan857.github.io/chanyeshujuzhongxin4.0/ | head -15
```

### 问题排查顺序
1. **检查GitHub Actions状态**
   - 访问: https://github.com/kehan857/chanyeshujuzhongxin4.0/actions
   - 确保部署状态为绿色 ✅

2. **验证gh-pages分支内容**
   - 检查构建文件是否正确
   - 验证资源路径

3. **测试不同网络环境**
   - 无痕模式
   - 不同浏览器
   - 手机热点网络

## 📋 快速参考

### 一键部署命令
```bash
# 标准部署
npm run deploy

# 强制重新部署
npm run deploy:force

# 本地预览
npm run preview
```

### 验证部署结果
```bash
# 检查主页
curl -s https://kehan857.github.io/chanyeshujuzhongxin4.0/ | head -15

# 检查AI搜索页面
curl -s https://kehan857.github.io/chanyeshujuzhongxin4.0/ai-search | head -15
```

### 正确的访问地址
- **主页**: https://kehan857.github.io/chanyeshujuzhongxin4.0/
- **AI搜索**: https://kehan857.github.io/chanyeshujuzhongxin4.0/ai-search
- **企业库**: https://kehan857.github.io/chanyeshujuzhongxin4.0/enterprise
- **方案库**: https://kehan857.github.io/chanyeshujuzhongxin4.0/solution
- **知识库**: https://kehan857.github.io/chanyeshujuzhongxin4.0/knowledge

## 🔧 故障排除

### 如果部署失败
1. 检查GitHub Actions日志
2. 验证仓库权限设置
3. 确保仓库是公开的
4. 检查GitHub Pages设置

### 如果页面无法访问
1. 等待2-30分钟（CDN缓存）
2. 清除浏览器缓存
3. 使用无痕模式
4. 检查网络连接

### 如果资源加载失败
1. 检查资源路径是否正确
2. 验证构建输出
3. 强制重新部署
4. 检查代理设置

## 📞 联系支持

如果按照本指南操作后仍有问题，请提供：
1. GitHub Actions日志截图
2. 浏览器控制台错误信息
3. 网络请求详情
4. 具体的错误页面截图

---

**最后更新**: 2025年1月
**版本**: 1.0
**适用仓库**: https://github.com/kehan857/chanyeshujuzhongxin4.0
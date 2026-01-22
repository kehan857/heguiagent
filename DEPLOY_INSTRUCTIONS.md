# 部署到 GitHub Pages - 手动步骤

## 方法1：使用简单脚本（推荐）

```bash
cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
./simple_deploy.sh
```

## 方法2：手动执行命令

在终端中依次执行以下命令：

```bash
# 1. 进入项目目录
cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"

# 2. 添加所有文件
git add .

# 3. 提交更改
git commit -m "更新合规智能体方案并配置GitHub Pages自动部署"

# 4. 推送到GitHub
git push origin main
```

## 方法3：如果遇到权限问题

```bash
# 先给脚本添加执行权限
chmod +x simple_deploy.sh
chmod +x deploy_with_pages.sh
chmod +x push_to_github.sh

# 然后运行
./simple_deploy.sh
```

## 推送后的步骤

### 1. 检查 GitHub Actions

访问：https://github.com/kehan857/heguiagent/actions

确保 `Deploy to GitHub Pages` 工作流：
- ✅ 已自动运行
- ✅ 状态为成功（绿色）

### 2. 配置 GitHub Pages（重要！）

访问：https://github.com/kehan857/heguiagent/settings/pages

**必须设置：**
- Source: 选择 **"GitHub Actions"**（不是 "Deploy from a branch"）
- 保存设置

### 3. 等待部署完成

- 等待 1-2 分钟
- 访问：https://kehan857.github.io/heguiagent/

### 4. 验证更新

应该能看到：
- ✅ 审核案例已更新为"天九网科企业数字化转型服务"
- ✅ 所有功能正常工作
- ✅ 页面样式正常

## 如果页面没有更新

1. **清除浏览器缓存**
   - Mac: `Cmd + Shift + R`
   - 或：开发者工具（F12）→ 右键刷新 → "清空缓存并硬性重新加载"

2. **检查 GitHub Pages 设置**
   - 确保 Source 设置为 "GitHub Actions"
   - 不是 "Deploy from a branch"

3. **检查 Actions 工作流**
   - 确保工作流成功运行
   - 如果有错误，查看错误日志

4. **手动触发部署**
   - 访问 Actions 页面
   - 选择 "Deploy to GitHub Pages"
   - 点击 "Run workflow"

## 快速验证命令

```bash
# 检查Git状态
git status

# 查看最近的提交
git log --oneline -3

# 检查远程仓库
git remote -v
```





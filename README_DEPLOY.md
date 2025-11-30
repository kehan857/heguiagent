# 部署指南 - 合规智能体方案到 GitHub

## 问题：没有推送内容

如果执行了推送命令但没有内容被推送，请按照以下步骤操作：

## 完整推送步骤

### 1. 打开终端

在 macOS 上打开 Terminal（终端）

### 2. 进入项目目录

```bash
cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
```

### 3. 检查文件是否存在

```bash
ls -la compliance_agent_solution.html
ls -la .github/workflows/
```

### 4. 初始化 Git（如果还没有）

```bash
git init
```

### 5. 配置远程仓库

```bash
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/kehan857/heguiagent.git
```

### 6. 创建 index.html（GitHub Pages 需要）

```bash
cp compliance_agent_solution.html index.html
```

### 7. 添加所有文件

```bash
git add .
```

### 8. 查看状态（确认文件已添加）

```bash
git status
```

应该看到：
- compliance_agent_solution.html
- index.html
- .github/workflows/deploy.yml
- .github/workflows/static.yml

### 9. 提交更改

```bash
git commit -m "添加合规智能体方案和GitHub Actions工作流"
```

### 10. 设置主分支

```bash
git branch -M main
```

### 11. 推送到 GitHub

```bash
git push -u origin main --force
```

## 如果推送需要认证

如果提示需要用户名和密码：

1. **使用 Personal Access Token**（推荐）：
   - 访问：https://github.com/settings/tokens
   - 生成新 token（选择 `repo` 权限）
   - 推送时，用户名输入你的 GitHub 用户名，密码输入 token

2. **或配置 SSH 密钥**：
   ```bash
   # 生成 SSH 密钥（如果还没有）
   ssh-keygen -t ed25519 -C "your_email@example.com"
   
   # 添加到 GitHub
   # 然后修改远程 URL
   git remote set-url origin git@github.com:kehan857/heguiagent.git
   git push -u origin main --force
   ```

## 验证推送是否成功

推送后，访问以下链接检查：

1. **仓库文件**：
   - https://github.com/kehan857/heguiagent
   - 应该能看到所有文件

2. **工作流文件**：
   - https://github.com/kehan857/heguiagent/tree/main/.github/workflows
   - 应该能看到 deploy.yml 和 static.yml

3. **Actions**：
   - https://github.com/kehan857/heguiagent/actions
   - 应该能看到工作流运行

## 快速执行脚本

我已经创建了以下脚本，可以直接执行：

```bash
# 方法1：使用 bash 脚本
bash full_deploy.sh

# 方法2：使用 Python 脚本
python3 deploy_with_output.py
```

## 常见问题

### Q: 推送后看不到文件？
A: 检查：
1. 是否真的执行了 `git add .`
2. 是否执行了 `git commit`
3. 推送时是否有错误信息

### Q: 需要身份认证？
A: 使用 GitHub Personal Access Token 或配置 SSH 密钥

### Q: Actions 没有运行？
A: 检查：
1. `.github/workflows/` 目录是否在仓库中
2. GitHub Settings → Actions → General 是否启用
3. 手动触发：Actions → Run workflow


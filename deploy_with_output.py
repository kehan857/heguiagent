#!/usr/bin/env python3
import subprocess
import os
import sys

def run_cmd(cmd, cwd=None):
    """执行命令并打印输出"""
    print(f"\n执行: {cmd}")
    print("-" * 50)
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=cwd or "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案",
            capture_output=True,
            text=True,
            check=False
        )
        if result.stdout:
            print(result.stdout)
        if result.stderr:
            print("STDERR:", result.stderr, file=sys.stderr)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        print(f"错误: {e}", file=sys.stderr)
        return False, "", str(e)

def main():
    work_dir = "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
    
    print("=" * 60)
    print("  完整部署到 GitHub")
    print("=" * 60)
    
    # 检查文件
    print("\n1. 检查文件...")
    if not os.path.exists(f"{work_dir}/compliance_agent_solution.html"):
        print("❌ compliance_agent_solution.html 不存在")
        return False
    print("✓ compliance_agent_solution.html 存在")
    
    # 初始化 Git
    print("\n2. 初始化 Git...")
    if not os.path.exists(f"{work_dir}/.git"):
        success, _, _ = run_cmd("git init", cwd=work_dir)
        if success:
            print("✓ Git 仓库已初始化")
    else:
        print("✓ Git 仓库已存在")
    
    # 配置远程
    print("\n3. 配置远程仓库...")
    run_cmd("git remote remove origin", cwd=work_dir)
    success, _, _ = run_cmd("git remote add origin https://github.com/kehan857/heguiagent.git", cwd=work_dir)
    if not success:
        run_cmd("git remote set-url origin https://github.com/kehan857/heguiagent.git", cwd=work_dir)
    print("✓ 远程仓库已配置")
    
    # 创建 index.html
    print("\n4. 创建 index.html...")
    if not os.path.exists(f"{work_dir}/index.html"):
        import shutil
        shutil.copy(f"{work_dir}/compliance_agent_solution.html", f"{work_dir}/index.html")
        print("✓ index.html 已创建")
    
    # 添加文件
    print("\n5. 添加文件...")
    success, output, _ = run_cmd("git add .", cwd=work_dir)
    if success:
        print("✓ 文件已添加")
    
    # 查看状态
    print("\n6. Git 状态:")
    run_cmd("git status --short", cwd=work_dir)
    
    # 提交
    print("\n7. 提交更改...")
    success, output, error = run_cmd(
        'git commit -m "添加合规智能体方案和GitHub Actions工作流"',
        cwd=work_dir
    )
    if "nothing to commit" in output.lower() or "没有更改" in output:
        print("⚠ 没有新更改或已提交")
    elif success:
        print("✓ 已提交")
    else:
        print(f"⚠ 提交可能失败: {error}")
    
    # 设置分支
    print("\n8. 设置主分支...")
    run_cmd("git branch -M main", cwd=work_dir)
    
    # 推送
    print("\n9. 推送到 GitHub...")
    print("   这可能需要身份认证...")
    success, output, error = run_cmd("git push -u origin main --force", cwd=work_dir)
    
    if success:
        print("\n" + "=" * 60)
        print("  ✅ 推送成功！")
        print("=" * 60)
        print("\n📦 仓库: https://github.com/kehan857/heguiagent")
        print("⚙️  Actions: https://github.com/kehan857/heguiagent/actions")
        print("🌐 Pages: https://kehan857.github.io/heguiagent/")
        return True
    else:
        print("\n" + "=" * 60)
        print("  ❌ 推送失败")
        print("=" * 60)
        print(f"\n错误信息: {error}")
        print("\n可能需要:")
        print("  1. GitHub 身份认证")
        print("  2. 配置 Personal Access Token")
        print("  3. 手动执行: git push -u origin main --force")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)






#!/usr/bin/env python3
import subprocess
import os
import sys

def run_cmd(cmd, check=True):
    """执行命令并返回结果"""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            capture_output=True, 
            text=True,
            cwd="/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
        )
        if result.stdout:
            print(result.stdout)
        if result.stderr and result.returncode != 0:
            print(result.stderr, file=sys.stderr)
        return result.returncode == 0
    except Exception as e:
        print(f"错误: {e}", file=sys.stderr)
        return False

def main():
    print("开始部署到 GitHub...")
    
    # 检查文件是否存在
    file_path = "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案/compliance_agent_solution.html"
    if not os.path.exists(file_path):
        print(f"错误: 文件不存在: {file_path}")
        return False
    
    print("✓ 文件存在")
    
    # 初始化 Git
    print("\n1. 初始化 Git 仓库...")
    run_cmd("git init", check=False)
    
    # 添加远程仓库
    print("2. 配置远程仓库...")
    run_cmd("git remote remove origin", check=False)
    run_cmd("git remote add origin https://github.com/kehan857/heguiagent.git", check=False)
    
    # 添加文件
    print("3. 添加文件...")
    if not run_cmd("git add compliance_agent_solution.html"):
        print("错误: 添加文件失败")
        return False
    
    # 提交
    print("4. 提交更改...")
    if not run_cmd('git commit -m "更新合规智能体方案：添加知识库维护、人工审核、一键修改等功能"', check=False):
        print("提示: 可能没有新更改或已提交")
    
    # 设置分支
    print("5. 设置主分支...")
    run_cmd("git branch -M main", check=False)
    
    # 推送
    print("6. 推送到 GitHub...")
    if run_cmd("git push -u origin main --force"):
        print("\n✓ 推送成功！")
        print("访问: https://github.com/kehan857/heguiagent")
        return True
    else:
        print("\n⚠ 推送可能需要身份认证")
        print("请手动执行: git push -u origin main --force")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)


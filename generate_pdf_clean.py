#!/usr/bin/env python3
"""
使用Chrome DevTools Protocol生成无页眉页脚的PDF
"""
import subprocess
import json
import os
import time

chrome_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
html_file = os.path.abspath("report.html")
pdf_file = os.path.abspath("report.pdf")

# Chrome打印选项 - 完全禁用页眉页脚
print_options = {
    "displayHeaderFooter": False,
    "printBackground": True,
    "marginTop": 0,
    "marginBottom": 0,
    "marginLeft": 0,
    "marginRight": 0,
    "paperWidth": 8.27,  # A4 width in inches
    "paperHeight": 11.69  # A4 height in inches
}

# 使用Chrome的--print-to-pdf参数
# 注意：Chrome命令行可能不支持JSON配置，所以我们使用CSS @page规则
# 但我们可以尝试使用--print-to-pdf-no-header参数

cmd = [
    chrome_path,
    "--headless",
    "--disable-gpu",
    "--run-all-compositor-stages-before-draw",
    "--virtual-time-budget=3000",
    "--print-to-pdf=" + pdf_file,
    "--print-to-pdf-no-header",
    "--disable-pdf-tagging",
    html_file
]

print("正在生成PDF（无页眉页脚）...")
result = subprocess.run(cmd, capture_output=True)

if os.path.exists(pdf_file):
    size = os.path.getsize(pdf_file)
    print(f"✓ PDF生成成功: {pdf_file}")
    print(f"  文件大小: {size/1024:.1f} KB")
else:
    print("✗ PDF生成失败")
    print(result.stderr.decode() if result.stderr else "")


#!/usr/bin/env python3
import subprocess
import json
import time
import os

# Chrome路径
chrome_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
html_file = os.path.abspath("report.html")
pdf_file = os.path.abspath("report.pdf")

# 使用Chrome headless模式生成PDF，禁用页眉页脚
cmd = [
    chrome_path,
    "--headless",
    "--disable-gpu",
    "--virtual-time-budget=3000",
    "--print-to-pdf=" + pdf_file,
    "--print-to-pdf-no-header",
    html_file
]

print("正在生成PDF（无页眉页脚）...")
result = subprocess.run(cmd, capture_output=True, text=True)

if os.path.exists(pdf_file):
    size = os.path.getsize(pdf_file)
    print(f"PDF生成成功: {pdf_file} ({size/1024:.1f} KB)")
else:
    print("PDF生成失败")


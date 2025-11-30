#!/usr/bin/env python3
"""
使用Chrome DevTools Protocol生成无页眉页脚的PDF
"""
import subprocess
import json
import os
import time
import urllib.request
import urllib.parse

chrome_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
html_file = os.path.abspath("report.html")
pdf_file = os.path.abspath("report.pdf")

# 启动Chrome with remote debugging
port = 9222
chrome_process = subprocess.Popen([
    chrome_path,
    "--headless",
    "--disable-gpu",
    "--remote-debugging-port=" + str(port),
    "--no-sandbox"
], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

time.sleep(2)  # 等待Chrome启动

try:
    # 获取Chrome DevTools Protocol端点
    import urllib.request
    response = urllib.request.urlopen(f"http://localhost:{port}/json/version")
    version_info = json.loads(response.read().decode())
    
    # 创建新的标签页并导航到HTML文件
    create_response = urllib.request.urlopen(
        f"http://localhost:{port}/json/new?file://{urllib.parse.quote(html_file)}"
    )
    tab_info = json.loads(create_response.read().decode())
    tab_id = tab_info['id']
    
    time.sleep(2)  # 等待页面加载
    
    # 使用Page.printToPDF命令
    print_options = {
        "displayHeaderFooter": False,
        "printBackground": True,
        "marginTop": 0,
        "marginBottom": 0,
        "marginLeft": 0,
        "marginRight": 0,
        "paperWidth": 8.27,
        "paperHeight": 11.69
    }
    
    cdp_command = {
        "id": 1,
        "method": "Page.printToPDF",
        "params": print_options
    }
    
    # 发送CDP命令
    import socket
    ws_url = tab_info.get('webSocketDebuggerUrl', f"ws://localhost:{port}/devtools/page/{tab_id}")
    
    # 由于WebSocket比较复杂，我们使用更简单的方法
    # 直接使用Chrome的命令行参数，但确保CSS正确
    
finally:
    chrome_process.terminate()
    chrome_process.wait()

# 实际上，最简单的方法是确保HTML中的@page规则正确
# 并使用--print-to-pdf-no-header参数
cmd = [
    chrome_path,
    "--headless",
    "--disable-gpu",
    "--run-all-compositor-stages-before-draw",
    "--virtual-time-budget=3000",
    "--print-to-pdf=" + pdf_file,
    "--print-to-pdf-no-header",
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


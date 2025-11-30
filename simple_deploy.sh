#!/bin/bash
cd "/Users/kexiaobin/Desktop/其他/天九/天九需求包/合规智能体/合规智能体方案"
git add .
git commit -m "更新合规智能体方案并配置GitHub Pages自动部署" || echo "没有新更改"
git push origin main


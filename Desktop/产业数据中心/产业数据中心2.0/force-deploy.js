#!/usr/bin/env node

// 强制GitHub Pages重新部署的脚本
const https = require('https');

const options = {
  hostname: 'api.github.com',
  port: 443,
  path: '/repos/kehan857/chanyeshujuzhongxin3.0/pages/builds',
  method: 'POST',
  headers: {
    'User-Agent': 'GitHub-Pages-Force-Deploy',
    'Accept': 'application/vnd.github.v3+json',
    'Content-Type': 'application/json'
  }
};

const postData = JSON.stringify({
  source: {
    branch: 'main',
    path: '/'
  }
});

const req = https.request(options, (res) => {
  console.log(`状态码: ${res.statusCode}`);
  console.log(`响应头: ${JSON.stringify(res.headers)}`);
  
  res.on('data', (d) => {
    console.log('响应数据:', d.toString());
  });
});

req.on('error', (e) => {
  console.error('请求错误:', e);
});

req.write(postData);
req.end();


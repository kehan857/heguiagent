#!/usr/bin/env node

// 强制部署脚本 - 清除所有缓存并重新部署
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🚀 开始强制部署流程...');

try {
  // 1. 清理本地缓存
  console.log('📦 清理本地缓存...');
  if (fs.existsSync('node_modules')) {
    execSync('rm -rf node_modules', { stdio: 'inherit' });
  }
  if (fs.existsSync('package-lock.json')) {
    execSync('rm -f package-lock.json', { stdio: 'inherit' });
  }
  
  // 2. 重新安装依赖
  console.log('📥 重新安装依赖...');
  execSync('npm install', { stdio: 'inherit' });
  
  // 3. 清理构建目录
  console.log('🧹 清理构建目录...');
  if (fs.existsSync('dist')) {
    execSync('rm -rf dist', { stdio: 'inherit' });
  }
  
  // 4. 构建项目
  console.log('🔨 构建项目...');
  execSync('npm run build', { stdio: 'inherit' });
  
  // 5. 验证构建结果
  console.log('✅ 验证构建结果...');
  const distFiles = fs.readdirSync('dist');
  console.log('构建文件:', distFiles);
  
  // 检查index.html中的路径
  const indexHtml = fs.readFileSync('dist/index.html', 'utf8');
  if (indexHtml.includes('chanyeshujuzhongxin4.0')) {
    console.log('✅ index.html路径正确');
  } else {
    console.log('❌ index.html路径可能有问题');
    console.log('index.html内容预览:');
    console.log(indexHtml.substring(0, 500));
  }
  
  // 6. 创建缓存清除文件
  console.log('🗑️ 创建缓存清除文件...');
  const timestamp = new Date().toISOString();
  fs.writeFileSync('dist/cache-buster.txt', `Cache cleared at: ${timestamp}`);
  fs.writeFileSync('dist/force-deploy.txt', `Force deploy at: ${timestamp}`);
  
  console.log('🎉 强制部署准备完成！');
  console.log('📝 下一步: git add . && git commit -m "强制重新部署" && git push origin-new4 main');
  
} catch (error) {
  console.error('❌ 部署过程中出现错误:', error.message);
  process.exit(1);
}
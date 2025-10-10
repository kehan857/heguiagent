#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🚨 紧急部署脚本启动...');

try {
  // 1. 确保在main分支
  console.log('📋 检查当前分支...');
  execSync('git checkout main', { stdio: 'inherit' });
  
  // 2. 拉取最新代码
  console.log('📥 拉取最新代码...');
  execSync('git pull origin-new4 main', { stdio: 'inherit' });
  
  // 3. 清理并重新构建
  console.log('🧹 清理构建目录...');
  if (fs.existsSync('dist')) {
    execSync('rm -rf dist', { stdio: 'inherit' });
  }
  
  // 4. 使用正确的环境变量构建
  console.log('🔨 重新构建项目...');
  execSync('NODE_ENV=production npm run build', { stdio: 'inherit' });
  
  // 5. 验证构建结果
  console.log('✅ 验证构建结果...');
  const indexPath = path.join('dist', 'index.html');
  if (fs.existsSync(indexPath)) {
    const content = fs.readFileSync(indexPath, 'utf8');
    if (content.includes('/chanyeshujuzhongxin4.0/assets/')) {
      console.log('✅ 构建结果正确，包含正确的base路径');
    } else {
      console.log('❌ 构建结果错误，base路径不正确');
      console.log('构建内容预览:', content.substring(0, 500));
      process.exit(1);
    }
  } else {
    console.log('❌ 构建失败，index.html不存在');
    process.exit(1);
  }
  
  // 6. 强制部署到gh-pages
  console.log('🚀 强制部署到GitHub Pages...');
  execSync('npx gh-pages -d dist --remove "*"', { stdio: 'inherit' });
  
  // 7. 等待并验证
  console.log('⏳ 等待部署完成...');
  setTimeout(() => {
    console.log('🔍 验证部署结果...');
    try {
      const result = execSync('curl -s -o /dev/null -w "%{http_code}" https://kehan857.github.io/chanyeshujuzhongxin4.0/', { encoding: 'utf8' });
      if (result.trim() === '200') {
        console.log('🎉 部署成功！网站可以正常访问');
        console.log('🌐 访问地址: https://kehan857.github.io/chanyeshujuzhongxin4.0/');
      } else {
        console.log('⚠️  部署可能还在进行中，HTTP状态码:', result.trim());
        console.log('请等待2-5分钟后再次检查');
      }
    } catch (error) {
      console.log('⚠️  验证失败，请手动检查部署状态');
    }
  }, 30000);
  
} catch (error) {
  console.error('❌ 部署失败:', error.message);
  process.exit(1);
}

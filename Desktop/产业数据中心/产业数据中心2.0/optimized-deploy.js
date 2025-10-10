#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

console.log('🚀 优化部署脚本启动...');

// 生成缓存破坏器
const cacheBuster = Date.now().toString();
console.log(`📅 生成缓存破坏器: ${cacheBuster}`);

try {
  // 1. 更新缓存破坏文件
  console.log('🔄 更新缓存破坏文件...');
  fs.writeFileSync('public/cache-buster.txt', cacheBuster);
  fs.writeFileSync('public/force-deploy.txt', `Deploy: ${new Date().toISOString()}`);
  
  // 2. 确保在main分支
  console.log('📋 检查当前分支...');
  execSync('git checkout main', { stdio: 'inherit' });
  
  // 3. 提交缓存破坏文件
  console.log('💾 提交缓存破坏文件...');
  execSync('git add public/cache-buster.txt public/force-deploy.txt', { stdio: 'inherit' });
  execSync(`git commit -m "缓存破坏器更新 - ${cacheBuster}"`, { stdio: 'inherit' });
  
  // 4. 推送main分支
  console.log('📤 推送main分支...');
  execSync('git push origin-new4 main', { stdio: 'inherit' });
  
  // 5. 清理并重新构建
  console.log('🧹 清理构建目录...');
  if (fs.existsSync('dist')) {
    execSync('rm -rf dist', { stdio: 'inherit' });
  }
  
  // 6. 使用正确的环境变量构建
  console.log('🔨 重新构建项目...');
  execSync('NODE_ENV=production npm run build', { stdio: 'inherit' });
  
  // 7. 在构建文件中添加缓存破坏器
  console.log('⚡ 添加缓存破坏器到构建文件...');
  const indexPath = path.join('dist', 'index.html');
  if (fs.existsSync(indexPath)) {
    let content = fs.readFileSync(indexPath, 'utf8');
    
    // 添加缓存破坏器到所有资源链接
    content = content.replace(
      /src="([^"]*\.js)"/g, 
      `src="$1?v=${cacheBuster}"`
    );
    content = content.replace(
      /href="([^"]*\.css)"/g, 
      `href="$1?v=${cacheBuster}"`
    );
    
    // 添加缓存控制头
    content = content.replace(
      '<head>',
      `<head>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">`
    );
    
    fs.writeFileSync(indexPath, content);
    console.log('✅ 缓存破坏器已添加到构建文件');
  }
  
  // 8. 验证构建结果
  console.log('✅ 验证构建结果...');
  if (fs.existsSync(indexPath)) {
    const content = fs.readFileSync(indexPath, 'utf8');
    if (content.includes('/chanyeshujuzhongxin4.0/assets/')) {
      console.log('✅ 构建结果正确，包含正确的base路径');
    } else {
      console.log('❌ 构建结果错误，base路径不正确');
      process.exit(1);
    }
  } else {
    console.log('❌ 构建失败，index.html不存在');
    process.exit(1);
  }
  
  // 9. 强制部署到gh-pages
  console.log('🚀 强制部署到GitHub Pages...');
  execSync('npx gh-pages -d dist --remove "*"', { stdio: 'inherit' });
  
  // 10. 等待并验证
  console.log('⏳ 等待部署完成...');
  setTimeout(() => {
    console.log('🔍 验证部署结果...');
    try {
      const result = execSync('curl -s -o /dev/null -w "%{http_code}" https://kehan857.github.io/chanyeshujuzhongxin4.0/', { encoding: 'utf8' });
      if (result.trim() === '200') {
        console.log('🎉 部署成功！网站可以正常访问');
        console.log('🌐 访问地址: https://kehan857.github.io/chanyeshujuzhongxin4.0/');
        
        // 验证资源文件
        try {
          const jsResult = execSync('curl -s -o /dev/null -w "%{http_code}" https://kehan857.github.io/chanyeshujuzhongxin4.0/assets/index-DODysjzv.js', { encoding: 'utf8' });
          const cssResult = execSync('curl -s -o /dev/null -w "%{http_code}" https://kehan857.github.io/chanyeshujuzhongxin4.0/assets/index-ibEt2i2v.css', { encoding: 'utf8' });
          
          if (jsResult.trim() === '200' && cssResult.trim() === '200') {
            console.log('✅ 所有资源文件都可以正常访问');
          } else {
            console.log('⚠️  部分资源文件可能还在更新中');
            console.log(`JS文件状态: ${jsResult.trim()}, CSS文件状态: ${cssResult.trim()}`);
          }
        } catch (error) {
          console.log('⚠️  资源文件验证失败，请稍后手动检查');
        }
      } else {
        console.log('⚠️  部署可能还在进行中，HTTP状态码:', result.trim());
        console.log('请等待2-5分钟后再次检查');
      }
    } catch (error) {
      console.log('⚠️  验证失败，请手动检查部署状态');
    }
  }, 45000);
  
} catch (error) {
  console.error('❌ 部署失败:', error.message);
  process.exit(1);
}

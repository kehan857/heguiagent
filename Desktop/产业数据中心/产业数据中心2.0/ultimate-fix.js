#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🔥 终极修复脚本启动...');

try {
  // 1. 检查当前gh-pages分支内容
  console.log('📋 检查gh-pages分支内容...');
  execSync('git checkout gh-pages', { stdio: 'inherit' });
  
  const indexPath = 'index.html';
  if (fs.existsSync(indexPath)) {
    const content = fs.readFileSync(indexPath, 'utf8');
    console.log('当前gh-pages分支的index.html内容:');
    console.log(content.substring(0, 500));
    
    if (content.includes('guohua_knowledge')) {
      console.log('❌ 发现gh-pages分支仍然包含错误的路径！');
      
      // 2. 强制删除gh-pages分支并重新创建
      console.log('🗑️  删除gh-pages分支...');
      execSync('git checkout main', { stdio: 'inherit' });
      execSync('git branch -D gh-pages', { stdio: 'inherit' });
      
      // 3. 重新构建
      console.log('🔨 重新构建项目...');
      execSync('rm -rf dist', { stdio: 'inherit' });
      execSync('NODE_ENV=production npm run build', { stdio: 'inherit' });
      
      // 4. 验证构建结果
      const distIndexPath = path.join('dist', 'index.html');
      if (fs.existsSync(distIndexPath)) {
        const distContent = fs.readFileSync(distIndexPath, 'utf8');
        console.log('构建后的index.html内容:');
        console.log(distContent.substring(0, 500));
        
        if (distContent.includes('/chanyeshujuzhongxin4.0/assets/')) {
          console.log('✅ 构建结果正确');
        } else {
          console.log('❌ 构建结果仍然错误');
          process.exit(1);
        }
      }
      
      // 5. 创建全新的gh-pages分支
      console.log('🆕 创建全新的gh-pages分支...');
      execSync('git checkout --orphan gh-pages', { stdio: 'inherit' });
      execSync('git rm -rf .', { stdio: 'inherit' });
      execSync('cp -r dist/* .', { stdio: 'inherit' });
      execSync('git add .', { stdio: 'inherit' });
      execSync('git commit -m "全新部署 - 修复资源路径问题"', { stdio: 'inherit' });
      
      // 6. 强制推送到远程
      console.log('🚀 强制推送到远程gh-pages分支...');
      execSync('git push origin-new4 gh-pages --force', { stdio: 'inherit' });
      
      // 7. 切换回main分支
      execSync('git checkout main', { stdio: 'inherit' });
      
      console.log('✅ 终极修复完成！');
      
    } else {
      console.log('✅ gh-pages分支内容正确');
      execSync('git checkout main', { stdio: 'inherit' });
    }
  }
  
  // 8. 等待并验证
  console.log('⏳ 等待部署完成...');
  setTimeout(() => {
    console.log('🔍 最终验证...');
    try {
      const result = execSync('curl -s -o /dev/null -w "%{http_code}" https://kehan857.github.io/chanyeshujuzhongxin4.0/', { encoding: 'utf8' });
      console.log(`主页状态码: ${result.trim()}`);
      
      if (result.trim() === '200') {
        // 检查HTML内容
        const htmlContent = execSync('curl -s https://kehan857.github.io/chanyeshujuzhongxin4.0/', { encoding: 'utf8' });
        if (htmlContent.includes('/chanyeshujuzhongxin4.0/assets/')) {
          console.log('🎉 成功！HTML内容包含正确的路径');
          
          // 检查资源文件
          const jsResult = execSync('curl -s -o /dev/null -w "%{http_code}" https://kehan857.github.io/chanyeshujuzhongxin4.0/assets/index-DODysjzv.js', { encoding: 'utf8' });
          const cssResult = execSync('curl -s -o /dev/null -w "%{http_code}" https://kehan857.github.io/chanyeshujuzhongxin4.0/assets/index-ibEt2i2v.css', { encoding: 'utf8' });
          
          console.log(`JS文件状态: ${jsResult.trim()}, CSS文件状态: ${cssResult.trim()}`);
          
          if (jsResult.trim() === '200' && cssResult.trim() === '200') {
            console.log('🎉🎉🎉 完美！所有问题都已解决！');
            console.log('🌐 网站地址: https://kehan857.github.io/chanyeshujuzhongxin4.0/');
          } else {
            console.log('⚠️  资源文件可能还需要更多时间更新');
          }
        } else {
          console.log('❌ HTML内容仍然包含错误路径');
          console.log('HTML内容预览:', htmlContent.substring(0, 500));
        }
      } else {
        console.log('❌ 主页仍然无法访问');
      }
    } catch (error) {
      console.log('⚠️  验证失败:', error.message);
    }
  }, 60000);
  
} catch (error) {
  console.error('❌ 终极修复失败:', error.message);
  process.exit(1);
}

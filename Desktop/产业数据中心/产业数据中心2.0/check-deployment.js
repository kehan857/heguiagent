#!/usr/bin/env node

// 部署状态检查脚本
const { execSync } = require('child_process');

const BASE_URL = 'https://kehan857.github.io/chanyeshujuzhongxin4.0';
const PAGES = [
  { name: '主页', path: '/' },
  { name: 'AI搜索', path: '/ai-search' },
  { name: '企业库', path: '/enterprise' },
  { name: '方案库', path: '/solution' },
  { name: '知识库', path: '/knowledge' }
];

console.log('🔍 开始检查部署状态...\n');

// 检查GitHub Actions状态
console.log('📋 检查GitHub Actions状态...');
try {
  const actionsUrl = 'https://github.com/kehan857/chanyeshujuzhongxin4.0/actions';
  console.log(`   访问: ${actionsUrl}`);
  console.log('   请手动检查Actions页面，确保最新部署状态为绿色 ✅\n');
} catch (error) {
  console.log('   ❌ 无法检查Actions状态\n');
}

// 检查各个页面
console.log('🌐 检查页面访问状态...');
for (const page of PAGES) {
  try {
    const url = `${BASE_URL}${page.path}`;
    const response = execSync(`curl -s -o /dev/null -w '%{http_code}' "${url}"`, { encoding: 'utf8' });
    const statusCode = response.trim();
    
    if (statusCode === '200') {
      console.log(`   ✅ ${page.name}: ${url} (状态码: ${statusCode})`);
    } else {
      console.log(`   ❌ ${page.name}: ${url} (状态码: ${statusCode})`);
    }
  } catch (error) {
    console.log(`   ❌ ${page.name}: 检查失败 - ${error.message}`);
  }
}

console.log('\n📊 部署状态总结:');
console.log('   如果所有页面都返回200状态码，说明部署成功');
console.log('   如果有页面返回404，可能需要等待CDN缓存清除');
console.log('   如果持续有问题，请检查GitHub Actions日志');

console.log('\n🔧 故障排除建议:');
console.log('   1. 等待2-30分钟让CDN缓存清除');
console.log('   2. 使用无痕模式测试');
console.log('   3. 清除浏览器缓存');
console.log('   4. 检查本地代理设置');

console.log('\n📖 详细指南: 查看 DEPLOYMENT_GUIDE.md');

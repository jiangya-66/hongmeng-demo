const http = require('http');
const https = require('https');

const apiUrl = 'http://big-event-vue-api-t.itheima.net/api/login';

console.log('正在测试API连接...');
console.log(`API地址: ${apiUrl}`);

// 测试GET请求
const testGet = () => {
  return new Promise((resolve, reject) => {
    const req = http.get(apiUrl, (res) => {
      console.log(`状态码: ${res.statusCode}`);
      console.log(`响应头: ${JSON.stringify(res.headers)}`);
      
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      res.on('end', () => {
        console.log(`响应体: ${data}`);
        resolve({
          statusCode: res.statusCode,
          headers: res.headers,
          body: data
        });
      });
    });
    
    req.on('error', (err) => {
      console.error(`GET请求错误: ${err.message}`);
      reject(err);
    });
    
    req.setTimeout(10000, () => {
      req.destroy();
      reject(new Error('请求超时'));
    });
  });
};

// 测试POST请求（模拟登录）
const testPost = () => {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify({
      username: 'test',
      password: 'test123'
    });
    
    const options = {
      hostname: 'big-event-vue-api-t.itheima.net',
      port: 80,
      path: '/api/login',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      },
      timeout: 10000
    };
    
    const req = http.request(options, (res) => {
      console.log(`POST状态码: ${res.statusCode}`);
      console.log(`POST响应头: ${JSON.stringify(res.headers)}`);
      
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      res.on('end', () => {
        console.log(`POST响应体: ${data}`);
        resolve({
          statusCode: res.statusCode,
          headers: res.headers,
          body: data
        });
      });
    });
    
    req.on('error', (err) => {
      console.error(`POST请求错误: ${err.message}`);
      reject(err);
    });
    
    req.write(postData);
    req.end();
  });
};

// 测试DNS解析
const testDns = () => {
  return new Promise((resolve, reject) => {
    const dns = require('dns');
    
    dns.lookup('big-event-vue-api-t.itheima.net', (err, address, family) => {
      if (err) {
        console.error(`DNS解析失败: ${err.message}`);
        reject(err);
      } else {
        console.log(`DNS解析成功: ${address} (IPv${family})`);
        resolve({ address, family });
      }
    });
  });
};

// 运行所有测试
async function runTests() {
  console.log('=== 开始API连接测试 ===');
  
  try {
    // 测试DNS解析
    console.log('\n1. 测试DNS解析...');
    await testDns();
    
    // 测试GET请求
    console.log('\n2. 测试GET请求...');
    await testGet();
    
    // 测试POST请求
    console.log('\n3. 测试POST请求...');
    await testPost();
    
    console.log('\n=== 所有测试完成 ===');
  } catch (error) {
    console.error(`\n测试失败: ${error.message}`);
    
    // 检查常见问题
    console.log('\n=== 故障排除建议 ===');
    console.log('1. 检查网络连接是否正常');
    console.log('2. 检查API服务器是否运行: http://big-event-vue-api-t.itheima.net');
    console.log('3. 检查防火墙或代理设置');
    console.log('4. 尝试使用其他网络环境');
    console.log('5. 确认API地址是否正确: http://big-event-vue-api-t.itheima.net/api/login');
    
    process.exit(1);
  }
}

runTests();
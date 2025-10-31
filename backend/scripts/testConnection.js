// Simple test to check backend connectivity
const http = require('http');

console.log('Testing backend API...\n');

// Test 1: Check if server is reachable
const testData = JSON.stringify({
  email: 'admin@school.com',
  password: 'admin123',
  role: 'Admin'
});

const options = {
  hostname: '192.168.31.75',
  port: 3000,
  path: '/api/auth/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(testData)
  },
  timeout: 5000
};

console.log(`🔄 POST http://192.168.31.75:3000/api/auth/login`);
console.log(`📦 Body: ${testData}\n`);

const req = http.request(options, (res) => {
  let data = '';

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    console.log(`✅ Status: ${res.statusCode}`);
    console.log(`📨 Response: ${data}\n`);
    
    if (res.statusCode === 200) {
      try {
        const parsed = JSON.parse(data);
        console.log('✅ Login successful!');
        console.log(`Token: ${parsed.token.substring(0, 20)}...`);
        console.log(`User: ${parsed.user.name} (${parsed.user.role})`);
      } catch (e) {
        console.log('❌ Failed to parse response');
      }
    } else {
      console.log('❌ Login failed');
    }
  });
});

req.on('error', (error) => {
  console.error('❌ Connection error:', error.message);
  console.log('\n📝 Troubleshooting:');
  console.log('1. Check if backend server is running (npm start)');
  console.log('2. Check if firewall is blocking port 3000');
  console.log('3. Verify your IP address: ipconfig');
  console.log('4. Make sure phone and PC are on same WiFi network');
});

req.on('timeout', () => {
  console.error('❌ Request timeout');
  req.destroy();
});

req.write(testData);
req.end();

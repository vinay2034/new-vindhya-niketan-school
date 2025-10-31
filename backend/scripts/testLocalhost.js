const http = require('http');

console.log('Testing backend API on localhost...\n');

const testData = JSON.stringify({
  email: 'admin@school.com',
  password: 'admin123',
  role: 'Admin'
});

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/api/auth/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(testData)
  }
};

console.log(`🔄 POST http://localhost:3000/api/auth/login\n`);

const req = http.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    console.log(`✅ Status: ${res.statusCode}`);
    console.log(`📨 Response:`);
    try {
      const parsed = JSON.parse(data);
      console.log(JSON.stringify(parsed, null, 2));
      if (parsed.token) {
        console.log('\n✅ Backend API is working correctly!');
        console.log('\n⚠️ To access from your phone, add firewall rule:');
        console.log('Run PowerShell as Administrator:');
        console.log('netsh advfirewall firewall add rule name="Node.js Port 3000" dir=in action=allow protocol=TCP localport=3000');
      }
    } catch (e) {
      console.log(data);
    }
  });
});

req.on('error', (error) => {
  console.error('❌ Error:', error.message);
});

req.write(testData);
req.end();

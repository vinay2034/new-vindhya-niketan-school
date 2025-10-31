const http = require('http');

function testLoginAPI() {
  const postData = JSON.stringify({
    email: 'admin@school.com',
    password: 'admin123',
    role: 'admin'
  });

  const options = {
    hostname: 'localhost',
    port: 3000,
    path: '/api/auth/login',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(postData)
    }
  };

  console.log('🔄 Testing login API endpoint...');
  console.log(`POST http://localhost:3000/api/auth/login`);
  console.log('Body:', postData);
  console.log('');

  const req = http.request(options, (res) => {
    let data = '';

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      console.log(`Status Code: ${res.statusCode}`);
      console.log('Response:', data);
      
      if (res.statusCode === 200) {
        console.log('\n✅ Login API is working!');
      } else {
        console.log('\n❌ Login API returned error');
      }
    });
  });

  req.on('error', (error) => {
    console.error('❌ Connection error:', error.message);
    console.log('\nIs the server running? Try: npm start');
  });

  req.write(postData);
  req.end();
}

testLoginAPI();

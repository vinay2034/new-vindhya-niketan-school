const axios = require('axios');

async function test() {
  try {
    console.log('Testing login API...\n');
    
    const response = await axios.post('http://localhost:3000/api/auth/login', {
      email: 'admin@school.com',
      password: 'admin123',
      role: 'Admin'
    });

    console.log('✅ Success!');
    console.log('Status:', response.status);
    console.log('Token:', response.data.token.substring(0, 30) + '...');
    console.log('User:', response.data.user.name, '-', response.data.user.role);
    
  } catch (error) {
    console.error('❌ Error:');
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Message:', error.response.data);
    } else if (error.request) {
      console.error('No response received from server');
      console.error('Request was made but no response');
    } else {
      console.error('Error:', error.message);
    }
  }
}

test();

require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../models/User');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/school_app';

async function verifyDemoAccounts() {
  try {
    await mongoose.connect(MONGODB_URI);
    console.log('✅ MongoDB Connected\n');

    const users = await User.find({}).select('-password');
    
    if (users.length === 0) {
      console.log('❌ No users found in database!');
      console.log('Run: npm run seed:demo');
    } else {
      console.log('📋 Users in database:');
      console.log('━'.repeat(60));
      users.forEach(user => {
        console.log(`Role: ${(user.role || 'N/A').padEnd(10)} | Username: ${(user.username || 'N/A').padEnd(15)} | Name: ${user.name || 'N/A'}`);
      });
      console.log('━'.repeat(60));
      console.log(`\nTotal users: ${users.length}`);
    }

    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

verifyDemoAccounts();
require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../models/User');

async function testLogin() {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB\n');

    // Check if users exist
    const users = await User.find({}).select('email role name');
    console.log('📋 Users in database:');
    users.forEach(user => {
      console.log(`  - ${user.role}: ${user.email} (${user.name})`);
    });

    // Test password comparison for admin
    console.log('\n🔐 Testing password comparison:');
    const adminUser = await User.findOne({ email: 'admin@school.com', role: 'admin' });
    if (adminUser) {
      const isValid = await adminUser.comparePassword('admin123');
      console.log(`  Admin password check: ${isValid ? '✅ VALID' : '❌ INVALID'}`);
    } else {
      console.log('  ❌ Admin user not found');
    }

    const teacherUser = await User.findOne({ email: 'teacher@school.com', role: 'teacher' });
    if (teacherUser) {
      const isValid = await teacherUser.comparePassword('teacher123');
      console.log(`  Teacher password check: ${isValid ? '✅ VALID' : '❌ INVALID'}`);
    } else {
      console.log('  ❌ Teacher user not found');
    }

    const parentUser = await User.findOne({ email: 'parent@school.com', role: 'parent' });
    if (parentUser) {
      const isValid = await parentUser.comparePassword('parent123');
      console.log(`  Parent password check: ${isValid ? '✅ VALID' : '❌ INVALID'}`);
    } else {
      console.log('  ❌ Parent user not found');
    }

    process.exit(0);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

testLogin();

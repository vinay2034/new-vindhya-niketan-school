const mongoose = require('mongoose');
const User = require('../models/user');
require('dotenv').config();

const demoUsers = [
  {
    name: 'Admin Demo',
    email: 'admin@demo.com',
    password: 'admin123',
    role: 'Admin',
    phoneNumber: '1234567890'
  },
  {
    name: 'Teacher Demo',
    email: 'teacher@demo.com',
    password: 'teacher123',
    role: 'Teacher',
    phoneNumber: '1234567891'
  },
  {
    name: 'Parent Demo',
    email: 'parent@demo.com',
    password: 'parent123',
    role: 'Parent',
    phoneNumber: '1234567892'
  }
];

async function seedDatabase() {
  try {
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/school_app');
    console.log('Connected to MongoDB');

    // Clear existing users
    await User.deleteMany({});
    console.log('Cleared existing users');

    // Create new users
    await User.create(demoUsers);
    console.log('Demo users created successfully');

    console.log('\nDemo Credentials:');
    console.log('------------------');
    console.log('Admin:');
    console.log('Email: admin@demo.com');
    console.log('Password: admin123');
    console.log('\nTeacher:');
    console.log('Email: teacher@demo.com');
    console.log('Password: teacher123');
    console.log('\nParent:');
    console.log('Email: parent@demo.com');
    console.log('Password: parent123');

    await mongoose.connection.close();
  } catch (error) {
    console.error('Error seeding database:', error);
  }
}

seedDatabase();
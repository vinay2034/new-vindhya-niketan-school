require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../src/models/user');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/school_app';

// Demo users for testing
const demoUsers = [
  {
    email: 'admin@school.com',
    password: 'admin123',
    role: 'Admin',
    name: 'Admin Demo',
    staffId: 'ADM001'
  },
  {
    email: 'teacher@school.com',
    password: 'teacher123',
    role: 'Teacher',
    name: 'Teacher Demo',
    staffId: 'TCH001',
    subjects: ['Mathematics', 'Physics']
  },
  {
    email: 'parent@school.com',
    password: 'parent123',
    role: 'Parent',
    name: 'Parent Demo',
    phone: '1234567890'
  }
];

async function seedDatabase() {
  try {
    // Connect to MongoDB
    await mongoose.connect(MONGODB_URI);
    console.log('MongoDB Connected for seeding...');

    // Clear existing demo users
    await User.deleteMany({ email: { $in: ['admin@school.com', 'teacher@school.com', 'parent@school.com'] } });
    console.log('Cleared existing demo users');

    // Create new demo users
    for (const userData of demoUsers) {
      const user = new User(userData);
      await user.save();
      console.log(`✓ Created ${userData.role} account: ${userData.email} / ${userData.password}`);
    }

    console.log('\n✅ Database seeded successfully!');
    console.log('\n📋 Demo Accounts:');
    console.log('━'.repeat(60));
    console.log('Admin:   email: admin@school.com   | password: admin123');
    console.log('Teacher: email: teacher@school.com | password: teacher123');
    console.log('Parent:  email: parent@school.com  | password: parent123');
    console.log('━'.repeat(60));

    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
}

seedDatabase();
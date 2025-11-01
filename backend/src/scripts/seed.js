const bcrypt = require('bcryptjs');
const { sequelize } = require('../config/database');
const User = require('../models/User');
const Class = require('../models/Class');
const Subject = require('../models/Subject');
require('dotenv').config();

const seed = async () => {
  try {
    console.log('Starting database seed...');
    await sequelize.authenticate();
    console.log('Connected to MySQL');
    await sequelize.sync({ force: true });
    console.log('Tables created');
    
    const admin = await bcrypt.hash('admin123', 10);
    const teacher = await bcrypt.hash('teacher123', 10);
    const parent = await bcrypt.hash('parent123', 10);
    
    const users = await User.bulkCreate([
      { name: 'Admin User', email: 'admin@school.com', password: admin, role: 'Admin', phone: '1234567890', status: 'active' },
      { name: 'Ms. Johnson', email: 'johnson@school.com', password: teacher, role: 'Teacher', phone: '2345678901', status: 'active' },
      { name: 'Mr. Williams', email: 'williams@school.com', password: teacher, role: 'Teacher', phone: '2345678902', status: 'active' },
      { name: 'Ms. Davis', email: 'davis@school.com', password: teacher, role: 'Teacher', phone: '2345678903', status: 'active' },
      { name: 'Mr. Brown', email: 'brown@school.com', password: teacher, role: 'Teacher', phone: '2345678904', status: 'active' },
      { name: 'John Parent', email: 'parent@school.com', password: parent, role: 'Parent', phone: '3456789012', status: 'active' }
    ]);
    console.log('Created users');
    
    const classes = await Class.bulkCreate([
      { name: 'LKG A', grade: 'LKG', section: 'A', academicYear: '2024-2025', capacity: 30, teacherId: users[1].id },
      { name: 'Grade 1 B', grade: 'Grade 1', section: 'B', academicYear: '2024-2025', capacity: 35, teacherId: users[2].id },
      { name: 'Grade 5 C', grade: 'Grade 5', section: 'C', academicYear: '2024-2025', capacity: 40, teacherId: users[3].id }
    ]);
    console.log('Created classes');
    
    await Subject.bulkCreate([
      { name: 'Mathematics', code: 'LKG-MATH', description: 'Basic math', classId: classes[0].id, teacherId: users[1].id, credits: 1 },
      { name: 'English', code: 'LKG-ENG', description: 'English basics', classId: classes[0].id, teacherId: users[1].id, credits: 1 },
      { name: 'Science', code: 'G1-SCI', description: 'Basic science', classId: classes[1].id, teacherId: users[3].id, credits: 1 },
      { name: 'Social Studies', code: 'G1-SOC', description: 'Social studies', classId: classes[1].id, teacherId: users[2].id, credits: 1 },
      { name: 'History', code: 'G5-HIS', description: 'World history', classId: classes[2].id, teacherId: users[4].id, credits: 1 },
      { name: 'Geography', code: 'G5-GEO', description: 'Geography', classId: classes[2].id, teacherId: users[4].id, credits: 1 }
    ]);
    console.log('Created subjects');
    console.log('Seeding complete!');
    console.log('Login with: admin@school.com / admin123');
    process.exit(0);
  } catch (error) {
    console.error('Seed error:', error);
    process.exit(1);
  }
};

seed();
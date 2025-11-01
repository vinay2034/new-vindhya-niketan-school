const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Class = sequelize.define('Class', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  name: { type: DataTypes.STRING(50), allowNull: false },
  grade: { type: DataTypes.STRING(20), allowNull: false },
  section: { type: DataTypes.STRING(10), allowNull: true },
  academicYear: { type: DataTypes.STRING(20), allowNull: false, defaultValue: '2024-2025' },
  capacity: { type: DataTypes.INTEGER, defaultValue: 40 },
  teacherId: { type: DataTypes.INTEGER, allowNull: true, references: { model: 'users', key: 'id' } },
  createdBy: { type: DataTypes.INTEGER, allowNull: true, references: { model: 'users', key: 'id' } }
}, {
  tableName: 'classes',
  timestamps: true
});

module.exports = Class;
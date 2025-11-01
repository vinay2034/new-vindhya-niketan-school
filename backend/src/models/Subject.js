const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Subject = sequelize.define('Subject', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  name: { type: DataTypes.STRING(100), allowNull: false },
  code: { type: DataTypes.STRING(20), allowNull: true, unique: true },
  description: { type: DataTypes.TEXT, allowNull: true },
  classId: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'classes', key: 'id' } },
  teacherId: { type: DataTypes.INTEGER, allowNull: true, references: { model: 'users', key: 'id' } },
  credits: { type: DataTypes.INTEGER, defaultValue: 1 }
  ,
  createdBy: { type: DataTypes.INTEGER, allowNull: true, references: { model: 'users', key: 'id' } }
}, {
  tableName: 'subjects',
  timestamps: true
});

module.exports = Subject;
const User = require('./User');
const Class = require('./Class');
const Subject = require('./Subject');

Class.belongsTo(User, { as: 'classTeacher', foreignKey: 'teacherId' });
Subject.belongsTo(Class, { as: 'class', foreignKey: 'classId', onDelete: 'CASCADE' });
Subject.belongsTo(User, { as: 'teacher', foreignKey: 'teacherId' });
User.hasMany(Class, { as: 'classes', foreignKey: 'teacherId' });
User.hasMany(Subject, { as: 'subjects', foreignKey: 'teacherId' });
Class.hasMany(Subject, { as: 'subjects', foreignKey: 'classId' });

module.exports = { User, Class, Subject };
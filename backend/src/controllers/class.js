const Class = require('../models/Class');
const User = require('../models/User');
const Subject = require('../models/Subject');

// Get all classes
exports.getAllClasses = async (req, res) => {
  try {
    // Fetch classes without associations first
    const classes = await Class.findAll({
      order: [['grade', 'ASC'], ['section', 'ASC']],
      raw: false
    });

    // Then manually fetch related data for each class
    const classesWithData = await Promise.all(classes.map(async (classItem) => {
      const classObj = classItem.toJSON();
      
      // Try to get teacher if teacherId exists
      if (classObj.teacherId) {
        try {
          const teacher = await User.findByPk(classObj.teacherId, {
            attributes: ['id', 'name', 'email']
          });
          classObj.classTeacher = teacher;
        } catch (err) {
          classObj.classTeacher = null;
        }
      } else {
        classObj.classTeacher = null;
      }
      // Fetch creator info if available
      if (classObj.createdBy) {
        try {
          const creator = await User.findByPk(classObj.createdBy, { attributes: ['id', 'name', 'email'] });
          classObj.createdByUser = creator;
        } catch (err) {
          classObj.createdByUser = null;
        }
      } else {
        classObj.createdByUser = null;
      }
      
      // Try to get subjects for this class
      try {
        const subjects = await Subject.findAll({
          where: { classId: classObj.id },
          raw: true
        });
        classObj.subjects = subjects || [];
      } catch (err) {
        classObj.subjects = [];
      }
      
      return classObj;
    }));

    res.json({ classes: classesWithData });
  } catch (error) {
    console.error('Get classes error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Get class by ID
exports.getClassById = async (req, res) => {
  try {
    const classData = await Class.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'classTeacher',
          attributes: ['id', 'name', 'email'],
          required: false // Make teacher optional
        },
        {
          model: Subject,
          as: 'subjects',
          required: false, // Make subjects optional
          include: [{
            model: User,
            as: 'teacher',
            attributes: ['id', 'name'],
            required: false // Make subject teacher optional
          }]
        }
      ]
    });

    if (!classData) {
      return res.status(404).json({ message: 'Class not found' });
    }

    // convert to plain object and include creator info if present
    const classObj = classData.toJSON ? classData.toJSON() : classData;
    if (classObj.createdBy) {
      try {
        const creator = await User.findByPk(classObj.createdBy, { attributes: ['id', 'name', 'email'] });
        classObj.createdByUser = creator;
      } catch (err) {
        classObj.createdByUser = null;
      }
    } else {
      classObj.createdByUser = null;
    }

    res.json({ class: classObj });
  } catch (error) {
    console.error('Get class error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Create new class
exports.createClass = async (req, res) => {
  try {
    const { name, grade, section, academicYear, capacity, teacherId } = req.body;

    if (!name || !grade) {
      return res.status(400).json({ 
        message: 'Please provide name and grade' 
      });
    }

    // Check if teacher exists
    if (teacherId) {
      const teacher = await User.findOne({
        where: { id: teacherId, role: 'Teacher' }
      });
      if (!teacher) {
        return res.status(400).json({ 
          message: 'Teacher not found' 
        });
      }
    }

    const newClass = await Class.create({
      name,
      grade,
      section,
      academicYear,
      capacity,
      teacherId,
      createdBy: req.user ? req.user.id : null
    });

    res.status(201).json({
      message: 'Class created successfully',
      class: newClass
    });
  } catch (error) {
    console.error('Create class error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Update class
exports.updateClass = async (req, res) => {
  try {
    const { name, grade, section, academicYear, capacity, teacherId } = req.body;

    const classData = await Class.findByPk(req.params.id);
    if (!classData) {
      return res.status(404).json({ message: 'Class not found' });
    }

    // Check if teacher exists
    if (teacherId) {
      const teacher = await User.findOne({
        where: { id: teacherId, role: 'Teacher' }
      });
      if (!teacher) {
        return res.status(400).json({ 
          message: 'Teacher not found' 
        });
      }
    }

    await classData.update({
      name: name || classData.name,
      grade: grade || classData.grade,
      section: section !== undefined ? section : classData.section,
      academicYear: academicYear || classData.academicYear,
      capacity: capacity || classData.capacity,
      teacherId: teacherId !== undefined ? teacherId : classData.teacherId
    });

    res.json({
      message: 'Class updated successfully',
      class: classData
    });
  } catch (error) {
    console.error('Update class error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Delete class
exports.deleteClass = async (req, res) => {
  try {
    const classData = await Class.findByPk(req.params.id);
    if (!classData) {
      return res.status(404).json({ message: 'Class not found' });
    }

    await classData.destroy();

    res.json({ message: 'Class deleted successfully' });
  } catch (error) {
    console.error('Delete class error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

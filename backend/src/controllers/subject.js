const Subject = require('../models/Subject');
const Class = require('../models/Class');
const User = require('../models/User');

// Get all subjects
exports.getAllSubjects = async (req, res) => {
  try {
    // Fetch subjects without associations first
    const subjects = await Subject.findAll({
      order: [['name', 'ASC']],
      raw: false
    });

    // Then manually fetch related data for each subject
    const subjectsWithData = await Promise.all(subjects.map(async (subjectItem) => {
      const subjectObj = subjectItem.toJSON();
      
      // Manually fetch class if classId exists
      if (subjectObj.classId) {
        const classData = await Class.findByPk(subjectObj.classId, {
          attributes: ['id', 'name', 'grade']
        });
        subjectObj.class = classData;
      } else {
        subjectObj.class = null;
      }
      
      // Manually fetch teacher if teacherId exists
      if (subjectObj.teacherId) {
        const teacherData = await User.findByPk(subjectObj.teacherId, {
          attributes: ['id', 'name', 'email']
        });
        subjectObj.teacher = teacherData;
      } else {
        subjectObj.teacher = null;
      }
      
      // Fetch creator info if available
      if (subjectObj.createdBy) {
        try {
          const creator = await User.findByPk(subjectObj.createdBy, { attributes: ['id', 'name', 'email'] });
          subjectObj.createdByUser = creator;
        } catch (err) {
          subjectObj.createdByUser = null;
        }
      } else {
        subjectObj.createdByUser = null;
      }
      
      return subjectObj;
    }));

    res.json({ subjects: subjectsWithData });
  } catch (error) {
    console.error('Get subjects error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Get subject by ID
exports.getSubjectById = async (req, res) => {
  try {
    const subject = await Subject.findByPk(req.params.id);

    if (!subject) {
      return res.status(404).json({ message: 'Subject not found' });
    }

    const subjectObj = subject.toJSON();
    
    // Manually fetch class if classId exists
    if (subjectObj.classId) {
      const classData = await Class.findByPk(subjectObj.classId, {
        attributes: ['id', 'name', 'grade']
      });
      subjectObj.class = classData;
    } else {
      subjectObj.class = null;
    }
    
    // Manually fetch teacher if teacherId exists
    if (subjectObj.teacherId) {
      const teacherData = await User.findByPk(subjectObj.teacherId, {
        attributes: ['id', 'name', 'email']
      });
      subjectObj.teacher = teacherData;
    } else {
      subjectObj.teacher = null;
    }

    // include creator info for subject
    if (subjectObj.createdBy) {
      try {
        const creator = await User.findByPk(subjectObj.createdBy, { attributes: ['id', 'name', 'email'] });
        subjectObj.createdByUser = creator;
      } catch (err) {
        subjectObj.createdByUser = null;
      }
    } else {
      subjectObj.createdByUser = null;
    }

    res.json({ subject: subjectObj });
  } catch (error) {
    console.error('Get subject error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Create new subject
exports.createSubject = async (req, res) => {
  try {
    const { name, code, description, classId, teacherId, credits } = req.body;

    if (!name || !classId) {
      return res.status(400).json({ 
        message: 'Please provide name and classId' 
      });
    }

    // Check if class exists
    const classData = await Class.findByPk(classId);
    if (!classData) {
      return res.status(400).json({ 
        message: 'Class not found' 
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

    const subject = await Subject.create({
      name,
      code,
      description,
      classId,
      teacherId,
      credits,
      createdBy: req.user ? req.user.id : null
    });

    res.status(201).json({
      message: 'Subject created successfully',
      subject
    });
  } catch (error) {
    console.error('Create subject error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Update subject
exports.updateSubject = async (req, res) => {
  try {
    const { name, code, description, classId, teacherId, credits } = req.body;

    const subject = await Subject.findByPk(req.params.id);
    if (!subject) {
      return res.status(404).json({ message: 'Subject not found' });
    }

    // Check if class exists
    if (classId) {
      const classData = await Class.findByPk(classId);
      if (!classData) {
        return res.status(400).json({ 
          message: 'Class not found' 
        });
      }
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

    await subject.update({
      name: name || subject.name,
      code: code !== undefined ? code : subject.code,
      description: description !== undefined ? description : subject.description,
      classId: classId || subject.classId,
      teacherId: teacherId !== undefined ? teacherId : subject.teacherId,
      credits: credits || subject.credits
    });

    res.json({
      message: 'Subject updated successfully',
      subject
    });
  } catch (error) {
    console.error('Update subject error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

// Delete subject
exports.deleteSubject = async (req, res) => {
  try {
    const subject = await Subject.findByPk(req.params.id);
    if (!subject) {
      return res.status(404).json({ message: 'Subject not found' });
    }

    await subject.destroy();

    res.json({ message: 'Subject deleted successfully' });
  } catch (error) {
    console.error('Delete subject error:', error);
    res.status(500).json({ 
      message: 'Server error', 
      error: error.message 
    });
  }
};

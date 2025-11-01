const express = require('express');
const router = express.Router();
const subjectController = require('../controllers/subject');
const { auth, authorize } = require('../middleware/auth');

router.use(auth);
router.get('/', subjectController.getAllSubjects);
router.get('/:id', subjectController.getSubjectById);
router.post('/', authorize('Admin'), subjectController.createSubject);
router.put('/:id', authorize('Admin'), subjectController.updateSubject);
router.delete('/:id', authorize('Admin'), subjectController.deleteSubject);

module.exports = router;

const express = require('express');
const router = express.Router();
const classController = require('../controllers/class');
const { auth, authorize } = require('../middleware/auth');

router.use(auth);
router.get('/', classController.getAllClasses);
router.get('/:id', classController.getClassById);
router.post('/', authorize('Admin'), classController.createClass);
router.put('/:id', authorize('Admin'), classController.updateClass);
router.delete('/:id', authorize('Admin'), classController.deleteClass);

module.exports = router;

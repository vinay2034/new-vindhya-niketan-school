const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');
const { auth, authorize } = require('../middleware/auth');

router.use(auth);

// Get all teachers (accessible to all authenticated users)
router.get('/teachers', userController.getAllTeachers);

// Admin only routes
router.get('/', authorize('Admin'), userController.getAllUsers);
router.get('/:id', authorize('Admin'), userController.getUserById);
router.put('/:id', authorize('Admin'), userController.updateUser);
router.delete('/:id', authorize('Admin'), userController.deleteUser);

module.exports = router;

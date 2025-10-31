const express = require('express');
const { body } = require('express-validator');
const authController = require('../controllers/auth');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// Login route
router.post('/login', [
  body('email').isEmail().normalizeEmail(),
  body('password').trim().notEmpty(),
  body('role').isIn(['admin', 'teacher', 'parent', 'Admin', 'Teacher', 'Parent'])
], authController.login);

// Register route
router.post('/register', [
  body('name').trim().notEmpty(),
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  body('role').isIn(['Admin', 'Teacher', 'Parent']),
  body('phoneNumber').optional().isMobilePhone()
], authController.register);

// Change password route (protected)
router.post('/change-password',
  authMiddleware,
  [
    body('oldPassword').trim().notEmpty(),
    body('newPassword').isLength({ min: 6 })
  ],
  authController.changePassword
);

module.exports = router;
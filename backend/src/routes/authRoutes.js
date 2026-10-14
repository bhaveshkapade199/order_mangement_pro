const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { protect } = require('../middlewares/authMiddleware');

// Step 1: Send OTP (with Zoho validation for dealers)
router.post('/send-otp', authController.sendOtp);

// Step 2: Verify OTP and Login
router.post('/verify-otp', authController.verifyOtp);

// Get current profile
router.get('/profile', protect, authController.getProfile);

module.exports = router;

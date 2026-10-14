const express = require('express');
const router = express.Router();
const plumberController = require('../controllers/plumberController');
const { protect } = require('../middlewares/authMiddleware');
const { restrictTo } = require('../middlewares/roleMiddleware');
const { ROLES } = require('../utils/constants');

// Protect and restrict to plumber and admin
router.use(protect);
router.use(restrictTo(ROLES.PLUMBER, ROLES.ADMIN));

// Plumber Dashboard Summary
router.get('/dashboard', plumberController.getDashboardSummary);

// Assigned tasks
router.get('/tasks', plumberController.getAssignedTasks);

// Update task status (e.g., mark completed)
router.patch('/tasks/:taskId', plumberController.updateTaskStatus);

// Plumbing catalog & spare parts
router.get('/products', plumberController.getPlumberProducts);

// Notifications & alerts
router.get('/notifications', plumberController.getNotifications);

module.exports = router;

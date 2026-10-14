const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { protect } = require('../middlewares/authMiddleware');
const { restrictTo } = require('../middlewares/roleMiddleware');
const { ROLES } = require('../utils/constants');

// Protect and restrict to admin only
router.use(protect);
router.use(restrictTo(ROLES.ADMIN));

// User management (Customers, Dealers, Plumbers)
router.get('/users', adminController.getUsers);

// Dealer credit eligibility (30/90 days permissions & credit limit)
router.patch('/dealers/:userId/credit', adminController.updateDealerCredit);

// Plumber verification management
router.patch('/plumbers/:userId/verify', adminController.updatePlumberVerification);

// Order management
router.get('/orders', adminController.getAllOrders);
router.patch('/orders/:orderId/status', adminController.updateOrderStatus);

// Executive business reports
router.get('/reports', adminController.getReports);

// Trigger Zoho Workbook synchronization
router.post('/zoho-sync', adminController.triggerZohoSync);

module.exports = router;

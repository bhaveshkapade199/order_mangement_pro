const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');
const { protect } = require('../middlewares/authMiddleware');

router.use(protect); // All order actions require authentication

// Create order (Customer direct payment or Dealer upfront / 30-day / 90-day credit)
router.post('/', orderController.createOrder);

// Get user orders
router.get('/', orderController.getMyOrders);

// Track order
router.get('/tracking/:orderId', orderController.getOrderTracking);

module.exports = router;

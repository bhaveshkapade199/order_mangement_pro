const express = require('express');
const router = express.Router();

const authRoutes = require('./authRoutes');
const productRoutes = require('./productRoutes');
const orderRoutes = require('./orderRoutes');
const plumberRoutes = require('./plumberRoutes');
const adminRoutes = require('./adminRoutes');
const zohoRoutes = require('./zohoRoutes');

// Mount modules
router.use('/auth', authRoutes);
router.use('/products', productRoutes);
router.use('/orders', orderRoutes);
router.use('/plumber', plumberRoutes);
router.use('/admin', adminRoutes);
router.use('/zoho', zohoRoutes);

// Root health check endpoint
router.get('/health', (req, res) => {
  res.json({
    status: 'online',
    system: 'Multi-Role Commercial Commerce Engine',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

module.exports = router;

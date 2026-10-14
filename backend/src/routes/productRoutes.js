const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const { optionalAuth } = require('../middlewares/authMiddleware');

router.get('/categories', productController.getCategories);


router.get('/', optionalAuth, productController.getProducts);


router.get('/:id', optionalAuth, productController.getProductById);

module.exports = router;

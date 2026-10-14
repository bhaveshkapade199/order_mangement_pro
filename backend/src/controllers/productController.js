const Product = require('../models/Product');
const Category = require('../models/Category');
const ApiResponse = require('../utils/apiResponse');
const { ROLES } = require('../utils/constants');

/**
 * Get Products List
 * Key Difference Enforcement:
 * - Customers can view products and prices but CANNOT see stock quantity.
 * - Dealers can view available stock quantity and dealer wholesale pricing.
 */
exports.getProducts = async (req, res, next) => {
  try {
    const { category, search, page = 1, limit = 20 } = req.query;
    const filter = { isActive: true };

    if (category && category !== 'All') {
      filter.category = new RegExp(category, 'i');
    }

    if (search) {
      filter.$or = [
        { name: new RegExp(search, 'i') },
        { sku: new RegExp(search, 'i') },
        { description: new RegExp(search, 'i') },
      ];
    }

    const isDealer = req.user && (req.user.role === ROLES.DEALER || req.user.role === ROLES.ADMIN);

    const products = await Product.find(filter)
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(Number(limit));

    const totalCount = await Product.countDocuments(filter);

    // Apply role-based data projection
    const transformed = products.map((prod) => {
      const p = prod.toObject();

      if (!isDealer) {
        // Customer / Guest view: Mask stock quantity
        return {
          id: p._id,
          zohoItemId: p.zohoItemId,
          name: p.name,
          sku: p.sku,
          category: p.category,
          price: p.price,
          inStock: p.stockQuantity > 0, // Boolean availability indicator only
          unit: p.unit,
          description: p.description,
          imageUrl: p.imageUrl,
          specifications: p.specifications,
          // stockQuantity is intentionally omitted for customers
        };
      }

      // Dealer view: Full stock visibility & wholesale pricing
      return {
        id: p._id,
        zohoItemId: p.zohoItemId,
        name: p.name,
        sku: p.sku,
        category: p.category,
        retailPrice: p.price,
        dealerPrice: p.dealerPrice || p.price,
        effectivePrice: p.dealerPrice || p.price,
        stockQuantity: p.stockQuantity, // Visible ONLY to dealers
        unit: p.unit,
        description: p.description,
        imageUrl: p.imageUrl,
        specifications: p.specifications,
        lastZohoSyncAt: p.lastZohoSyncAt,
      };
    });

    return ApiResponse.success(res, 'Products fetched successfully', {
      userRole: req.user ? req.user.role : 'guest_customer',
      canViewStockQuantity: isDealer,
      total: totalCount,
      page: Number(page),
      products: transformed,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get Product Details by ID
 */
exports.getProductById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);

    if (!product) {
      return ApiResponse.error(res, 'Product not found', 404);
    }

    const isDealer = req.user && (req.user.role === ROLES.DEALER || req.user.role === ROLES.ADMIN);
    const p = product.toObject();

    let result;
    if (!isDealer) {
      result = {
        id: p._id,
        zohoItemId: p.zohoItemId,
        name: p.name,
        sku: p.sku,
        category: p.category,
        price: p.price,
        inStock: p.stockQuantity > 0,
        unit: p.unit,
        description: p.description,
        imageUrl: p.imageUrl,
        specifications: p.specifications,
      };
    } else {
      result = {
        id: p._id,
        zohoItemId: p.zohoItemId,
        name: p.name,
        sku: p.sku,
        category: p.category,
        retailPrice: p.price,
        dealerPrice: p.dealerPrice || p.price,
        effectivePrice: p.dealerPrice || p.price,
        stockQuantity: p.stockQuantity,
        unit: p.unit,
        description: p.description,
        imageUrl: p.imageUrl,
        specifications: p.specifications,
        lastZohoSyncAt: p.lastZohoSyncAt,
      };
    }

    return ApiResponse.success(res, 'Product details retrieved', result);
  } catch (error) {
    next(error);
  }
};

/**
 * Get Product Categories
 */
exports.getCategories = async (req, res, next) => {
  try {
    const categories = await Category.find({ isActive: true });
    return ApiResponse.success(res, 'Categories retrieved successfully', categories);
  } catch (error) {
    next(error);
  }
};

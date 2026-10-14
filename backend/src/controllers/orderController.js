const Order = require('../models/Order');
const Product = require('../models/Product');
const User = require('../models/User');
const ApiResponse = require('../utils/apiResponse');
const { ROLES, PAYMENT_METHODS, PAYMENT_STATUSES, ORDER_STATUSES } = require('../utils/constants');

/**
 * Place Order (Customer or Dealer)
 */
exports.createOrder = async (req, res, next) => {
  try {
    const { items, paymentMethod = PAYMENT_METHODS.UPFRONT, shippingAddress } = req.body;
    const user = req.user;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return ApiResponse.error(res, 'Order items are required', 400);
    }

    const isDealer = user.role === ROLES.DEALER;

    // Validate Payment Options based on Role
    if (!isDealer && paymentMethod !== PAYMENT_METHODS.UPFRONT) {
      return ApiResponse.error(
        res,
        'Direct Upfront payment is required for customers. Credit is reserved for verified dealers.',
        400
      );
    }

    // Dealer Credit Eligibility Checks
    let creditDueDate = null;
    let creditDays = 0;
    let paymentStatus = PAYMENT_STATUSES.PAID; // Default for Upfront

    if (isDealer) {
      if (paymentMethod === PAYMENT_METHODS.CREDIT_30) {
        if (!user.credit30Allowed) {
          return ApiResponse.error(
            res,
            '30-day credit is not activated for your dealer account. Contact Admin for credit verification.',
            403
          );
        }
        creditDays = 30;
        creditDueDate = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
        paymentStatus = PAYMENT_STATUSES.CREDIT_APPROVED;
      } else if (paymentMethod === PAYMENT_METHODS.CREDIT_90) {
        // Core Requirement: "Credit Payment – 90 Days (only for selected/approved dealers)"
        if (!user.credit90Allowed) {
          return ApiResponse.error(
            res,
            '90-Day Credit Denied: This credit facility is strictly restricted to approved Tier-1 dealers.',
            403
          );
        }
        creditDays = 90;
        creditDueDate = new Date(Date.now() + 90 * 24 * 60 * 60 * 1000);
        paymentStatus = PAYMENT_STATUSES.CREDIT_APPROVED;
      }
    }

    // Validate Items, calculate totals and check stock
    let totalAmount = 0;
    const orderItems = [];

    for (const item of items) {
      const product = await Product.findById(item.productId);
      if (!product || !product.isActive) {
        return ApiResponse.error(res, `Product ${item.name || item.productId} is no longer available`, 400);
      }

      if (product.stockQuantity < item.quantity) {
        return ApiResponse.error(
          res,
          `Insufficient stock for "${product.name}". Requested: ${item.quantity}, Available: ${product.stockQuantity}`,
          400
        );
      }

      const unitPrice = isDealer ? (product.dealerPrice || product.price) : product.price;
      const subtotal = unitPrice * item.quantity;
      totalAmount += subtotal;

      orderItems.push({
        productId: product._id,
        name: product.name,
        sku: product.sku,
        unitPrice,
        quantity: item.quantity,
        subtotal,
      });

      // Deduct inventory
      product.stockQuantity -= item.quantity;
      await product.save();
    }

    // Validate Dealer Credit Limit
    if (isDealer && (paymentMethod === PAYMENT_METHODS.CREDIT_30 || paymentMethod === PAYMENT_METHODS.CREDIT_90)) {
      const availableCredit = (user.creditLimit || 0) - (user.creditUsed || 0);
      if (totalAmount > availableCredit) {
        return ApiResponse.error(
          res,
          `Credit limit exceeded. Available credit: ₹${availableCredit}, Order total: ₹${totalAmount}`,
          400
        );
      }

      // Update dealer credit used
      user.creditUsed = (user.creditUsed || 0) + totalAmount;
      await user.save();
    }

    const orderNumber = `ORD-${Date.now().toString().slice(-6)}-${Math.floor(100 + Math.random() * 900)}`;

    const newOrder = await Order.create({
      orderNumber,
      user: user._id,
      customerMobile: user.mobileNumber,
      role: user.role,
      items: orderItems,
      totalAmount,
      taxAmount: Math.round(totalAmount * 0.18),
      netPayable: Math.round(totalAmount * 1.18),
      paymentMethod,
      paymentStatus,
      creditDueDate,
      creditDays,
      orderStatus: ORDER_STATUSES.CONFIRMED,
      shippingAddress: shippingAddress || user.address || { street: 'Main Road', city: 'Mumbai', state: 'MH', zip: '400001' },
      trackingUpdates: [
        {
          status: 'ORDER_PLACED',
          note: `Order ${orderNumber} placed successfully via ${paymentMethod.toUpperCase()}`,
          timestamp: new Date(),
        },
        {
          status: 'PAYMENT_VERIFIED',
          note: paymentMethod === PAYMENT_METHODS.UPFRONT ? 'Direct online payment successful' : `Approved under ${creditDays}-Day Dealer Credit terms`,
          timestamp: new Date(),
        },
      ],
    });

    return ApiResponse.success(res, 'Order placed successfully', newOrder, 201);
  } catch (error) {
    next(error);
  }
};

/**
 * Get My Orders List
 */
exports.getMyOrders = async (req, res, next) => {
  try {
    const orders = await Order.find({ user: req.user._id }).sort({ createdAt: -1 });
    return ApiResponse.success(res, 'Orders fetched successfully', orders);
  } catch (error) {
    next(error);
  }
};

/**
 * Get Order Details & Tracking Timeline
 */
exports.getOrderTracking = async (req, res, next) => {
  try {
    const { orderId } = req.params;
    const order = await Order.findOne({
      $or: [{ _id: orderId }, { orderNumber: orderId }],
      user: req.user._id,
    });

    if (!order) {
      return ApiResponse.error(res, 'Order not found', 404);
    }

    // Dynamic timeline stages for tracking
    const stages = [
      { key: 'placed', label: 'Order Placed', completed: true, timestamp: order.createdAt },
      { key: 'confirmed', label: 'Confirmed & Packed', completed: true, timestamp: order.createdAt },
      { key: 'dispatched', label: 'Dispatched from Warehouse', completed: ['dispatched', 'out_for_delivery', 'delivered'].includes(order.orderStatus), timestamp: null },
      { key: 'out_for_delivery', label: 'Out for Delivery', completed: ['out_for_delivery', 'delivered'].includes(order.orderStatus), timestamp: null },
      { key: 'delivered', label: 'Delivered', completed: order.orderStatus === 'delivered', timestamp: null },
    ];

    return ApiResponse.success(res, 'Order tracking details', {
      orderNumber: order.orderNumber,
      orderStatus: order.orderStatus,
      paymentMethod: order.paymentMethod,
      paymentStatus: order.paymentStatus,
      netPayable: order.netPayable,
      creditDueDate: order.creditDueDate,
      shippingAddress: order.shippingAddress,
      items: order.items,
      stages,
      trackingUpdates: order.trackingUpdates,
    });
  } catch (error) {
    next(error);
  }
};

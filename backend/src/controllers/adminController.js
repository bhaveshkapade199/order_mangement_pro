const User = require('../models/User');
const Product = require('../models/Product');
const Order = require('../models/Order');
const ZohoService = require('../services/zohoService');
const ApiResponse = require('../utils/apiResponse');
const { ROLES, PAYMENT_METHODS } = require('../utils/constants');


exports.getUsers = async (req, res, next) => {
  try {
    const { role, search } = req.query;
    const filter = {};

    if (role && role !== 'all') {
      filter.role = role;
    }

    if (search) {
      filter.$or = [
        { name: new RegExp(search, 'i') },
        { mobileNumber: new RegExp(search, 'i') },
      ];
    }

    const users = await User.find(filter).select('-otpCode -otpExpiresAt').sort({ createdAt: -1 });
    return ApiResponse.success(res, 'Users retrieved successfully', users);
  } catch (error) {
    next(error);
  }
};


exports.updateDealerCredit = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const { creditLimit, credit30Allowed, credit90Allowed } = req.body;

    const dealer = await User.findOne({ _id: userId, role: ROLES.DEALER });

    if (!dealer) {
      return ApiResponse.error(res, 'Dealer account not found', 404);
    }

    if (typeof creditLimit === 'number') dealer.creditLimit = creditLimit;
    if (typeof credit30Allowed === 'boolean') dealer.credit30Allowed = credit30Allowed;
    if (typeof credit90Allowed === 'boolean') dealer.credit90Allowed = credit90Allowed;

    await dealer.save();

    return ApiResponse.success(res, `Credit permissions updated for dealer ${dealer.name}`, {
      id: dealer._id,
      name: dealer.name,
      creditLimit: dealer.creditLimit,
      creditUsed: dealer.creditUsed,
      availableCredit: dealer.creditLimit - dealer.creditUsed,
      credit30Allowed: dealer.credit30Allowed,
      credit90Allowed: dealer.credit90Allowed,
    });
  } catch (error) {
    next(error);
  }
};


exports.updatePlumberVerification = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const { verificationStatus, plumberCertificationNo } = req.body;

    const plumber = await User.findOne({ _id: userId, role: ROLES.PLUMBER });
    if (!plumber) {
      return ApiResponse.error(res, 'Plumber not found', 404);
    }

    if (verificationStatus) plumber.plumberVerificationStatus = verificationStatus;
    if (plumberCertificationNo) plumber.plumberCertificationNo = plumberCertificationNo;

    await plumber.save();

    return ApiResponse.success(res, 'Plumber status updated', plumber);
  } catch (error) {
    next(error);
  }
};


exports.getAllOrders = async (req, res, next) => {
  try {
    const { status, role } = req.query;
    const filter = {};

    if (status && status !== 'all') filter.orderStatus = status;
    if (role && role !== 'all') filter.role = role;

    const orders = await Order.find(filter).populate('user', 'name mobileNumber role').sort({ createdAt: -1 });
    return ApiResponse.success(res, 'Orders list retrieved', orders);
  } catch (error) {
    next(error);
  }
};


exports.updateOrderStatus = async (req, res, next) => {
  try {
    const { orderId } = req.params;
    const { orderStatus, trackingNote } = req.body;

    const order = await Order.findById(orderId);
    if (!order) {
      return ApiResponse.error(res, 'Order not found', 404);
    }

    if (orderStatus) {
      order.orderStatus = orderStatus;
      order.trackingUpdates.push({
        status: orderStatus.toUpperCase(),
        note: trackingNote || `Status transitioned to ${orderStatus}`,
        timestamp: new Date(),
      });
    }

    await order.save();
    return ApiResponse.success(res, 'Order updated successfully', order);
  } catch (error) {
    next(error);
  }
};


exports.getReports = async (req, res, next) => {
  try {
    const [customerCount, dealerCount, plumberCount, orders] = await Promise.all([
      User.countDocuments({ role: ROLES.CUSTOMER }),
      User.countDocuments({ role: ROLES.DEALER }),
      User.countDocuments({ role: ROLES.PLUMBER }),
      Order.find(),
    ]);

    let totalRevenue = 0;
    let totalCredit30Amount = 0;
    let totalCredit90Amount = 0;
    let upfrontPaymentAmount = 0;

    orders.forEach((ord) => {
      totalRevenue += ord.netPayable || ord.totalAmount;
      if (ord.paymentMethod === PAYMENT_METHODS.CREDIT_30) {
        totalCredit30Amount += ord.netPayable;
      } else if (ord.paymentMethod === PAYMENT_METHODS.CREDIT_90) {
        totalCredit90Amount += ord.netPayable;
      } else {
        upfrontPaymentAmount += ord.netPayable;
      }
    });

    const activeProductsCount = await Product.countDocuments({ isActive: true });

    return ApiResponse.success(res, 'Executive reports generated', {
      userMetrics: {
        totalCustomers: customerCount,
        totalDealers: dealerCount,
        totalPlumbers: plumberCount,
        totalUsers: customerCount + dealerCount + plumberCount,
      },
      salesMetrics: {
        totalOrdersCount: orders.length,
        totalGrossRevenue: totalRevenue,
        upfrontCashCollected: upfrontPaymentAmount,
        credit30DaysExposure: totalCredit30Amount,
        credit90DaysExposure: totalCredit90Amount,
        totalCreditOutstanding: totalCredit30Amount + totalCredit90Amount,
      },
      inventoryMetrics: {
        activeCatalogItems: activeProductsCount,
        inventorySyncSource: 'Zoho Workbook',
      },
    });
  } catch (error) {
    next(error);
  }
};


exports.triggerZohoSync = async (req, res, next) => {
  try {
    const syncResult = await ZohoService.syncWorkbookProducts();
    return ApiResponse.success(res, 'Zoho Workbook inventory synchronization completed', syncResult);
  } catch (error) {
    next(error);
  }
};

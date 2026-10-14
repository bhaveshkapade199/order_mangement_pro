const mongoose = require('mongoose');
const { PAYMENT_METHODS, PAYMENT_STATUSES, ORDER_STATUSES } = require('../utils/constants');

const orderItemSchema = new mongoose.Schema({
  productId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true,
  },
  name: { type: String, required: true },
  sku: { type: String, required: true },
  unitPrice: { type: Number, required: true },
  quantity: { type: Number, required: true, min: 1 },
  subtotal: { type: Number, required: true },
});

const orderSchema = new mongoose.Schema(
  {
    orderNumber: {
      type: String,
      required: true,
      unique: true,
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    customerMobile: {
      type: String,
      required: true,
    },
    role: {
      type: String,
      enum: ['customer', 'dealer'],
      required: true,
    },
    items: [orderItemSchema],
    totalAmount: {
      type: Number,
      required: true,
      min: 0,
    },
    taxAmount: {
      type: Number,
      default: 0,
    },
    discountAmount: {
      type: Number,
      default: 0,
    },
    netPayable: {
      type: Number,
      required: true,
      min: 0,
    },
    // Payment configuration
    paymentMethod: {
      type: String,
      enum: Object.values(PAYMENT_METHODS),
      required: true,
    },
    paymentStatus: {
      type: String,
      enum: Object.values(PAYMENT_STATUSES),
      default: PAYMENT_STATUSES.PENDING,
    },
    creditDueDate: {
      type: Date,
      default: null,
    },
    creditDays: {
      type: Number,
      default: 0, // 0 for upfront, 30 or 90 for dealer credit
    },
    orderStatus: {
      type: String,
      enum: Object.values(ORDER_STATUSES),
      default: ORDER_STATUSES.PLACED,
    },
    shippingAddress: {
      street: String,
      city: String,
      state: String,
      zip: String,
    },
    trackingUpdates: [
      {
        status: String,
        note: String,
        timestamp: { type: Date, default: Date.now },
      },
    ],
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Order', orderSchema);

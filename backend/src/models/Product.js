const mongoose = require('mongoose');

/**
 * Product Schema
 * Synchronized with Zoho Workbook
 */
const productSchema = new mongoose.Schema(
  {
    zohoItemId: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    sku: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    category: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      default: '',
    },
    price: {
      type: Number,
      required: true,
      min: 0,
    },
    dealerPrice: {
      type: Number,
      default: 0,
    },
    // Stock quantity is visible ONLY to dealers and admins
    stockQuantity: {
      type: Number,
      required: true,
      default: 0,
    },
    unit: {
      type: String,
      default: 'pcs',
    },
    imageUrl: {
      type: String,
      default: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    },
    specifications: {
      material: { type: String, default: 'Brass / PVC' },
      size: { type: String, default: '1/2 inch' },
      warrantyYears: { type: Number, default: 5 },
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    lastZohoSyncAt: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Product', productSchema);

const mongoose = require('mongoose');

const zohoSyncLogSchema = new mongoose.Schema(
  {
    syncId: {
      type: String,
      required: true,
      unique: true,
    },
    syncType: {
      type: String,
      enum: ['manual', 'scheduled', 'webhook'],
      default: 'manual',
    },
    source: {
      type: String,
      default: 'Zoho Workbook - Product_Inventory_Master',
    },
    productsUpdated: {
      type: Number,
      default: 0,
    },
    productsCreated: {
      type: Number,
      default: 0,
    },
    status: {
      type: String,
      enum: ['success', 'failed', 'partial'],
      default: 'success',
    },
    rawResponse: {
      type: Object,
      default: {},
    },
    syncedAt: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('ZohoSyncLog', zohoSyncLogSchema);

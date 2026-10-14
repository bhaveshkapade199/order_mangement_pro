const mongoose = require('mongoose');
const { TASK_STATUSES } = require('../utils/constants');

const plumberTaskSchema = new mongoose.Schema(
  {
    taskNumber: {
      type: String,
      required: true,
      unique: true,
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      default: '',
    },
    plumber: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    customerName: {
      type: String,
      required: true,
    },
    customerMobile: {
      type: String,
      required: true,
    },
    serviceAddress: {
      street: String,
      city: String,
      pincode: String,
    },
    status: {
      type: String,
      enum: Object.values(TASK_STATUSES),
      default: TASK_STATUSES.ASSIGNED,
    },
    scheduledDate: {
      type: Date,
      default: Date.now,
    },
    completionNotes: {
      type: String,
      default: '',
    },
    sparePartsUsed: [
      {
        partName: String,
        quantity: Number,
      },
    ],
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('PlumberTask', plumberTaskSchema);

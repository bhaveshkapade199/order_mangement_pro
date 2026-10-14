const mongoose = require('mongoose');
const { ROLES } = require('../utils/constants');

/**
 * User Schema
 * Handles Customers, Dealers, Plumbers, and Admin roles
 */
const userSchema = new mongoose.Schema(
  {
    mobileNumber: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    role: {
      type: String,
      enum: Object.values(ROLES),
      default: ROLES.CUSTOMER,
      required: true,
    },
    name: {
      type: String,
      trim: true,
      default: 'Guest User',
    },
    email: {
      type: String,
      trim: true,
      lowercase: true,
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    // Zoho CRM Integration Fields for Dealers
    zohoContactId: {
      type: String,
      default: null,
    },
    zohoVerified: {
      type: Boolean,
      default: false,
    },
    // Dealer Credit Privileges
    creditLimit: {
      type: Number,
      default: 0,
    },
    creditUsed: {
      type: Number,
      default: 0,
    },
    credit30Allowed: {
      type: Boolean,
      default: false,
    },
    credit90Allowed: {
      type: Boolean,
      default: false,
    },
    // Plumber Verification & Profile Fields
    plumberCertificationNo: {
      type: String,
      default: null,
    },
    plumberVerificationStatus: {
      type: String,
      enum: ['pending', 'verified', 'rejected'],
      default: 'pending',
    },
    plumberSkills: {
      type: [String],
      default: ['Pipe Fitting', 'Sanitary Installation', 'Leak Repair'],
    },
    plumberRating: {
      type: Number,
      default: 4.8,
    },
    isAvailable: {
      type: Boolean,
      default: true,
    },
    // Common profile address
    address: {
      street: { type: String, default: '123 Industrial Area' },
      city: { type: String, default: 'Mumbai' },
      state: { type: String, default: 'Maharashtra' },
      zip: { type: String, default: '400001' },
    },
    // Transient OTP fields
    otpCode: {
      type: String,
      default: null,
    },
    otpExpiresAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('User', userSchema);

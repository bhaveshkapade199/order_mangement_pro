const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/User');
const ApiResponse = require('../utils/apiResponse');

/**
 * JWT Authentication Middleware
 */
const protect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  }

  if (!token) {
    return ApiResponse.error(res, 'Authentication token missing or invalid. Please log in.', 401);
  }

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET);
    const user = await User.findById(decoded.id).select('-otpCode -otpExpiresAt');

    if (!user) {
      return ApiResponse.error(res, 'User associated with this token no longer exists.', 401);
    }

    req.user = user;
    next();
  } catch (error) {
    return ApiResponse.error(res, 'Invalid or expired session token. Please re-authenticate.', 401);
  }
};

/**
 * Optional Auth Middleware
 * If token is present, populates req.user; otherwise proceeds as guest/customer.
 */
const optionalAuth = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  }

  if (!token) {
    req.user = null;
    return next();
  }

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET);
    req.user = await User.findById(decoded.id).select('-otpCode -otpExpiresAt');
  } catch {
    req.user = null;
  }

  next();
};

module.exports = {
  protect,
  optionalAuth,
};

const ApiResponse = require('../utils/apiResponse');

/**
 * Role-Based Access Control (RBAC) Middleware
 * @param  {...string} roles Allowed roles ('customer', 'dealer', 'plumber', 'admin')
 */
const restrictTo = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return ApiResponse.error(res, 'User not authenticated', 401);
    }

    if (!roles.includes(req.user.role)) {
      return ApiResponse.error(
        res,
        `Access denied. Role '${req.user.role}' is not authorized to access this resource. Requires: ${roles.join(', ')}`,
        403
      );
    }

    next();
  };
};

module.exports = { restrictTo };

const ApiResponse = require('../utils/apiResponse');

const errorHandler = (err, req, res, next) => {
  console.error('[Unhandled Server Error]:', err);

  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  return ApiResponse.error(res, message, statusCode, {
    stack: process.env.NODE_ENV === 'production' ? undefined : err.stack,
  });
};


const notFoundHandler = (req, res, next) => {
  return ApiResponse.error(res, `Endpoint not found - ${req.originalUrl}`, 404);
};

module.exports = {
  errorHandler,
  notFoundHandler,
};

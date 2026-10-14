// Backend Environment Configuration
module.exports = {
  PORT: process.env.PORT || 5000,
  MONGODB_URI: process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/multirole_commerce_db',
  JWT_SECRET: process.env.JWT_SECRET || 'antigravity_super_secret_jwt_key_2026',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '30d',
  ZOHO: {
    CLIENT_ID: process.env.ZOHO_CLIENT_ID || 'mock_zoho_client_id',
    CLIENT_SECRET: process.env.ZOHO_CLIENT_SECRET || 'mock_zoho_secret',
    ORG_ID: process.env.ZOHO_ORG_ID || 'mock_org_1001',
    WORKBOOK_NAME: 'Product_Inventory_Master',
    AUTH_URL: 'https://accounts.zoho.com/oauth/v2/token',
    API_BASE_URL: 'https://www.zohoapis.com/sheet/v1'
  },
  DEFAULT_OTP: '123456' // Fallback OTP for interview/testing purposes
};

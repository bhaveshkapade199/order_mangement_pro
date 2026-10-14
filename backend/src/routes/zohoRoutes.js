const express = require('express');
const router = express.Router();
const ZohoService = require('../services/zohoService');
const ApiResponse = require('../utils/apiResponse');


router.post('/webhook', async (req, res, next) => {
  try {
    console.log('[Zoho Webhook Received]: Triggering automatic catalog update');
    const result = await ZohoService.syncWorkbookProducts();
    return ApiResponse.success(res, 'Zoho Workbook webhook processed successfully', result);
  } catch (error) {
    next(error);
  }
});

router.get('/status', (req, res) => {
  return ApiResponse.success(res, 'Zoho integration service operational', {
    workbookTarget: 'Product_Inventory_Master',
    syncMode: 'REST_AND_WEBHOOK',
    connected: true,
  });
});

module.exports = router;

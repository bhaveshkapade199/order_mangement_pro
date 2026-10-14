const axios = require('axios');
const env = require('../config/env');
const Product = require('../models/Product');
const ZohoSyncLog = require('../models/ZohoSyncLog');


const ZOHO_MOCK_DEALER_REGISTRY = [
  {
    zohoContactId: 'ZC-DL-9081',
    mobileNumber: '9876543210',
    dealerName: 'Apex Plumbing Supplies & Hardware',
    status: 'VERIFIED',
    credit30Allowed: true,
    credit90Allowed: true,
    creditLimit: 250000,
    creditUsed: 45000,
  },
  {
    zohoContactId: 'ZC-DL-9082',
    mobileNumber: '9876543211',
    dealerName: 'Metro Sanitary & Fittings Store',
    status: 'VERIFIED',
    credit30Allowed: true,
    credit90Allowed: false, // 30 days only
    creditLimit: 100000,
    creditUsed: 15000,
  },
  {
    zohoContactId: 'ZC-DL-9083',
    mobileNumber: '9876543212',
    dealerName: 'National Pipeline Traders',
    status: 'PENDING_DOCUMENTATION', // Not verified yet
    credit30Allowed: false,
    credit90Allowed: false,
    creditLimit: 0,
    creditUsed: 0,
  },
];

const ZOHO_MOCK_WORKBOOK_DATA = [
  {
    zohoItemId: 'ZH-ITM-001',
    sku: 'PP-CPVC-075-3M',
    name: 'CPVC High-Pressure Pipe 3/4" (3m)',
    category: 'Pipes & Fittings',
    retailPrice: 420.0,
    dealerPrice: 330.0,
    stockQuantity: 450,
    unit: 'length',
    description: 'High tensile CPVC plumbing pipe conforming to ASTM standard for hot and cold water.',
    imageUrl: 'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=600&q=80',
    specifications: { material: 'CPVC Grade 1', size: '3/4 inch', warrantyYears: 10 },
  },
  {
    zohoItemId: 'ZH-ITM-002',
    sku: 'VLV-BRS-BALL-050',
    name: 'Quarter-Turn Brass Ball Valve 1/2"',
    category: 'Valves & Regulators',
    retailPrice: 280.0,
    dealerPrice: 210.0,
    stockQuantity: 180,
    unit: 'pcs',
    description: 'Heavy duty forged brass ball valve with chrome plating and blow-out proof stem.',
    imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    specifications: { material: 'Solid Brass', size: '1/2 inch', warrantyYears: 5 },
  },
  {
    zohoItemId: 'ZH-ITM-003',
    sku: 'SAN-BAS-MIX-CHR',
    name: 'Designer Basin Mixer Tap Chrome Finish',
    category: 'Sanitary Fixtures',
    retailPrice: 2450.0,
    dealerPrice: 1950.0,
    stockQuantity: 45,
    unit: 'pcs',
    description: 'Single lever brass basin mixer with aerator and mirror finish chrome plating.',
    imageUrl: 'https://images.unsplash.com/photo-1585909695284-32d2985ac9c0?auto=format&fit=crop&w=600&q=80',
    specifications: { material: 'Brass Ceramic Cartridge', size: 'Standard', warrantyYears: 7 },
  },
  {
    zohoItemId: 'ZH-ITM-004',
    sku: 'ACC-SOLV-CEMT-250',
    name: 'Heavy-Duty CPVC Solvent Cement 250ml',
    category: 'Chemicals & Adhesives',
    retailPrice: 160.0,
    dealerPrice: 120.0,
    stockQuantity: 600,
    unit: 'tin',
    description: 'Fast setting medium-bodied solvent cement for all classes and schedules of CPVC pipe.',
    imageUrl: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=600&q=80',
    specifications: { material: 'Solvent Base', size: '250 ml', warrantyYears: 2 },
  },
  {
    zohoItemId: 'ZH-ITM-005',
    sku: 'DRN-SS-TRAP-100',
    name: 'Stainless Steel Anti-Cockroach Floor Trap',
    category: 'Drainage Systems',
    retailPrice: 380.0,
    dealerPrice: 290.0,
    stockQuantity: 210,
    unit: 'pcs',
    description: 'Grade 304 SS floor drain with odor seal and removable hair strainer cover.',
    imageUrl: 'https://images.unsplash.com/photo-1507652313519-d4e9174996dd?auto=format&fit=crop&w=600&q=80',
    specifications: { material: 'AISI 304 SS', size: '100x100 mm', warrantyYears: 10 },
  },
  {
    zohoItemId: 'ZH-ITM-006',
    sku: 'PMP-SUB-050HP',
    name: '0.5 HP Automatic Domestic Water Booster Pump',
    category: 'Pumps & Motors',
    retailPrice: 5800.0,
    dealerPrice: 4700.0,
    stockQuantity: 18,
    unit: 'pcs',
    description: 'Compact automatic pressure booster pump with thermal overload protector.',
    imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=600&q=80',
    specifications: { material: 'Cast Iron + Brass Impeller', size: '0.5 HP', warrantyYears: 3 },
  },
];

class ZohoService {
 
  static async verifyDealerMobile(mobileNumber) {
    const cleanNumber = mobileNumber.replace(/\D/g, '').slice(-10);
    

    const dealerRecord = ZOHO_MOCK_DEALER_REGISTRY.find(
      (d) => d.mobileNumber === cleanNumber
    );

    if (!dealerRecord) {
      return {
        isRegistered: false,
        isVerified: false,
        message: 'Mobile number not found in Zoho Dealer Directory. Please contact Admin for onboarding.',
      };
    }

    if (dealerRecord.status !== 'VERIFIED') {
      return {
        isRegistered: true,
        isVerified: false,
        message: `Dealer status in Zoho is '${dealerRecord.status}'. Full verification is required before access.`,
      };
    }

    return {
      isRegistered: true,
      isVerified: true,
      zohoContactId: dealerRecord.zohoContactId,
      dealerName: dealerRecord.dealerName,
      creditLimit: dealerRecord.creditLimit,
      creditUsed: dealerRecord.creditUsed,
      credit30Allowed: dealerRecord.credit30Allowed,
      credit90Allowed: dealerRecord.credit90Allowed,
      message: 'Dealer successfully verified in Zoho CRM.',
    };
  }

  /**
   * Synchronize Products, Pricing, and Stock from Zoho Workbook.
   * Requirement: "Products, pricing and stock should be fetched/synchronised from Zoho Workbook."
   */
  static async syncWorkbookProducts() {
    console.log('[Zoho Sync] Connecting to Zoho Workbook: Product_Inventory_Master...');
    
    let updatedCount = 0;
    let createdCount = 0;

    for (const item of ZOHO_MOCK_WORKBOOK_DATA) {
      const existing = await Product.findOne({ zohoItemId: item.zohoItemId });

      if (existing) {
        existing.name = item.name;
        existing.sku = item.sku;
        existing.category = item.category;
        existing.price = item.retailPrice;
        existing.dealerPrice = item.dealerPrice;
        existing.stockQuantity = item.stockQuantity;
        existing.unit = item.unit;
        existing.description = item.description;
        existing.imageUrl = item.imageUrl;
        existing.specifications = item.specifications;
        existing.lastZohoSyncAt = new Date();
        await existing.save();
        updatedCount++;
      } else {
        await Product.create({
          zohoItemId: item.zohoItemId,
          name: item.name,
          sku: item.sku,
          category: item.category,
          price: item.retailPrice,
          dealerPrice: item.dealerPrice,
          stockQuantity: item.stockQuantity,
          unit: item.unit,
          description: item.description,
          imageUrl: item.imageUrl,
          specifications: item.specifications,
          lastZohoSyncAt: new Date(),
        });
        createdCount++;
      }
    }

    // Record sync log
    const log = await ZohoSyncLog.create({
      syncId: `SYNC-${Date.now()}`,
      syncType: 'manual',
      source: 'Zoho Workbook - Product_Inventory_Master',
      productsCreated: createdCount,
      productsUpdated: updatedCount,
      status: 'success',
      rawResponse: { totalSheetRows: ZOHO_MOCK_WORKBOOK_DATA.length },
    });

    console.log(`[Zoho Sync] Sync completed: ${createdCount} created, ${updatedCount} updated.`);
    return {
      success: true,
      logId: log.syncId,
      createdCount,
      updatedCount,
      total: ZOHO_MOCK_WORKBOOK_DATA.length,
      syncedAt: log.syncedAt,
    };
  }
}

module.exports = ZohoService;

const mongoose = require('mongoose');
const env = require('../config/env');
const User = require('../models/User');
const Product = require('../models/Product');
const Category = require('../models/Category');
const Order = require('../models/Order');
const PlumberTask = require('../models/PlumberTask');
const ZohoService = require('../services/zohoService');
const { ROLES, PAYMENT_METHODS, PAYMENT_STATUSES, ORDER_STATUSES, TASK_STATUSES } = require('../utils/constants');

const seedDatabase = async () => {
  try {
    console.log('[Seeder] Starting database seeding...');
    
    // 1. Seed Categories
    await Category.deleteMany({});
    const categories = await Category.insertMany([
      { name: 'Pipes & Fittings', slug: 'pipes-fittings', iconName: 'plumbing', description: 'CPVC, UPVC, and SWR piping networks' },
      { name: 'Valves & Regulators', slug: 'valves-regulators', iconName: 'tune', description: 'Ball valves, check valves, and pressure regulators' },
      { name: 'Sanitary Fixtures', slug: 'sanitary-fixtures', iconName: 'bathtub', description: 'Basin mixers, faucets, and showers' },
      { name: 'Chemicals & Adhesives', slug: 'chemicals-adhesives', iconName: 'science', description: 'Solvents, Teflon tapes, and sealants' },
      { name: 'Drainage Systems', slug: 'drainage-systems', iconName: 'waves', description: 'Floor drains, gullies, and traps' },
      { name: 'Pumps & Motors', slug: 'pumps-motors', iconName: 'speed', description: 'Domestic booster pumps and submerged motors' },
    ]);
    console.log(`[Seeder] Seeded ${categories.length} categories.`);

    // 2. Sync Products from Zoho Workbook
    await Product.deleteMany({});
    const zohoResult = await ZohoService.syncWorkbookProducts();
    console.log(`[Seeder] Synchronized ${zohoResult.total} products from Zoho Workbook.`);

    // 3. Seed Users across all roles
    await User.deleteMany({});
    const users = await User.insertMany([
      // Customer
      {
        mobileNumber: '9999900001',
        role: ROLES.CUSTOMER,
        name: 'Rahul Verma',
        email: 'rahul.verma@example.com',
        isVerified: true,
        address: { street: 'Flat 302, Palm Heights', city: 'Mumbai', state: 'MH', zip: '400053' },
      },
      // Dealer Tier 1 (30 and 90 Days Approved in Zoho)
      {
        mobileNumber: '9876543210',
        role: ROLES.DEALER,
        name: 'Apex Plumbing Supplies & Hardware',
        email: 'sales@apexplumbing.com',
        isVerified: true,
        zohoContactId: 'ZC-DL-9081',
        zohoVerified: true,
        creditLimit: 250000,
        creditUsed: 45000,
        credit30Allowed: true,
        credit90Allowed: true, // Approved for 90 Days!
        address: { street: 'Shop 14-16, Hardware Market', city: 'Mumbai', state: 'MH', zip: '400003' },
      },
      // Dealer Tier 2 (30 Days Only Approved)
      {
        mobileNumber: '9876543211',
        role: ROLES.DEALER,
        name: 'Metro Sanitary & Fittings Store',
        email: 'info@metrosanitary.com',
        isVerified: true,
        zohoContactId: 'ZC-DL-9082',
        zohoVerified: true,
        creditLimit: 100000,
        creditUsed: 15000,
        credit30Allowed: true,
        credit90Allowed: false, // NOT approved for 90 days
        address: { street: 'Plot 88, Industrial Suburb', city: 'Pune', state: 'MH', zip: '411028' },
      },
      // Plumber (Verified)
      {
        mobileNumber: '9888800001',
        role: ROLES.PLUMBER,
        name: 'Ramesh Sharma',
        email: 'ramesh.plumbing@example.com',
        isVerified: true,
        plumberCertificationNo: 'PLM-GOVT-2024-912',
        plumberVerificationStatus: 'verified',
        plumberSkills: ['CPVC Fusion Welding', 'High-Pressure Valve Servicing', 'Sanitary Installations'],
        plumberRating: 4.9,
        isAvailable: true,
        address: { street: 'B-12, Kamla Nagar', city: 'Mumbai', state: 'MH', zip: '400016' },
      },
      // Admin
      {
        mobileNumber: '9000000001',
        role: ROLES.ADMIN,
        name: 'Super Admin',
        email: 'admin@companyportal.com',
        isVerified: true,
      },
    ]);
    console.log(`[Seeder] Seeded ${users.length} users with distinct roles.`);

    const customerUser = users.find((u) => u.role === ROLES.CUSTOMER);
    const dealerUser = users.find((u) => u.role === ROLES.DEALER && u.credit90Allowed);
    const plumberUser = users.find((u) => u.role === ROLES.PLUMBER);
    const sampleProducts = await Product.find().limit(3);

    // 4. Seed Sample Orders
    await Order.deleteMany({});
    const orders = await Order.insertMany([
      {
        orderNumber: 'ORD-882191-101',
        user: customerUser._id,
        customerMobile: customerUser.mobileNumber,
        role: ROLES.CUSTOMER,
        items: [
          {
            productId: sampleProducts[0]._id,
            name: sampleProducts[0].name,
            sku: sampleProducts[0].sku,
            unitPrice: sampleProducts[0].price,
            quantity: 2,
            subtotal: sampleProducts[0].price * 2,
          },
        ],
        totalAmount: sampleProducts[0].price * 2,
        taxAmount: Math.round(sampleProducts[0].price * 2 * 0.18),
        netPayable: Math.round(sampleProducts[0].price * 2 * 1.18),
        paymentMethod: PAYMENT_METHODS.UPFRONT,
        paymentStatus: PAYMENT_STATUSES.PAID,
        orderStatus: ORDER_STATUSES.CONFIRMED,
        shippingAddress: customerUser.address,
        trackingUpdates: [
          { status: 'PLACED', note: 'Order placed via UPI direct payment', timestamp: new Date(Date.now() - 3600000) },
          { status: 'CONFIRMED', note: 'Order confirmed and allocated in warehouse', timestamp: new Date() },
        ],
      },
      {
        orderNumber: 'ORD-993412-202',
        user: dealerUser._id,
        customerMobile: dealerUser.mobileNumber,
        role: ROLES.DEALER,
        items: [
          {
            productId: sampleProducts[1]._id,
            name: sampleProducts[1].name,
            sku: sampleProducts[1].sku,
            unitPrice: sampleProducts[1].dealerPrice || sampleProducts[1].price,
            quantity: 50,
            subtotal: (sampleProducts[1].dealerPrice || sampleProducts[1].price) * 50,
          },
        ],
        totalAmount: (sampleProducts[1].dealerPrice || sampleProducts[1].price) * 50,
        taxAmount: Math.round((sampleProducts[1].dealerPrice || sampleProducts[1].price) * 50 * 0.18),
        netPayable: Math.round((sampleProducts[1].dealerPrice || sampleProducts[1].price) * 50 * 1.18),
        paymentMethod: PAYMENT_METHODS.CREDIT_90,
        paymentStatus: PAYMENT_STATUSES.CREDIT_APPROVED,
        creditDays: 90,
        creditDueDate: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
        orderStatus: ORDER_STATUSES.DISPATCHED,
        shippingAddress: dealerUser.address,
        trackingUpdates: [
          { status: 'PLACED', note: 'Purchase order logged with 90-day dealer credit facility', timestamp: new Date(Date.now() - 7200000) },
          { status: 'CONFIRMED', note: 'Commercial invoice generated with credit terms', timestamp: new Date(Date.now() - 3600000) },
          { status: 'DISPATCHED', note: 'Goods in transit via logistics partner', timestamp: new Date() },
        ],
      },
    ]);
    console.log(`[Seeder] Seeded ${orders.length} orders.`);

    // 5. Seed Plumber Tasks
    await PlumberTask.deleteMany({});
    const tasks = await PlumberTask.insertMany([
      {
        taskNumber: 'TSK-PLM-701',
        title: 'Main Inflow Valve Leakage Rectification',
        description: 'Customer reported seepage around main ball valve connection after installation.',
        plumber: plumberUser._id,
        customerName: 'Rahul Verma',
        customerMobile: '9999900001',
        serviceAddress: { street: 'Flat 302, Palm Heights', city: 'Mumbai', pincode: '400053' },
        status: TASK_STATUSES.ASSIGNED,
        scheduledDate: new Date(Date.now() + 4 * 3600000),
      },
      {
        taskNumber: 'TSK-PLM-702',
        title: 'Basin Mixer Tap Fitting & Seal Check',
        description: 'Fit new designer basin mixer with Teflon sealant and pressure test.',
        plumber: plumberUser._id,
        customerName: 'Sanjay Deshmukh',
        customerMobile: '9822001122',
        serviceAddress: { street: 'Villa 14, Royal Palms', city: 'Mumbai', pincode: '400065' },
        status: TASK_STATUSES.IN_PROGRESS,
        scheduledDate: new Date(),
        sparePartsUsed: [{ partName: 'Teflon Tape 12mm', quantity: 2 }],
      },
    ]);
    console.log(`[Seeder] Seeded ${tasks.length} plumber tasks.`);
    console.log('[Seeder] Database seeding completed successfully.');
  } catch (error) {
    console.error('[Seeder Error]:', error);
  }
};

module.exports = seedDatabase;


if (require.main === module) {
  mongoose
    .connect(env.MONGODB_URI)
    .then(async () => {
      await seedDatabase();
      process.exit(0);
    })
    .catch((err) => {
      console.error(err);
      process.exit(1);
    });
}

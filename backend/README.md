# Multi-Role Commerce Backend (Node.js + Express + MongoDB)

This backend supports a 3-user-role mobile ecosystem: **Customer**, **Dealer**, and **Plumber**, alongside an **Admin** management portal. It implements OTP authentication, Zoho CRM verification, Zoho Workbook inventory synchronization, role-based stock masking, and commercial credit workflows (30-day and 90-day terms).

---

## Folder Architecture

```
backend/
├── src/
│   ├── config/
│   │   ├── db.js                 # Resilient MongoDB connection
│   │   └── env.js                # Environment variables & Zoho configs
│   ├── controllers/
│   │   ├── authController.js     # OTP login/register, Zoho dealer verification
│   │   ├── productController.js  # Role-aware stock projection & catalog
│   │   ├── orderController.js    # Upfront & 30/90 day dealer credit orders
│   │   ├── plumberController.js  # Activities, job updates, spare parts catalog
│   │   ├── adminController.js    # Credit approval, plumber verification, reports
│   │   └── zohoController.js     # Zoho webhook & sync triggers
│   ├── middlewares/
│   │   ├── authMiddleware.js     # JWT Bearer token protection & optionalAuth
│   │   ├── roleMiddleware.js     # Role-based access control (RBAC)
│   │   └── errorMiddleware.js    # Centralized error & 404 handlers
│   ├── models/
│   │   ├── User.js               # Customers, Dealers, Plumbers, Admins
│   │   ├── Product.js            # Zoho Workbook catalog items & stock
│   │   ├── Category.js           # Product categories
│   │   ├── Order.js              # Orders, items, credit terms, tracking
│   │   ├── PlumberTask.js        # Service activities assigned to plumbers
│   │   └── ZohoSyncLog.js        # Sync audit trails
│   ├── routes/
│   │   ├── authRoutes.js
│   │   ├── productRoutes.js
│   │   ├── orderRoutes.js
│   │   ├── plumberRoutes.js
│   │   ├── adminRoutes.js
│   │   ├── zohoRoutes.js
│   │   └── index.js              # Aggregated API router (/api/...)
│   ├── seeds/
│   │   └── seedData.js           # Auto-seeder with pre-configured test users & products
│   ├── services/
│   │   ├── otpService.js         # Mobile OTP generation & verification
│   │   └── zohoService.js        # Zoho CRM contact check & Workbook sheet sync
│   ├── utils/
│   │   ├── apiResponse.js        # Standardized JSON response envelope
│   │   └── constants.js          # Roles, payment types, order states
│   └── server.js                 # Express bootstrap & auto-seeding
├── .env.example
├── package.json
└── README.md
```

---

## Seed Accounts for Interview Testing

Use any of these mobile numbers with OTP `123456`:

| Role | Mobile Number | Name | Key Permissions |
|------|---------------|------|-----------------|
| **Customer** | `9999900001` | Rahul Verma | Direct checkout, stock quantity hidden |
| **Dealer Tier 1** | `9876543210` | Apex Plumbing Supplies | Zoho Verified, ₹2,50,000 credit, **30-Day & 90-Day Credit Approved**, Stock quantity visible |
| **Dealer Tier 2** | `9876543211` | Metro Sanitary | Zoho Verified, ₹1,00,000 credit, **30-Day Credit Only** (90-Day Denied) |
| **Dealer Pending** | `9876543212` | National Pipeline Traders | **Rejected at OTP Login** (Not verified in Zoho) |
| **Plumber** | `9888800001` | Ramesh Sharma | Verified certification, assigned service tasks, spare catalog |
| **Admin** | `9000000001` | Super Admin | Manage credit limits, toggle 30/90 days credit, sync Zoho |

---

## Core API Endpoints

### 1. Authentication (`/api/auth`)
- `POST /api/auth/send-otp` - Send OTP (checks Zoho verification if role is dealer)
- `POST /api/auth/verify-otp` - Verify OTP, register/login, returns JWT token
- `GET /api/auth/profile` - Current user profile with credit/verification details

### 2. Products & Zoho Sync (`/api/products`)
- `GET /api/products` - List products. **Stock quantity is masked for customers, visible for dealers**.
- `GET /api/products/:id` - Detailed product view.
- `GET /api/products/categories` - Product categories list.

### 3. Orders & Checkout (`/api/orders`)
- `POST /api/orders` - Place order.
  - Customer: `paymentMethod: "upfront"`.
  - Dealer: `paymentMethod: "upfront" | "credit_30" | "credit_90"`.
- `GET /api/orders` - Order history.
- `GET /api/orders/tracking/:orderId` - Live timeline tracking.

### 4. Plumber Flow (`/api/plumber`)
- `GET /api/plumber/dashboard` - Metrics, assigned task counts, rating.
- `GET /api/plumber/tasks` - Assigned service activities.
- `PATCH /api/plumber/tasks/:taskId` - Update task status (`in_progress`, `completed`).
- `GET /api/plumber/products` - Plumbing supplies and fast-moving materials.
- `GET /api/plumber/notifications` - Service alerts.

### 5. Admin & Zoho Integration (`/api/admin` & `/api/zoho`)
- `GET /api/admin/users` - View customers, dealers, plumbers.
- `PATCH /api/admin/dealers/:userId/credit` - Update credit limit, toggle 30/90 days credit.
- `PATCH /api/admin/plumbers/:userId/verify` - Plumber verification status.
- `GET /api/admin/orders` - Manage all system orders.
- `GET /api/admin/reports` - Gross revenue, credit exposure (30 vs 90 days), user breakdown.
- `POST /api/admin/zoho-sync` - Trigger Zoho Workbook synchronization.
- `POST /api/zoho/webhook` - Webhook receiver for automatic Zoho inventory updates.

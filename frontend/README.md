# Multi-Role Commerce Mobile App (Flutter + BLoC + MVVM)

A high-performance enterprise Flutter mobile application implementing a **3-User-Role Dashboard architecture** (Customer, Dealer, Plumber) + **Admin Governance Portal** adhering strictly to **MVVM (Model-View-ViewModel)** and **BLoC (Business Logic Component)** state management.

---

## Architecture Overview (MVVM + BLoC)

```
       [ View / Screen (UI) ]
                 ▲
           events│  │states
                 ▼  ▼
  [ BLoC / ViewModel (Business Logic) ]
                 ▲
                 │ calls
                 ▼
       [ Repository Layer ]
                 ▲
                 │ REST / Storage
                 ▼
     [ ApiClient / Remote Data / Zoho ]
```

---

## Folder Architecture

```
frontend/lib/
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart    # Configurable backend routes
│   │   ├── app_colors.dart       # Role-specific palettes (Customer blue, Dealer purple, Plumber terracotta, Admin slate)
│   │   └── app_constants.dart    # Role definitions, payment terms, currency
│   ├── network/
│   │   └── api_client.dart       # Dio instance with JWT interceptor & error handling
│   ├── storage/
│   │   └── token_storage.dart    # SharedPreferences session persistence
│   └── theme/
│       └── app_theme.dart        # Unified Material 3 typography & styling
├── models/
│   ├── user_model.dart           # Roles, Zoho IDs, credit limits & 30/90 days flags
│   ├── product_model.dart        # Zoho workbook items with role-aware stock field
│   ├── category_model.dart       # Product categories
│   ├── order_model.dart          # Orders, items, credit terms, tracking stages
│   └── plumber_task_model.dart   # Service calls, customer details, status
├── repositories/
│   ├── auth_repository.dart      # OTP sending/verification, session management
│   ├── product_repository.dart   # Zoho synchronized catalog & categories
│   ├── order_repository.dart     # Upfront direct checkout & dealer credit POs
│   ├── plumber_repository.dart   # Activities, service status, spare requisitions
│   └── admin_repository.dart     # Credit eligibility, 30/90D permissions, Zoho sync
├── blocs/                        # ViewModels in MVVM pattern
│   ├── auth/                     # AuthBloc, AuthEvent, AuthState
│   ├── product/                  # ProductBloc, ProductEvent, ProductState
│   ├── cart/                     # CartBloc, CartEvent, CartState
│   ├── order/                    # OrderBloc, OrderEvent, OrderState
│   ├── plumber/                  # PlumberBloc, PlumberEvent, PlumberState
│   └── admin/                    # AdminBloc, AdminEvent, AdminState
├── views/
│   ├── widgets/
│   │   ├── primary_button.dart   # Consistent CTA button with loading states
│   │   ├── role_badge.dart       # Colored pill for Customer/Dealer/Plumber/Admin
│   │   └── stock_status_chip.dart# Role-aware: In-Stock vs Exact Warehouse Count
│   ├── auth/
│   │   ├── role_selection_view.dart # Role picker with pre-filled test numbers
│   │   ├── phone_login_view.dart    # OTP request (enforces Zoho check for dealers)
│   │   └── otp_verification_view.dart # 6-digit OTP verification with auto-routing
│   ├── customer/
│   │   ├── customer_main_shell.dart # 4-tab bottom navigation
│   │   ├── customer_home_view.dart  # Search, categories, products (stock masked)
│   │   ├── categories_view.dart     # Category listing
│   │   ├── product_details_view.dart# Specs, retail price, in-stock badge
│   │   ├── cart_view.dart           # Items, taxes, subtotal, stepper
│   │   ├── checkout_view.dart       # Delivery address, direct UPI/Card payment
│   │   ├── order_confirmation_view.dart # Success celebration & receipt
│   │   └── order_tracking_view.dart # Live 5-stage shipment timeline
│   ├── dealer/
│   │   ├── dealer_main_shell.dart   # Wholesale portal navigation
│   │   ├── dealer_home_view.dart    # Zoho verified stamp, credit line bar
│   │   ├── dealer_catalog_view.dart # Wholesale pricing & EXACT WAREHOUSE STOCK
│   │   ├── dealer_checkout_view.dart# Upfront, 30-Day Credit, 90-Day Credit terms
│   │   └── dealer_credit_status_view.dart # Exposure, limits, tier approval terms
│   ├── plumber/
│   │   ├── plumber_main_shell.dart  # Plumber workspace navigation
│   │   ├── plumber_dashboard_view.dart # Certified badge, monthly earnings, rating
│   │   ├── plumber_tasks_view.dart  # Service calls, status update stepper
│   │   ├── plumber_products_view.dart # Fast-moving CPVC supplies & valves
│   │   └── plumber_notifications_view.dart # Verification & assignment alerts
│   ├── admin/
│   │   ├── admin_main_shell.dart    # Admin governance navigation
│   │   ├── admin_reports_view.dart  # Revenue, cash vs 30D/90D credit exposure
│   │   ├── admin_users_view.dart    # Filter users, navigate to dealer credit
│   │   ├── admin_credit_management_view.dart # Allocate limit, toggle 30D/90D credit
│   │   ├── admin_orders_view.dart   # All orders with credit due dates
│   │   └── admin_zoho_sync_view.dart# Trigger on-demand Zoho Workbook sync
└── main.dart                     # App bootstrap, MultiRepository & MultiBloc injection
```

---

## How to Run the Frontend

1. Ensure the backend server is running:
   ```bash
   cd ../backend
   npm run dev
   ```
2. Start the Flutter application:
   ```bash
   cd frontend
   flutter run
   ```
   *(Supported targets: Android Emulator, iOS Simulator, Chrome/Web, or Windows Desktop)*

---

## Pre-Loaded Test Accounts

| User Role | Mobile Number | OTP | Key Behavior |
|-----------|---------------|-----|--------------|
| **Customer** | `9999900001` | `123456` | Stock quantity is hidden (shows "In Stock"), checkout only via Upfront Direct Payment. |
| **Dealer Tier 1** | `9876543210` | `123456` | Zoho Verified. Exact stock visible (e.g., 450 units). Both **30-Day & 90-Day Credit Approved**. |
| **Dealer Tier 2** | `9876543211` | `123456` | Zoho Verified. Exact stock visible. **30-Day Credit Active**, 90-Day Credit Restricted. |
| **Dealer Unverified** | `9876543212` | `123456` | **Rejected at OTP Login** with Zoho CRM verification required notice. |
| **Plumber** | `9888800001` | `123456` | Verified Certification, assigned field activities, monthly earnings metrics. |
| **Admin** | `9000000001` | `123456` | Configure credit limits, toggle 30/90 days credit, sync Zoho Workbook, view reports. |

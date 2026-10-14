import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiEndpoints {
  static const String defaultWifiUrl = 'http://10.105.194.97:5000/api';

  static const String defaultLocalhostUrl = 'http://localhost:5000/api';

  static const String defaultEmulatorUrl = 'http://10.0.2.2:5000/api';

  static String _baseUrl = detectDefaultBaseUrl();

  static String get baseUrl => _baseUrl;

  static void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  static String detectDefaultBaseUrl() {
    if (kIsWeb) {
      return defaultLocalhostUrl;
    }
    try {
      if (Platform.isAndroid) {
        return defaultWifiUrl;
      }
    } catch (_) {}
    return defaultLocalhostUrl;
  }

  // Auth Endpoints
  static String get sendOtp => '$baseUrl/auth/send-otp';
  static String get verifyOtp => '$baseUrl/auth/verify-otp';
  static String get profile => '$baseUrl/auth/profile';

  // Product Endpoints
  static String get products => '$baseUrl/products';
  static String get categories => '$baseUrl/products/categories';

  // Order Endpoints
  static String get orders => '$baseUrl/orders';
  static String get orderTracking => '$baseUrl/orders/tracking';

  // Plumber Endpoints
  static String get plumberDashboard => '$baseUrl/plumber/dashboard';
  static String get plumberTasks => '$baseUrl/plumber/tasks';
  static String get plumberProducts => '$baseUrl/plumber/products';
  static String get plumberNotifications => '$baseUrl/plumber/notifications';

  // Admin Endpoints
  static String get adminUsers => '$baseUrl/admin/users';
  static String get adminDealersCredit => '$baseUrl/admin/dealers';
  static String get adminOrders => '$baseUrl/admin/orders';
  static String get adminReports => '$baseUrl/admin/reports';
  static String get adminZohoSync => '$baseUrl/admin/zoho-sync';
}

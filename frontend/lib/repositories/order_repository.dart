import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/order_model.dart';

class OrderRepository {
  final ApiClient _client = ApiClient();

  Future<OrderModel> createOrder({
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    Map<String, dynamic>? shippingAddress,
  }) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.orders,
        data: {
          'items': items,
          'paymentMethod': paymentMethod,
          'shippingAddress': shippingAddress,
        },
      );
      return OrderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to place order');
    }
  }

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.orders);
      final list = response.data['data'] as List<dynamic>;
      return list.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load orders');
    }
  }

  Future<Map<String, dynamic>> getOrderTracking(String orderId) async {
    try {
      final response = await _client.dio.get('${ApiEndpoints.orderTracking}/$orderId');
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load tracking');
    }
  }
}

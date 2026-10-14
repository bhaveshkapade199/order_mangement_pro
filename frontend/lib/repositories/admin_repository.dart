import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';

class AdminRepository {
  final ApiClient _client = ApiClient();

  Future<List<UserModel>> getUsers({String? role}) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.adminUsers,
        queryParameters: role != null ? {'role': role} : null,
      );
      final list = response.data['data'] as List<dynamic>;
      return list.map((j) => UserModel.fromJson(j)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load users');
    }
  }

  Future<void> updateDealerCredit({
    required String userId,
    required double creditLimit,
    required bool credit30Allowed,
    required bool credit90Allowed,
  }) async {
    try {
      await _client.dio.patch(
        '${ApiEndpoints.adminDealersCredit}/$userId/credit',
        data: {
          'creditLimit': creditLimit,
          'credit30Allowed': credit30Allowed,
          'credit90Allowed': credit90Allowed,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to update credit permissions');
    }
  }

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.adminOrders);
      final list = response.data['data'] as List<dynamic>;
      return list.map((j) => OrderModel.fromJson(j)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load orders');
    }
  }

  Future<Map<String, dynamic>> getReports() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.adminReports);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load executive reports');
    }
  }

  Future<Map<String, dynamic>> triggerZohoSync() async {
    try {
      final response = await _client.dio.post(ApiEndpoints.adminZohoSync);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to trigger Zoho synchronization');
    }
  }
}

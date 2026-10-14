import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/plumber_task_model.dart';
import '../models/product_model.dart';

class PlumberRepository {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.plumberDashboard);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load plumber dashboard');
    }
  }

  Future<List<PlumberTaskModel>> getTasks({String? status}) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.plumberTasks,
        queryParameters: status != null ? {'status': status} : null,
      );
      final list = response.data['data'] as List<dynamic>;
      return list.map((j) => PlumberTaskModel.fromJson(j)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load assigned activities');
    }
  }

  Future<PlumberTaskModel> updateTaskStatus({
    required String taskId,
    required String status,
    String? completionNotes,
  }) async {
    try {
      final response = await _client.dio.patch(
        '${ApiEndpoints.plumberTasks}/$taskId',
        data: {
          'status': status,
          'completionNotes': completionNotes,
        },
      );
      return PlumberTaskModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to update task');
    }
  }

  Future<List<ProductModel>> getPlumberProducts() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.plumberProducts);
      final list = response.data['data'] as List<dynamic>;
      return list.map((j) => ProductModel.fromJson(j)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load products');
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.plumberNotifications);
      final list = response.data['data'] as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load notifications');
    }
  }
}

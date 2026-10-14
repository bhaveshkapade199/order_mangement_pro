import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> sendOtp({
    required String mobileNumber,
    required String role,
  }) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.sendOtp,
        data: {
          'mobileNumber': mobileNumber,
          'role': role,
        },
      );
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to send OTP');
    }
  }

  Future<UserModel> verifyOtp({
    required String mobileNumber,
    required String otp,
    required String role,
  }) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'mobileNumber': mobileNumber,
          'otp': otp,
          'role': role,
        },
      );

      final data = response.data['data'];
      final token = data['token'];
      final user = UserModel.fromJson(data['user']);

      await TokenStorage.saveToken(token);
      await TokenStorage.saveUser(user);

      return user;
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to verify OTP');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    return await TokenStorage.getUser();
  }

  Future<void> logout() async {
    await TokenStorage.clear();
  }
}

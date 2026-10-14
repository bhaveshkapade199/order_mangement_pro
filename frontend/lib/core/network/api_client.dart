import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../constants/api_endpoints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() => _instance;

  void updateBaseUrl(String newUrl) {
    dio.options.baseUrl = newUrl;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          String message = 'Network error occurred';
          if (error.response?.data != null && error.response?.data['message'] != null) {
            message = error.response!.data['message'];
          } else if (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout ||
              (error.message != null && error.message!.contains('Connection refused'))) {
            message = 'Connection refused: Unable to connect to backend server at ${ApiEndpoints.baseUrl}.\n\nPlease ensure the backend is running, or tap Server Settings in the top bar to update the IP address.';
          } else if (error.message != null) {
            message = error.message!;
          }

          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              error: message,
              type: error.type,
            ),
          );
        },
      ),
    );
  }
}

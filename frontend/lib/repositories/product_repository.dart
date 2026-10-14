import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ProductRepository {
  final ApiClient _client = ApiClient();

  Future<List<ProductModel>> getProducts({String? category, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty && category != 'All') {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _client.dio.get(
        ApiEndpoints.products,
        queryParameters: queryParams,
      );

      final list = response.data['data']['products'] as List<dynamic>;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load products');
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _client.dio.get('${ApiEndpoints.products}/$id');
      return ProductModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load product details');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.categories);
      final list = response.data['data'] as List<dynamic>;
      return list.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Failed to load categories');
    }
  }
}

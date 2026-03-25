import 'package:dio/dio.dart';
import 'package:nike_sneaker_store/core/network/api_client.dart';
import 'package:nike_sneaker_store/data/models/product_model.dart';

class ProductRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final List data = response.data as List;
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      final List data = response.data as List;
      return data.where((e) => e != null).map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      final List data = response.data as List;
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return Exception('Server error ($code)');
      default:
        return Exception('Unexpected error: ${e.message}');
    }
  }
}

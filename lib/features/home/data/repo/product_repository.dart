import 'package:dio/dio.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';

class ProductRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://fakestoreapi.com/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<ProductModel>> getProducts() async {
    int retry = 0;

    while (retry < 3) {
      try {
        final response = await dio.get('products');

        final List data = response.data;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } catch (e) {
        retry++;

        if (retry == 3) {
          throw Exception('Server error');
        }

        await Future.delayed(const Duration(seconds: 2));
      }
    }

    return [];
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get('products/$id');

      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product');
    }
  }
}

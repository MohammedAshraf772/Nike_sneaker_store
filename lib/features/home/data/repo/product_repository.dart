import 'package:dio/dio.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';

class ProductRepository {
  final Dio dio;

  ProductRepository(this.dio);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('مشكلة في الاتصال بالسيرفر، تأكد من الإنترنت');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('السيرفر استغرق وقت طويل في الرد');
      }
      throw Exception('حدث خطأ غير متوقع: ${e.message}');
    } catch (e) {
      throw Exception('خطأ في معالجة البيانات: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('products');

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _productsRef.get();

    return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final doc = await _productsRef.doc(id.toString()).get();

    if (!doc.exists) {
      throw Exception('Product $id not found');
    }

    return ProductModel.fromFirestore(doc);
  }
}

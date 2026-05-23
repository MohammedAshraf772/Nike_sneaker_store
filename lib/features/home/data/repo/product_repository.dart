import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      ProductModel(
        id: 1,
        title: "Nike Air Max",
        price: 120,
        description: "Best Nike shoes",
        category: "Shoes",
        image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
        ratingRate: 4.8,
        ratingCount: 120,
      ),
      ProductModel(
        id: 2,
        title: "Nike Jordan",
        price: 150,
        description: "Jordan collection",
        category: "Shoes",
        image: "https://images.unsplash.com/photo-1600185365483-26d7a4cc7519",
        ratingRate: 4.9,
        ratingCount: 90,
      ),
      ProductModel(
        id: 3,
        title: "Nike Revolution",
        price: 99,
        description: "Running shoes",
        category: "Running",
        image: "https://images.unsplash.com/photo-1549298916-b41d501d3772",
        ratingRate: 4.5,
        ratingCount: 75,
      ),
      ProductModel(
        id: 4,
        title: "Nike Zoom",
        price: 180,
        description: "Zoom collection",
        category: "Sneakers",
        image: "https://images.unsplash.com/photo-1608231387042-66d1773070a5",
        ratingRate: 4.7,
        ratingCount: 66,
      ),
      ProductModel(
        id: 5,
        title: "Nike Club Max",
        price: 135,
        description: "Comfort sneakers",
        category: "Shoes",
        image: "https://images.unsplash.com/photo-1605348532760-6753d2c43329",
        ratingRate: 4.6,
        ratingCount: 88,
      ),
      ProductModel(
        id: 6,
        title: "Nike Air Blue",
        price: 160,
        description: "Blue edition",
        category: "Shoes",
        image: "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a",
        ratingRate: 4.9,
        ratingCount: 140,
      ),
    ];
  }

  Future<ProductModel> getProductById(int id) async {
    final products = await getProducts();
    return products.firstWhere((e) => e.id == id);
  }
}

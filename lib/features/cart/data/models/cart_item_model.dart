import 'package:nike_sneaker_store/features/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel(
        id: json['id'],
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        description: '',
        category: json['category'],
        image: json['image'],
        ratingRate: 0,
        ratingCount: 0,
      ),
      quantity: json['quantity'],
    );
  }
}

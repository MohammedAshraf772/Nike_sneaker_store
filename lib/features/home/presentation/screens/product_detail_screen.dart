import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Column(
        children: [
          Image.network(product.image),
          Text(product.title),
          Text('\$${product.price}'),
        ],
      ),
    );
  }
}

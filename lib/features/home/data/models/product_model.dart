import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.network(product.image, height: 100),
          Text(product.title),
          Text('\$${product.price}'),
        ],
      ),
    );
  }
}
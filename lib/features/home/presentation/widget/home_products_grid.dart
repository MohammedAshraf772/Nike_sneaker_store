import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/widgets/product_card.dart';
import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';
import 'package:nike_sneaker_store/features/home/presentation/screens/product_detail_screen.dart';

class HomeProductsGrid extends StatelessWidget {
  final List<ProductModel> products;

  const HomeProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];

          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        }, childCount: products.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
      ),
    );
  }
}

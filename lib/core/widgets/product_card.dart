import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';

import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';

import 'package:nike_sneaker_store/features/favourates/cubit/favorites_cubit.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Align(
              alignment: Alignment.topRight,

              child: BlocBuilder<FavoritesCubit, List<ProductModel>>(
                builder: (context, favorites) {
                  final isFavorite = context.read<FavoritesCubit>().isFavorite(
                    product,
                  );

                  return GestureDetector(
                    onTap: () {
                      context.read<FavoritesCubit>().toggleFavorite(product);
                    },

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),

                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,

                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: Hero(
                tag: "product_${product.id}",

                child: Image.network(product.image),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              product.title,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "\$${product.price}",

              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

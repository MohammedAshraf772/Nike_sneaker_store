import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';

import 'package:nike_sneaker_store/features/favourates/cubit/favorites_cubit.dart';

import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),

      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Favorites"),
      ),

      body: BlocBuilder<FavoritesCubit, List<ProductModel>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Text(
                "No Favorites Yet",

                style: TextStyle(color: AppColors.getTextPrimary(context)),
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,

            itemBuilder: (context, index) {
              final product = favorites[index];

              return Container(
                margin: const EdgeInsets.all(12),

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: AppColors.getTextPrimary(context),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Row(
                  children: [
                    Image.network(product.image, width: 80, height: 80),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            product.title,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              color: AppColors.getTextPrimary(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "\$${product.price}",

                            style: TextStyle(
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

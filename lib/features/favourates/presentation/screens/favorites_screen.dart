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
        backgroundColor: AppColors.getBackground(context),
        title: Text(
          "Favorites",
          style: TextStyle(color: AppColors.getTextPrimary(context)),
        ),
        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),
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
                  color: AppColors.getCard(context),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            width: 80,
                            height: 80,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.getTextSecondary(context),
                            ),
                          );
                        },
                      ),
                    ),

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

                            style: const TextStyle(color: AppColors.primary),
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

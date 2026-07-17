import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';

class SearchInitialWidget extends StatelessWidget {
  const SearchInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.textHint,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Search for products',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try searching by name or category',
            style: TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

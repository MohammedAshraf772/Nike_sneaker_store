import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';

class SearchLoadingWidget extends StatelessWidget {
  const SearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2,
      ),
    );
  }
}

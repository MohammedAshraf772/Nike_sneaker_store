// features/search/presentation/widgets/search_error_widget.dart

import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';

class SearchErrorWidget extends StatelessWidget {
  final String message;

  const SearchErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ),
    );
  }
}

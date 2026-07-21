import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/home/presentation/cubit/home_cubit.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.getTextPrimary(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          style: TextStyle(color: AppColors.getTextPrimary(context)),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search products...',
            hintStyle: TextStyle(color: AppColors.getTextPrimary(context)),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          onChanged: (value) {
            context.read<HomeCubit>().searchProducts(value);
          },
        ),
      ),
    );
  }
}

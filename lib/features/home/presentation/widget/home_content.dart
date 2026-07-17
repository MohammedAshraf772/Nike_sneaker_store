import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/features/home/presentation/cubit/home_cubit.dart';
import 'package:nike_sneaker_store/features/home/presentation/widget/home_app_bar.dart';
import 'package:nike_sneaker_store/features/home/presentation/widget/home_categories.dart';
import 'package:nike_sneaker_store/features/home/presentation/widget/home_products_grid.dart';
import 'package:nike_sneaker_store/features/home/presentation/widget/home_search_bar.dart';

class HomeContent extends StatelessWidget {
  final HomeSuccess state;

  const HomeContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeAppBar(),
        const HomeSearchBar(),
        HomeCategories(state: state),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${state.products.length} Products Found',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        HomeProductsGrid(products: state.products),
      ],
    );
  }
}

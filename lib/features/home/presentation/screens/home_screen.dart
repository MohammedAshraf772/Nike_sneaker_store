import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/widgets/product_card.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_state.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';

import 'package:nike_sneaker_store/features/home/data/repo/product_repository.dart';
import 'package:nike_sneaker_store/features/home/presentation/cubit/home_cubit.dart';

import 'package:nike_sneaker_store/features/home/presentation/screens/product_detail_screen.dart';
import 'package:nike_sneaker_store/features/search/presentation/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(ProductRepository(Dio()))..getProducts(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) return _buildLoading();
            if (state is HomeError) return _buildError(context, state.message);
            if (state is HomeSuccess) return _buildContent(context, state);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: Colors.white)),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().getProducts(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeSuccess state) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildSearchBar(context),
        _buildSectionTitle('${state.products.length} Products Found'),
        _buildProductsGrid(context, state),
      ],
    );
  }

  SliverToBoxAdapter _buildAppBar() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text('Search...', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  SliverPadding _buildProductsGrid(BuildContext context, HomeSuccess state) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final ProductModel product = state.products[index];

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
        }, childCount: state.products.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Stack(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            if (state.totalItems > 0)
              Positioned(right: 0, child: Text('${state.totalItems}')),
          ],
        );
      },
    );
  }
}

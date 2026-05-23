import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';

import 'package:nike_sneaker_store/core/widgets/product_card.dart';
import 'package:nike_sneaker_store/core/widgets/side_menu.dart';

import 'package:nike_sneaker_store/features/cart/screens/cart_screen.dart';

import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';
import 'package:nike_sneaker_store/features/home/data/repo/product_repository.dart';

import 'package:nike_sneaker_store/features/home/presentation/cubit/home_cubit.dart';

import 'package:nike_sneaker_store/features/home/presentation/screens/product_detail_screen.dart';

import 'package:nike_sneaker_store/features/profile/presentation/screens/profile_screen.dart';

import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(ProductRepository())..getProducts(),

      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),

      backgroundColor: AppColors.background,

      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return _buildLoading();
            }

            if (state is HomeError) {
              return _buildError(context, state.message);
            }

            if (state is HomeSuccess) {
              return _buildContent(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: 6,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        mainAxisSpacing: 16,
        crossAxisSpacing: 16,

        childAspectRatio: 0.7,
      ),

      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,

          highlightColor: Colors.grey[700]!,

          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,

              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(message, style: const TextStyle(color: Colors.white)),

          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().getProducts();
            },

            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeSuccess state) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),

        _buildSearchBar(context),

        _buildCategories(context, state),

        _buildSectionTitle('${state.products.length} Products Found'),

        _buildProductsGrid(context, state),
      ],
    );
  }

  SliverToBoxAdapter _buildAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Home",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 22,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),

                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.person, color: Colors.white),

                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),

        padding: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          color: AppColors.card,

          borderRadius: BorderRadius.circular(12),
        ),

        child: TextField(
          style: const TextStyle(color: Colors.white),

          decoration: const InputDecoration(
            border: InputBorder.none,

            hintText: 'Search products...',

            hintStyle: TextStyle(color: Colors.grey),

            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),

          onChanged: (value) {
            context.read<HomeCubit>().searchProducts(value);
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategories(BuildContext context, HomeSuccess state) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,

        child: ListView.builder(
          scrollDirection: Axis.horizontal,

          padding: const EdgeInsets.symmetric(horizontal: 16),

          itemCount: state.categories.length,

          itemBuilder: (context, index) {
            final category = state.categories[index];

            final isSelected = category == state.selectedCategory;

            return GestureDetector(
              onTap: () {
                context.read<HomeCubit>().filterByCategory(category);
              },

              child: Container(
                margin: const EdgeInsets.only(right: 12),

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.card,

                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  category,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
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

          mainAxisSpacing: 16,
          crossAxisSpacing: 16,

          childAspectRatio: 0.7,
        ),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';

import '../../data/repo/product_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductRepository repo;

  HomeCubit(this.repo) : super(HomeInitial());

  Future<void> getProducts() async {
    try {
      emit(HomeLoading());

      final products = await repo.getProducts();

      final categories = ['All', ...products.map((e) => e.category).toSet()];

      emit(
        HomeSuccess(
          products: products,

          allProducts: products,

          categories: categories,

          selectedCategory: 'All',
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void filterByCategory(String category) {
    final currentState = state;

    if (currentState is HomeSuccess) {
      List<ProductModel> filteredProducts = [];

      if (category == 'All') {
        filteredProducts = currentState.allProducts;
      } else {
        filteredProducts =
            currentState.allProducts
                .where((product) => product.category == category)
                .toList();
      }

      emit(
        HomeSuccess(
          products: filteredProducts,

          allProducts: currentState.allProducts,

          categories: currentState.categories,

          selectedCategory: category,
        ),
      );
    }
  }

  void searchProducts(String query) {
    final currentState = state;

    if (currentState is HomeSuccess) {
      List<ProductModel> filteredProducts = [];

      if (query.isEmpty) {
        if (currentState.selectedCategory == 'All') {
          filteredProducts = currentState.allProducts;
        } else {
          filteredProducts =
              currentState.allProducts
                  .where(
                    (product) =>
                        product.category == currentState.selectedCategory,
                  )
                  .toList();
        }
      } else {
        filteredProducts =
            currentState.allProducts.where((product) {
              final matchesSearch = product.title.toLowerCase().contains(
                query.toLowerCase(),
              );

              final matchesCategory =
                  currentState.selectedCategory == 'All'
                      ? true
                      : product.category == currentState.selectedCategory;

              return matchesSearch && matchesCategory;
            }).toList();
      }

      emit(
        HomeSuccess(
          products: filteredProducts,

          allProducts: currentState.allProducts,

          categories: currentState.categories,

          selectedCategory: currentState.selectedCategory,
        ),
      );
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';
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
      if (category == 'All') {
        emit(
          HomeSuccess(
            products: currentState.allProducts,
            allProducts: currentState.allProducts,
            categories: currentState.categories,
            selectedCategory: category,
          ),
        );
      } else {
        final filtered =
            currentState.allProducts
                .where((p) => p.category == category)
                .toList();

        emit(
          HomeSuccess(
            products: filtered,
            allProducts: currentState.allProducts,
            categories: currentState.categories,
            selectedCategory: category,
          ),
        );
      }
    }
  }
}

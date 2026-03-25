import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/data/models/repositories/product_repository.dart';
import '../../data/models/product_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductRepository _repo;

  HomeCubit(this._repo) : super(HomeInitial());
  Future<void> loadHome() async {
    emit(HomeLoading());
    try {
      print('=== loadHome started ===');
      final List<ProductModel> products = await _repo.getProducts();
      print('=== products loaded: ${products.length} ===');
      final List<String> rawCategories = await _repo.getCategories();
      print('=== categories loaded: $rawCategories ===');
      final List<String> categories = ['All', ...rawCategories];

      emit(
        HomeLoaded(
          products: products,
          categories: categories,
          selectedCategory: 'All',
        ),
      );
      print('=== HomeLoaded emitted ===');
    } catch (e, stackTrace) {
      print('=== ERROR: $e ===');
      print('=== STACK: $stackTrace ===');
      emit(HomeError(e.toString()));
    }
  }

  Future<void> filterByCategory(String category) async {
    final current = state;
    if (current is! HomeLoaded) return;

    // ✅ نحتفظ بالـ categories عشان متتمسحش
    emit(current.copyWith(products: [], selectedCategory: category));

    try {
      final List<ProductModel> products;

      if (category == 'All') {
        products = (await _repo.getProducts()).cast<ProductModel>();
      } else {
        products =
            (await _repo.getProductsByCategory(category)).cast<ProductModel>();
      }

      // ✅ نمسك الـ state من جديد بعد الـ await
      final updatedState = state;
      if (updatedState is! HomeLoaded) return;

      emit(
        updatedState.copyWith(products: products, selectedCategory: category),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

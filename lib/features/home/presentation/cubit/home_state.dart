part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ProductModel> products;
  final List<ProductModel> allProducts;
  final List<String> categories;
  final String selectedCategory;

  HomeSuccess({
    required this.products,
    required this.allProducts,
    required this.categories,
    required this.selectedCategory,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  final List<String> categories;
  final String selectedCategory;

  const HomeLoaded({
    required this.products,
    required this.categories,
    required this.selectedCategory,
  });

  HomeLoaded copyWith({
    List<ProductModel>? products,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [products, categories, selectedCategory];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

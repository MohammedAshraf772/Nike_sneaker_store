import 'package:equatable/equatable.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}

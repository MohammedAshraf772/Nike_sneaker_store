import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(ProductModel product) {
    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((i) => i.product.id == product.id);

    if (index != -1) {
      // المنتج موجود — زود الـ quantity
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      // منتج جديد
      items.add(CartItemModel(product: product, quantity: 1));
    }

    emit(state.copyWith(items: items));
  }

  void removeFromCart(int productId) {
    final items = state.items.where((i) => i.product.id != productId).toList();
    emit(state.copyWith(items: items));
  }

  void incrementQuantity(int productId) {
    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      emit(state.copyWith(items: items));
    }
  }

  void decrementQuantity(int productId) {
    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      if (items[index].quantity == 1) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(
          quantity: items[index].quantity - 1,
        );
      }
      emit(state.copyWith(items: items));
    }
  }

  void clearCart() => emit(const CartState());
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/checkout/data/models/order_model.dart';
import 'package:nike_sneaker_store/features/checkout/domain/usecases/place_order.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._placeOrder) : super(CheckoutInitial());

  final PlaceOrder _placeOrder;

  /// Simulates a card payment for one or more cart items. The raw
  /// [cardNumber] and [cvv] are used only for local, on-device validation —
  /// they are never sent anywhere or stored. Only the last 4 digits of the
  /// card are kept, for the confirmation message and the order record.
  Future<void> pay({
    required List<CartItemModel> items,
    required String cardHolderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    emit(CheckoutProcessing());

    if (items.isEmpty) {
      emit(const CheckoutError('Your cart is empty'));
      return;
    }

    final digitsOnly = cardNumber.replaceAll(RegExp(r'\s+'), '');

    if (cardHolderName.trim().isEmpty) {
      emit(const CheckoutError('Please enter the cardholder name'));
      return;
    }

    if (digitsOnly.length != 16 || int.tryParse(digitsOnly) == null) {
      emit(const CheckoutError('Card number must be 16 digits'));
      return;
    }

    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiryDate)) {
      emit(const CheckoutError('Expiry date must be in MM/YY format'));
      return;
    }

    if (cvv.length != 3 || int.tryParse(cvv) == null) {
      emit(const CheckoutError('CVV must be 3 digits'));
      return;
    }

    // Simulate the network round-trip to a payment gateway.
    await Future.delayed(const Duration(seconds: 2));

    final last4 = digitsOnly.substring(digitsOnly.length - 4);
    final totalPrice = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    final order = OrderModel(
      items:
          items
              .map(
                (item) => OrderLineItem(
                  productId: item.product.id.toString(),
                  productTitle: item.product.title,
                  productImage: item.product.image,
                  unitPrice: item.product.price,
                  quantity: item.quantity,
                ),
              )
              .toList(),
      totalPrice: totalPrice,
      cardHolderName: cardHolderName,
      last4: last4,
      status: 'success',
      createdAt: DateTime.now(),
    );

    try {
      await _placeOrder(order);
      emit(CheckoutSuccess(last4: last4, totalPrice: totalPrice));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}

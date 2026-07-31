import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/checkout/data/model/order_model.dart';
import 'package:nike_sneaker_store/features/checkout/data/repo/order_repository.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._orderRepository) : super(CheckoutInitial());

  final OrderRepository _orderRepository;
  Future<void> pay({
    required ProductModel product,
    required int quantity,
    required String cardHolderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    emit(CheckoutProcessing());

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
    await Future.delayed(const Duration(seconds: 2));

    final last4 = digitsOnly.substring(digitsOnly.length - 4);
    final totalPrice = product.price * quantity;

    final order = OrderModel(
      productId: product.id.toString(),
      productTitle: product.title,
      productImage: product.image,
      unitPrice: product.price,
      quantity: quantity,
      totalPrice: totalPrice,
      cardHolderName: cardHolderName,
      last4: last4,
      status: 'success',
      createdAt: DateTime.now(),
    );

    try {
      await _orderRepository.placeOrder(order);
      emit(CheckoutSuccess(last4: last4, totalPrice: totalPrice));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/utils/card_brand_detector.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/checkout/data/models/order_model.dart';
import 'package:nike_sneaker_store/features/checkout/domain/entities/payment_method.dart';
import 'package:nike_sneaker_store/features/checkout/domain/usecases/place_order.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._placeOrder) : super(CheckoutInitial());

  final PlaceOrder _placeOrder;
  Future<void> pay({
    required List<CartItemModel> items,
    required PaymentMethod method,
    Currency? currency,
    String cardHolderName = '',
    String cardNumber = '',
    String expiryDate = '',
    String cvv = '',
  }) async {
    emit(CheckoutProcessing());

    if (items.isEmpty) {
      emit(const CheckoutError('Please select at least one item'));
      return;
    }

    final selectedCurrency = currency ?? Currency.all.first;

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    final shippingFee = subtotal * 0.10;
    final codFee = method == PaymentMethod.cashOnDelivery ? 15.0 : 0.0;

    var last4 = '';
    var cardBrand = '';

    if (method == PaymentMethod.visa) {
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

      last4 = digitsOnly.substring(digitsOnly.length - 4);
      cardBrand = CardBrandDetector.detect(digitsOnly).label;

      await Future.delayed(const Duration(seconds: 2));
    } else {
      await Future.delayed(const Duration(seconds: 1));
    }

    final totalPrice = subtotal + shippingFee + codFee;

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
      subtotal: subtotal,
      shippingFee: shippingFee,
      codFee: codFee,
      totalPrice: totalPrice,
      paymentMethod: method.label,
      cardHolderName: method == PaymentMethod.visa ? cardHolderName : '',
      last4: last4,
      cardBrand: cardBrand,
      currencyCode: selectedCurrency.code,
      exchangeRate: selectedCurrency.rateFromUsd,
      totalInSelectedCurrency: selectedCurrency.convertFromUsd(totalPrice),
      status: 'success',
      createdAt: DateTime.now(),
    );

    try {
      await _placeOrder(order);
      emit(
        CheckoutSuccess(
          subtotal: subtotal,
          shippingFee: shippingFee,
          codFee: codFee,
          totalPrice: totalPrice,
          paymentMethod: method.label,
          last4: last4,
          cardBrand: cardBrand,
          currency: selectedCurrency,
        ),
      );
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}

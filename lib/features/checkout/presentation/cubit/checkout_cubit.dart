import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/utils/card_brand_detector.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/checkout/data/models/order_model.dart';
import 'package:nike_sneaker_store/features/checkout/domain/entities/order_pricing.dart';
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

    final isCard = method == PaymentMethod.visa;
    final digitsOnly = cardNumber.replaceAll(RegExp(r'\s+'), '');

    if (isCard) {
      final error = _validateCard(
        cardHolderName: cardHolderName,
        digitsOnly: digitsOnly,
        expiryDate: expiryDate,
        cvv: cvv,
      );
      if (error != null) {
        emit(CheckoutError(error));
        return;
      }
    }

    await Future.delayed(Duration(seconds: isCard ? 2 : 1));

    final selectedCurrency = currency ?? Currency.all.first;
    final pricing = OrderPricing.from(items: items, method: method);
    final last4 = isCard ? digitsOnly.substring(digitsOnly.length - 4) : '';
    final cardBrand = isCard ? CardBrandDetector.detect(digitsOnly).label : '';

    final order = OrderModel(
      items: _toLineItems(items),
      subtotal: pricing.subtotal,
      shippingFee: pricing.shippingFee,
      codFee: pricing.codFee,
      totalPrice: pricing.total,
      paymentMethod: method.label,
      cardHolderName: isCard ? cardHolderName : '',
      last4: last4,
      cardBrand: cardBrand,
      currencyCode: selectedCurrency.code,
      exchangeRate: selectedCurrency.rateFromUsd,
      totalInSelectedCurrency: selectedCurrency.convertFromUsd(pricing.total),
      status: 'success',
      createdAt: DateTime.now(),
    );

    try {
      await _placeOrder(order);
      emit(
        CheckoutSuccess(
          subtotal: pricing.subtotal,
          shippingFee: pricing.shippingFee,
          codFee: pricing.codFee,
          totalPrice: pricing.total,
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

  String? _validateCard({
    required String cardHolderName,
    required String digitsOnly,
    required String expiryDate,
    required String cvv,
  }) {
    if (cardHolderName.trim().isEmpty) {
      return 'Please enter the cardholder name';
    }
    if (!RegExp(r'^\d{16}$').hasMatch(digitsOnly)) {
      return 'Card number must be 16 digits';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiryDate)) {
      return 'Expiry date must be in MM/YY format';
    }
    if (!RegExp(r'^\d{3}$').hasMatch(cvv)) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  List<OrderLineItem> _toLineItems(List<CartItemModel> items) {
    return items
        .map(
          (item) => OrderLineItem(
            productId: item.product.id.toString(),
            productTitle: item.product.title,
            productImage: item.product.image,
            unitPrice: item.product.price,
            quantity: item.quantity,
          ),
        )
        .toList();
  }
}

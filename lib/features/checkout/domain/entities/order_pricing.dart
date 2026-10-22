import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/checkout/domain/entities/payment_method.dart';

class OrderPricing {
  static const double shippingRate = 0.10;
  static const double cashOnDeliveryFee = 15;

  final double subtotal;
  final double shippingFee;
  final double codFee;

  const OrderPricing({
    required this.subtotal,
    required this.shippingFee,
    required this.codFee,
  });

  factory OrderPricing.from({
    required List<CartItemModel> items,
    required PaymentMethod method,
  }) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    return OrderPricing(
      subtotal: subtotal,
      shippingFee: subtotal * shippingRate,
      codFee: method == PaymentMethod.cashOnDelivery ? cashOnDeliveryFee : 0,
    );
  }

  double get total => subtotal + shippingFee + codFee;
}
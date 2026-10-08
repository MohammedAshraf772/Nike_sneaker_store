import 'package:equatable/equatable.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutProcessing extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final double subtotal;
  final double shippingFee;
  final double codFee;
  final double totalPrice;
  final String paymentMethod;
  final String last4;
  final String cardBrand;
  final Currency? currency;

  const CheckoutSuccess({
    required this.subtotal,
    required this.shippingFee,
    required this.codFee,
    required this.totalPrice,
    required this.paymentMethod,
    required this.last4,
    this.cardBrand = '',
    this.currency,
  });

  @override
  List<Object?> get props => [
    subtotal,
    shippingFee,
    codFee,
    totalPrice,
    paymentMethod,
    last4,
    cardBrand,
    currency?.code,
  ];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

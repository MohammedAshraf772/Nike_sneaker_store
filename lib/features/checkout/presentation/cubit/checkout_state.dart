import 'package:equatable/equatable.dart';

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

  const CheckoutSuccess({
    required this.subtotal,
    required this.shippingFee,
    required this.codFee,
    required this.totalPrice,
    required this.paymentMethod,
    required this.last4,
  });

  @override
  List<Object?> get props => [
    subtotal,
    shippingFee,
    codFee,
    totalPrice,
    paymentMethod,
    last4,
  ];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

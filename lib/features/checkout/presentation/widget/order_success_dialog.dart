import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_state.dart';

Future<void> showOrderSuccessDialog(
  BuildContext context,
  CheckoutSuccess state,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => OrderSuccessDialog(state: state),
  );
}

class OrderSuccessDialog extends StatelessWidget {
  final CheckoutSuccess state;

  const OrderSuccessDialog({super.key, required this.state});

  String _amount(Currency currency, double usdAmount) {
    return '${currency.symbol}${currency.convertFromUsd(usdAmount).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final currency = state.currency ?? Currency.all.first;
    final cardLabel = state.cardBrand.isEmpty ? 'Card' : state.cardBrand;

    return AlertDialog(
      title: const Text('Order placed'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment method: ${state.paymentMethod}'),
          if (state.last4.isNotEmpty)
            Text('$cardLabel ending in ${state.last4}'),
          Text('Currency: ${currency.code}'),
          const SizedBox(height: 8),
          Text('Subtotal: ${_amount(currency, state.subtotal)}'),
          Text('Shipping: ${_amount(currency, state.shippingFee)}'),
          if (state.codFee > 0)
            Text('Cash on Delivery fee: ${_amount(currency, state.codFee)}'),
          const SizedBox(height: 8),
          Text(
            'Total: ${_amount(currency, state.totalPrice)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final navigator = Navigator.of(context);
            navigator.pop();
            navigator.pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}

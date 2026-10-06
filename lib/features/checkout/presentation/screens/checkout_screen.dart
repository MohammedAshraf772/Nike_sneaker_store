import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/checkout/data/repository/order_repository_impl.dart';
import 'package:nike_sneaker_store/features/checkout/data/services/card_scanner_service.dart';
import 'package:nike_sneaker_store/features/checkout/domain/entities/payment_method.dart';
import 'package:nike_sneaker_store/features/checkout/domain/usecases/place_order.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_card_form.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_invoice_summary.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_pay_button.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_product_summary.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/payment_method_selector.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItemModel> items;

  final VoidCallback? onSuccess;

  const CheckoutScreen({super.key, required this.items, this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutCubit(PlaceOrder(OrderRepositoryImpl())),
      child: _CheckoutView(items: items, onSuccess: onSuccess),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  final List<CartItemModel> items;
  final VoidCallback? onSuccess;

  const _CheckoutView({required this.items, this.onSuccess});

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  final _cardScannerService = CardScannerService();
  final _imagePicker = ImagePicker();
  bool _isScanning = false;

  PaymentMethod _method = PaymentMethod.visa;

  double get _subtotal =>
      widget.items.fold<double>(0, (sum, item) => sum + item.totalPrice);
  double get _shipping => _subtotal * 0.10;
  double get _codFee => _method == PaymentMethod.cashOnDelivery ? 15 : 0;
  double get _total => _subtotal + _shipping + _codFee;

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardScannerService.dispose();
    super.dispose();
  }

  Future<void> _scanCard() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (pickedFile == null || !mounted) return;

    setState(() => _isScanning = true);

    try {
      final result = await _cardScannerService.scanImage(File(pickedFile.path));

      if (!mounted) return;

      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Couldn't read card details — try a clearer photo, or enter them manually",
            ),
          ),
        );
      } else {
        if (result.cardNumber != null) {
          _cardController.text = result.cardNumber!;
        }
        if (result.expiryDate != null) {
          _expiryController.text = result.expiryDate!;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Card number and expiry filled in — please enter the cardholder name and CVV manually",
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _submit(BuildContext context) {
    if (_method == PaymentMethod.visa && !_formKey.currentState!.validate()) {
      return;
    }

    context.read<CheckoutCubit>().pay(
      items: widget.items,
      method: _method,
      cardHolderName: _nameController.text,
      cardNumber: _cardController.text,
      expiryDate: _expiryController.text,
      cvv: _cvvController.text,
    );
  }

  void _onSuccess(BuildContext context, CheckoutSuccess state) {
    widget.onSuccess?.call();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Order placed'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment method: ${state.paymentMethod}'),
                if (state.last4.isNotEmpty)
                  Text('Card ending in ${state.last4}'),
                const SizedBox(height: 8),
                Text('Subtotal: \$${state.subtotal.toStringAsFixed(2)}'),
                Text('Shipping: \$${state.shippingFee.toStringAsFixed(2)}'),
                if (state.codFee > 0)
                  Text(
                    'Cash on Delivery fee: \$${state.codFee.toStringAsFixed(2)}',
                  ),
                const SizedBox(height: 8),
                Text(
                  'Total: \$${state.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.getBackground(context),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            _onSuccess(context, state);
          } else if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckoutProductSummary(items: widget.items),
                const SizedBox(height: 24),
                PaymentMethodSelector(
                  selected: _method,
                  onChanged: (method) => setState(() => _method = method),
                ),
                const SizedBox(height: 24),
                if (_method == PaymentMethod.visa) ...[
                  CheckoutCardForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    cardController: _cardController,
                    expiryController: _expiryController,
                    cvvController: _cvvController,
                    isScanning: _isScanning,
                    onScanPressed: _scanCard,
                  ),
                  const SizedBox(height: 24),
                ],
                CheckoutInvoiceSummary(
                  subtotal: _subtotal,
                  shippingFee: _shipping,
                  codFee: _codFee,
                  total: _total,
                  currency: Currency.all.first,
                ),
                const SizedBox(height: 24),
                CheckoutPayButton(
                  totalPrice: _total,
                  isProcessing: state is CheckoutProcessing,
                  label: _method == PaymentMethod.visa ? 'Pay' : 'Place Order',
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/utils/currency.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/checkout/data/repository/order_repository_impl.dart';
import 'package:nike_sneaker_store/features/checkout/data/services/card_scanner_service.dart';
import 'package:nike_sneaker_store/features/checkout/domain/entities/order_pricing.dart';
import 'package:nike_sneaker_store/features/checkout/domain/entities/payment_method.dart';
import 'package:nike_sneaker_store/features/checkout/domain/usecases/place_order.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_card_form.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_invoice_summary.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_pay_button.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/checkout_product_summary.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/currency_selector.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/order_success_dialog.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/widget/payment_method_selector.dart';

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
  final _scanner = CardScannerService();

  PaymentMethod _method = PaymentMethod.visa;
  Currency _currency = Currency.all.first;
  bool _isScanning = false;

  OrderPricing get _pricing =>
      OrderPricing.from(items: widget.items, method: _method);

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _scanner.dispose();
    super.dispose();
  }

  Future<void> _scanCard() async {
    setState(() => _isScanning = true);
    final result = await _scanner.scanFromCamera();
    if (!mounted) return;
    setState(() => _isScanning = false);
    if (result == null) return;

    _cardController.text = result.cardNumber ?? _cardController.text;
    _expiryController.text = result.expiryDate ?? _expiryController.text;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.feedbackMessage)));
  }

  void _submit(BuildContext context) {
    final needsCard = _method == PaymentMethod.visa;
    if (needsCard && !_formKey.currentState!.validate()) return;

    context.read<CheckoutCubit>().pay(
      items: widget.items,
      method: _method,
      currency: _currency,
      cardHolderName: _nameController.text,
      cardNumber: _cardController.text,
      expiryDate: _expiryController.text,
      cvv: _cvvController.text,
    );
  }

  void _onStateChanged(BuildContext context, CheckoutState state) {
    if (state is CheckoutSuccess) {
      widget.onSuccess?.call();
      showOrderSuccessDialog(context, state);
    } else if (state is CheckoutError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricing = _pricing;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.getBackground(context),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: _onStateChanged,
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
                CurrencySelector(
                  selected: _currency,
                  onChanged: (currency) => setState(() => _currency = currency),
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
                CheckoutInvoiceSummary(pricing: pricing, currency: _currency),
                const SizedBox(height: 24),
                CheckoutPayButton(
                  totalPrice: pricing.total,
                  currency: _currency,
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

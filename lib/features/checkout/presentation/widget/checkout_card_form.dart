import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/utils/expiry_date_input_formatter.dart';

class CheckoutCardForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController cardController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final VoidCallback onScanPressed;
  final bool isScanning;

  const CheckoutCardForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.cardController,
    required this.expiryController,
    required this.cvvController,
    required this.onScanPressed,
    required this.isScanning,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card details',
                style: TextStyle(
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton.icon(
                onPressed: isScanning ? null : onScanPressed,
                icon:
                    isScanning
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.camera_alt_outlined, size: 18),
                label: Text(isScanning ? 'Scanning...' : 'Scan card'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Cardholder name'),
            validator:
                (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: cardController,
            keyboardType: TextInputType.number,
            maxLength: 16,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Card number',
              hintText: '•••• •••• •••• ••••',
              counterText: '',
            ),
            validator:
                (v) =>
                    (v == null || v.replaceAll(' ', '').length != 16)
                        ? 'Enter a 16-digit card number'
                        : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ExpiryDateInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'MM/YY',
                    hintText: '12/28',
                  ),
                  validator:
                      (v) =>
                          (v == null ||
                                  !RegExp(
                                    r'^(0[1-9]|1[0-2])\/\d{2}$',
                                  ).hasMatch(v))
                              ? 'Invalid'
                              : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  obscureText: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    counterText: '',
                  ),
                  validator:
                      (v) => (v == null || v.length != 3) ? 'Invalid' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

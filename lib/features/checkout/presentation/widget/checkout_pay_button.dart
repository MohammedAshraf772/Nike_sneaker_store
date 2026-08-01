import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';

class CheckoutPayButton extends StatelessWidget {
  final double totalPrice;
  final bool isProcessing;
  final VoidCallback onPressed;

  const CheckoutPayButton({
    super.key,
    required this.totalPrice,
    required this.isProcessing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: isProcessing ? null : onPressed,
            child:
                isProcessing
                    ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                    : Text(
                      'Pay \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'This is a demo checkout — no real payment is processed and no card data is stored.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.getTextSecondary(context),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

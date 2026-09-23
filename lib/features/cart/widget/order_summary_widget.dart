import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_state.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartState state;
  final VoidCallback onCheckout;

  const OrderSummaryWidget({
    super.key,
    required this.state,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final shipping = state.totalPrice > 100 ? 0.0 : 9.99;
    final total = state.totalPrice + shipping;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: AppColors.getCard(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildRow(
            context,
            'Subtotal',
            '\$${state.totalPrice.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _buildRow(
            context,
            'Shipping',
            shipping == 0 ? 'FREE' : '\$${shipping.toStringAsFixed(2)}',
            color: shipping == 0 ? const Color(0xFF2A9D8F) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              color: AppColors.getTextSecondary(context).withOpacity(0.3),
            ),
          ),
          _buildRow(
            context,
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Checkout — \$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color:
                isTotal
                    ? AppColors.getTextPrimary(context)
                    : AppColors.getTextSecondary(context),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color:
                color ??
                (isTotal
                    ? AppColors.primary
                    : AppColors.getTextSecondary(context)),
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }
}

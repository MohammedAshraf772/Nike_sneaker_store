import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';

class CheckoutInvoiceSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double codFee;
  final double total;

  const CheckoutInvoiceSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.codFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCard(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _row(context, 'Subtotal', subtotal),
          const SizedBox(height: 8),
          _row(context, 'Shipping (10%)', shippingFee),
          if (codFee > 0) ...[
            const SizedBox(height: 8),
            _row(context, 'Cash on Delivery fee', codFee),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: AppColors.getTextSecondary(context).withOpacity(0.3),
            ),
          ),
          _row(context, 'Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    double value, {
    bool isTotal = false,
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
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            color:
                isTotal ? AppColors.primary : AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }
}

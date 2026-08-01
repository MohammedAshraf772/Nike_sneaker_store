import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/home/data/models/product_model.dart';

class CheckoutProductSummary extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final double totalPrice;

  const CheckoutProductSummary({
    super.key,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            product.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style: TextStyle(
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Qty: $quantity',
                style: TextStyle(color: AppColors.getTextSecondary(context)),
              ),
            ],
          ),
        ),
        Text(
          '\$${totalPrice.toStringAsFixed(2)}',
          style: TextStyle(
            color: AppColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

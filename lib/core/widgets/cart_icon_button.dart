import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_state.dart';

class CartIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? iconColor;
  const CartIconButton({super.key, required this.onPressed, this.iconColor});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final itemCount = state.totalItems;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: iconColor ?? AppColors.getTextPrimary(context),
              ),
              onPressed: onPressed,
            ),
            if (itemCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    itemCount > 99 ? '99+' : '$itemCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

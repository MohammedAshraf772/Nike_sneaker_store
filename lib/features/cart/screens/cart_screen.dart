import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_state.dart';
import 'package:nike_sneaker_store/features/cart/widget/cart_item_widget.dart';
import 'package:nike_sneaker_store/features/cart/widget/order_summary_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.getBackground(context),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),
        appBar: AppBar(
          title: const Text('My Cart'),
          backgroundColor: AppColors.getBackground(context),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.isLoading)
              return const Center(child: CircularProgressIndicator());
            if (state.items.isEmpty)
              return Center(
                child: Text(
                  "Cart is Empty",
                  style: TextStyle(color: AppColors.getTextPrimary(context)),
                ),
              );

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder:
                        (_, index) => CartItemWidget(item: state.items[index]),
                  ),
                ),
                OrderSummaryWidget(
                  state: state,
                  onCheckout: () => context.read<CartCubit>().clearCart(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_state.dart';
import 'package:nike_sneaker_store/features/cart/data/models/cart_item_model.dart';
import 'package:nike_sneaker_store/features/cart/widget/cart_item_widget.dart';
import 'package:nike_sneaker_store/features/cart/widget/order_summary_widget.dart';
import 'package:nike_sneaker_store/features/checkout/presentation/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Set<int> _selectedIds = {};
  bool _initialized = false;

  void _syncSelection(List<CartItemModel> items) {
    if (!_initialized) {
      _selectedIds.addAll(items.map((e) => e.product.id));
      _initialized = true;
      return;
    }
    _selectedIds.removeWhere(
      (id) => !items.any((item) => item.product.id == id),
    );
  }

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
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.items.isEmpty) {
              return Center(
                child: Text(
                  "Cart is Empty",
                  style: TextStyle(color: AppColors.getTextPrimary(context)),
                ),
              );
            }

            _syncSelection(state.items);
            final selectedItems =
                state.items
                    .where((item) => _selectedIds.contains(item.product.id))
                    .toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      final item = state.items[index];
                      return CartItemWidget(
                        item: item,
                        isSelected: _selectedIds.contains(item.product.id),
                        onSelectedChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedIds.add(item.product.id);
                            } else {
                              _selectedIds.remove(item.product.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                OrderSummaryWidget(
                  items: selectedItems,
                  onCheckout: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CheckoutScreen(
                              items: selectedItems,
                              onSuccess: () {
                                context.read<CartCubit>().removeItems(
                                  selectedItems
                                      .map((e) => e.product.id)
                                      .toList(),
                                );
                                setState(() => _selectedIds.clear());
                              },
                            ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

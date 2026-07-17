import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/home/presentation/cubit/home_cubit.dart';

class HomeErrorWidget extends StatelessWidget {
  final String message;

  const HomeErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().getProducts();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

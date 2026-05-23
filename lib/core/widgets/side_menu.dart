import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';

import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';

import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:nike_sneaker_store/features/cart/screens/cart_screen.dart';

import 'package:nike_sneaker_store/features/favourates/presentation/screens/favorites_screen.dart';

import 'package:nike_sneaker_store/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nike_sneaker_store/features/profile/presentation/cubit/profile_state.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,

      child: SafeArea(
        child: Column(
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    final name =
                        authState is AuthAuthenticated
                            ? authState.name
                            : "User";

                    final email =
                        authState is AuthAuthenticated ? authState.email : "";

                    return Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(20),

                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 45,

                            backgroundColor: Colors.grey,

                            backgroundImage:
                                profileState.image.isNotEmpty
                                    ? NetworkImage(profileState.image)
                                    : null,

                            child:
                                profileState.image.isEmpty
                                    ? const Icon(Icons.person, size: 40)
                                    : null,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            name,

                            style: const TextStyle(
                              color: Colors.white,

                              fontSize: 20,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            email,

                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.white),

              title: const Text(
                "Favorites",

                style: TextStyle(color: Colors.white),
              ),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.white),

              title: const Text("Cart", style: TextStyle(color: Colors.white)),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

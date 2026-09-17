import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nike_sneaker_store/features/cart/screens/cart_screen.dart';
import 'package:nike_sneaker_store/features/favourates/presentation/screens/favorites_screen.dart';
import 'package:nike_sneaker_store/features/profile/presentation/cubit/profile_cubit.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.getBackground(context),
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
                            backgroundColor: AppColors.getCard(context),
                            backgroundImage:
                                profileState.image.isNotEmpty
                                    ? FileImage(File(profileState.image))
                                    : null,
                            child:
                                profileState.image.isEmpty
                                    ? Icon(
                                      Icons.person,
                                      size: 40,
                                      color: AppColors.getTextSecondary(
                                        context,
                                      ),
                                    )
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            name,
                            style: TextStyle(
                              color: AppColors.getTextPrimary(context),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(color: AppColors.getTextSecondary(context)),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: AppColors.getTextPrimary(context),
              ),
              title: Text(
                "Favorites",
                style: TextStyle(color: AppColors.getTextPrimary(context)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_cart,
                color: AppColors.getTextPrimary(context),
              ),
              title: Text(
                "Cart",
                style: TextStyle(color: AppColors.getTextPrimary(context)),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/cubit/theme_cubit.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';
import 'package:nike_sneaker_store/features/auth/core/screens/login_screen.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nike_sneaker_store/features/cart/screens/cart_screen.dart';
import 'package:nike_sneaker_store/features/favourates/presentation/screens/favorites_screen.dart';
import 'package:nike_sneaker_store/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nike_sneaker_store/features/profile/presentation/widget/profile_menu_title.dart';

import 'profile_avatar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Profile"),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileAvatar(imagePath: profileState.image),
                const SizedBox(height: 20),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    final name =
                        authState is AuthAuthenticated
                            ? authState.name
                            : "User";
                    final email =
                        authState is AuthAuthenticated ? authState.email : "";

                    return Column(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(email, style: const TextStyle(color: Colors.grey)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                ProfileMenuTile(
                  icon: Icons.dark_mode,
                  title: "Dark Mode",
                  trailing: Switch(
                    value: context.watch<ThemeCubit>().state,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ),
                ProfileMenuTile(
                  icon: Icons.favorite,
                  title: "Favorites",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesScreen(),
                        ),
                      ),
                ),
                ProfileMenuTile(
                  icon: Icons.shopping_cart,
                  title: "My Cart",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () => _handleLogout(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    await context.read<AuthCubit>().logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}

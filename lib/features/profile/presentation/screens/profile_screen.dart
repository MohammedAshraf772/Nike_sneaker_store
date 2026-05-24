import 'dart:io';

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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,

        title: const Text("Profile"),
      ),

      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,

                          backgroundColor: AppColors.card,

                          builder: (_) {
                            return SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),

                                    title: const Text(
                                      'View Photo',

                                      style: TextStyle(color: Colors.white),
                                    ),

                                    onTap: () {
                                      Navigator.pop(context);

                                      showDialog(
                                        context: context,

                                        builder: (_) {
                                          return Dialog(
                                            backgroundColor: Colors.black,

                                            child: InteractiveViewer(
                                              child:
                                                  state.image.isNotEmpty
                                                      ? Image.file(
                                                        File(state.image),
                                                      )
                                                      : const Padding(
                                                        padding: EdgeInsets.all(
                                                          40,
                                                        ),

                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 100,
                                                        ),
                                                      ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  ListTile(
                                    leading: const Icon(
                                      Icons.photo_library,
                                      color: Colors.white,
                                    ),

                                    title: const Text(
                                      'Choose from Gallery',

                                      style: TextStyle(color: Colors.white),
                                    ),

                                    onTap: () {
                                      Navigator.pop(context);

                                      context
                                          .read<ProfileCubit>()
                                          .pickImageFromGallery();
                                    },
                                  ),

                                  ListTile(
                                    leading: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),

                                    title: const Text(
                                      'Take Photo',

                                      style: TextStyle(color: Colors.white),
                                    ),

                                    onTap: () {
                                      Navigator.pop(context);

                                      context
                                          .read<ProfileCubit>()
                                          .pickImageFromCamera();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },

                      child: CircleAvatar(
                        radius: 50,

                        backgroundColor: Colors.grey.shade800,

                        backgroundImage:
                            state.image.isNotEmpty
                                ? FileImage(File(state.image))
                                : null,

                        child:
                            state.image.isEmpty
                                ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,

                      child: Container(
                        padding: const EdgeInsets.all(6),

                        decoration: const BoxDecoration(
                          color: AppColors.primary,

                          shape: BoxShape.circle,
                        ),

                        child: const Icon(Icons.add, size: 18),
                      ),
                    ),
                  ],
                ),

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

                _tile(
                  icon: Icons.dark_mode,

                  title: "Dark Mode",

                  trailing: Switch(
                    value: context.watch<ThemeCubit>().state,

                    onChanged: (_) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ),

                _tile(
                  icon: Icons.favorite,

                  title: "Favorites",

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const FavoritesScreen(),
                      ),
                    );
                  },
                ),

                _tile(
                  icon: Icons.shopping_cart,

                  title: "My Cart",

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () async {
                    await context.read<AuthCubit>().logout();

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,

                        MaterialPageRoute(builder: (_) => const LoginScreen()),

                        (route) => false,
                      );
                    }
                  },

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

  Widget _tile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius: BorderRadius.circular(12),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(icon, color: Colors.white),

        title: Text(title, style: const TextStyle(color: Colors.white)),

        trailing: trailing,
      ),
    );
  }
}

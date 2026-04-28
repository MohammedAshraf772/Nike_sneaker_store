import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/cubit/theme_cubit.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_cubit.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_state.dart';
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
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                _buildHeader(context),
                _buildStats(context),
                _buildSection('Preferences', [
                  _buildToggleTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    value: state.isDarkMode,
                    onChanged: (_) {
                      context.read<ThemeCubit>().toggleTheme();
                      context.read<ProfileCubit>().toggleDarkMode();
                    },
                  ),
                ]),
                _buildLogoutButton(context),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final name = authState is AuthAuthenticated ? authState.name : 'User';
          final email = authState is AuthAuthenticated ? authState.email : '';

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Text(name, style: const TextStyle(color: Colors.white)),
                Text(email, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildStats(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return Text(
            "Items: ${state.totalItems}",
            style: const TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildSection(String title, List<Widget> tiles) {
    return SliverToBoxAdapter(child: Column(children: tiles));
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        Text(title, style: const TextStyle(color: Colors.white)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  SliverToBoxAdapter _buildLogoutButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: ElevatedButton(
        onPressed: () async {
          await context.read<AuthCubit>().logout();
          if (context.mounted) {
            context.go('/login');
          }
        },
        child: const Text("Logout"),
      ),
    );
  }
}

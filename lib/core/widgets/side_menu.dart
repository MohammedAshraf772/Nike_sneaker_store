import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nike_sneaker_store/features/cart/screens/cart_screen.dart';
import 'package:nike_sneaker_store/features/profile/presentation/screens/profile_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.card,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 10),

            const Text(
              "User",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 30),

            _item(context, Icons.person, "Profile", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }),

            _item(context, Icons.shopping_cart, "My Cart", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            }),

            _item(context, Icons.favorite, "Favorites", () {}),

            const Spacer(),

            _item(context, Icons.logout, "Logout", () {
              context.read<AuthCubit>().logout();
              Navigator.pop(context);
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,

      onTap: onTap,

      backgroundColor: AppColors.card,

      selectedItemColor: AppColors.primary,

      unselectedItemColor: Colors.grey,

      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),

        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

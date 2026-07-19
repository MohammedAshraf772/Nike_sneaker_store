import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';

class OnboardingBackground extends StatelessWidget {
  final Color accentColor;

  const OnboardingBackground({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 0.85,
          colors: [accentColor.withOpacity(0.3), AppColors.background],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF0066FF);
  static const Color primaryDark = Color(0xFF0052CC);

  // Dark Theme Colors
  static const Color background = Color(0xFF111111);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color card = Color(0xFF2A2A2A);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Text Dark
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFF555555);

  // Text Light
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF707070);
  static const Color lightTextHint = Color(0xFF9E9E9E);

  // Accent & Status
  static const Color accent = Color(0xFF0066FF);
  static const Color success = Color(0xFF2A9D8F);
  static const Color error = Color(0xFFE63946);

  // Misc
  static const Color divider = Color(0xFFE0E0E0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? background
        : lightBackground;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? surface
        : lightSurface;
  }

  static Color getCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? card : lightCard;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textPrimary
        : lightTextPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textSecondary
        : lightTextSecondary;
  }
}

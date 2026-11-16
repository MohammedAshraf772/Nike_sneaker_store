import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/custom_text_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Password',
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hint: '••••••••',
      icon: Icons.lock_outline,
      obscureText: _obscure,
      suffix: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility : Icons.visibility_off,
          color: AppColors.getTextSecondary(context),
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}

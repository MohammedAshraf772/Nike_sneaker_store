import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_button.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/custom_text_field.dart';

class ForgotPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final bool isSending;
  final VoidCallback onSendPressed;
  const ForgotPasswordForm({
    super.key,
    required this.emailController,
    required this.isSending,
    required this.onSendPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Enter your email to receive reset link',
          style: TextStyle(color: AppColors.getTextSecondary(context)),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: emailController,
          hint: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 30),
        AuthButton(
          label: 'Send Reset Link',
          isLoading: isSending,
          onPressed: onSendPressed,
        ),
      ],
    );
  }
}

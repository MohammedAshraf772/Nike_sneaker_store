import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
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

        const Text(
          "Enter your email to receive reset link",
          style: TextStyle(color: AppColors.white),
        ),

        const SizedBox(height: 20),

        CustomTextField(
          controller: emailController,
          label: "",
          hint: "Email",
          icon: Icons.email,
        ),

        const SizedBox(height: 30),

        GestureDetector(
          onTap: isSending ? null : onSendPressed,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child:
                  isSending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        "Send Reset Link",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }
}

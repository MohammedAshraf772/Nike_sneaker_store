import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_back_button.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_button.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_header.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_state_listener.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_switch_link.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/custom_text_field.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/password_field.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    context.read<AuthCubit>().register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthCubit, bool>(
      (cubit) => cubit.state is AuthLoading,
    );

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: AuthStateListener(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const AuthBackButton(),
                const SizedBox(height: 24),
                const AuthHeader(
                  title: 'Create\nAccount ✨',
                  subtitle: 'Sign up to start shopping',
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter Your Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'email@gmail.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                PasswordField(controller: _passwordController),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                ),
                const SizedBox(height: 32),
                AuthButton(
                  label: 'Create Account',
                  isLoading: isLoading,
                  onPressed: _register,
                ),
                const SizedBox(height: 24),
                AuthSwitchLink(
                  question: 'Already have an account?',
                  action: 'Login',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

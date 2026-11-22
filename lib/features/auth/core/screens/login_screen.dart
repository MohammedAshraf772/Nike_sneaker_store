import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';
import 'package:nike_sneaker_store/features/auth/core/screens/forgot_password_screen.dart';
import 'package:nike_sneaker_store/features/auth/core/screens/register_screen.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_button.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_header.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_state_listener.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/auth_switch_link.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/custom_text_field.dart';
import 'package:nike_sneaker_store/features/auth/core/widget/password_field.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
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
                const SizedBox(height: 60),
                Image.asset('assets/images/Vector.png', width: 170),
                const SizedBox(height: 24),
                const AuthHeader(
                  title: 'Welcome Back 👋',
                  subtitle: 'Sign in to continue shopping',
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'your@email.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                PasswordField(controller: _passwordController),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _open(const ForgotPasswordScreen()),
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AuthButton(
                  label: 'Sign In',
                  isLoading: isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: 24),
                AuthSwitchLink(
                  question: "Don't have an account?",
                  action: 'Sign Up',
                  onTap: () => _open(const RegisterScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

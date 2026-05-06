import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nike_sneaker_store/features/home/presentation/screens/home_screen.dart';

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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  /// 🔙 Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 📝 Header
                  const Text(
                    'Create\nAccount ✨',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sign up to start shopping',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 32),

                  _buildTextField(
                    controller: _nameController,
                    label: "Full Name",
                    hint: "Mohamed Ashraf",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    hint: "email@gmail.com",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    hint: "********",
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffix: GestureDetector(
                      onTap:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    hint: "********",
                    icon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    suffix: GestureDetector(
                      onTap:
                          () => setState(
                            () =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                          ),
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// 🚀 Register Button
                  GestureDetector(
                    onTap:
                        isLoading
                            ? null
                            : () {
                              context.read<AuthCubit>().register(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                confirmPassword:
                                    _confirmPasswordController.text.trim(),
                              );
                            },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 56,
                      decoration: BoxDecoration(
                        color:
                            isLoading
                                ? AppColors.primary.withOpacity(0.6)
                                : AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 🔗 Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textHint),
              prefixIcon: Icon(icon, color: AppColors.textHint),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}

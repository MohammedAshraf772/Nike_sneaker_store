import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/data/datsource/auth_remote_datasource.dart';
import 'package:nike_sneaker_store/features/auth/data/repository/auth_repository_impl.dart';
import 'package:nike_sneaker_store/features/auth/domain/usecses/forgot_password.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:nike_sneaker_store/features/auth/presentation/widget/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ForgotPasswordCubit(
            ForgotPassword(
              AuthRepositoryImpl(
                AuthRemoteDataSource(
                  FirebaseAuth.instance,
                  FirebaseFirestore.instance,
                ),
              ),
            ),
          ),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "If this email is registered, a reset link has been sent",
                  ),
                ),
              );
              Navigator.pop(context);
            } else if (state is ForgotPasswordError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return ForgotPasswordForm(
              emailController: emailController,
              isSending: state is ForgotPasswordSending,
              onSendPressed: () {
                context.read<ForgotPasswordCubit>().sendResetLink(
                  emailController.text,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

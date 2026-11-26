import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/features/auth/domain/repository/auth_repository.dart';
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
            ForgotPassword(context.read<AuthRepository>()),
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
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state is ForgotPasswordSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'If this email is registered, a reset link has been sent',
          ),
        ),
      );
      Navigator.pop(context);
    } else if (state is ForgotPasswordError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSending = context.select<ForgotPasswordCubit, bool>(
      (cubit) => cubit.state is ForgotPasswordSending,
    );

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(color: AppColors.getTextPrimary(context)),
        ),
        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),
        backgroundColor: AppColors.getBackground(context),
      ),
      body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: _onStateChanged,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ForgotPasswordForm(
            emailController: _emailController,
            isSending: isSending,
            onSendPressed:
                () => context.read<ForgotPasswordCubit>().sendResetLink(
                  _emailController.text,
                ),
          ),
        ),
      ),
    );
  }
}

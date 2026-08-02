import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/auth/domain/usecses/forgot_password.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPassword) : super(ForgotPasswordInitial());

  final ForgotPassword _forgotPassword;

  Future<void> sendResetLink(String email) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
      emit(const ForgotPasswordError('Please enter a valid email address'));
      return;
    }

    emit(ForgotPasswordSending());

    try {
      await _forgotPassword(trimmedEmail);
      emit(ForgotPasswordSent());
    } on FirebaseAuthException catch (e) {
      emit(ForgotPasswordError(e.message ?? 'Something went wrong'));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
}

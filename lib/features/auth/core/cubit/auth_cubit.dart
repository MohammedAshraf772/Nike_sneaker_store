import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    await Future.delayed(const Duration(seconds: 1));

    if (email == "test@test.com" && password == "123456") {
      emit(AuthAuthenticated(name: "Ahmed", email: email));
    } else {
      emit(AuthError("Invalid email or password"));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());

    await Future.delayed(const Duration(seconds: 1));

    emit(AuthAuthenticated(name: "New User", email: email));
  }

  Future<void> logout() async {
    emit(AuthUnauthenticated());
  }
}

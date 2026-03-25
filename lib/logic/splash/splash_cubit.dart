import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/storage_service.dart';

enum SplashStatus { loading, authenticated, unauthenticated }

class SplashCubit extends Cubit<SplashStatus> {
  SplashCubit() : super(SplashStatus.loading);

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = await StorageService.isLoggedIn();
    if (loggedIn) {
      emit(SplashStatus.authenticated);
    } else {
      emit(SplashStatus.unauthenticated);
    }
  }
}

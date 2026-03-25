import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_sneaker_store/core/contants/app_stringes.dart';
import 'package:nike_sneaker_store/presentation/screens/home/home_screen.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppStrings.splashRoute,
    routes: [
      GoRoute(
        path: AppStrings.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppStrings.onboardingRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder:
            (context, state) => BlocProvider.value(
              value: context.read<AuthCubit>(),
              child: const LoginScreen(),
            ),
      ),
      GoRoute(
        path: AppStrings.homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}

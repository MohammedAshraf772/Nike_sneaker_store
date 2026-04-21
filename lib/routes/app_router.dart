import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_sneaker_store/core/contants/app_stringes.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_cubit.dart';
import 'package:nike_sneaker_store/features/auth/core/screens/login_screen.dart';
import 'package:nike_sneaker_store/features/home/presentation/screens/home_screen.dart';
import 'package:nike_sneaker_store/features/onboarding/onboarding_screen.dart';
import 'package:nike_sneaker_store/features/spash/splash_screen.dart';

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

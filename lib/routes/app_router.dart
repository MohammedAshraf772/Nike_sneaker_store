import 'package:go_router/go_router.dart';
import 'package:nike_sneaker_store/core/contants/app_stringes.dart';
import 'package:nike_sneaker_store/presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';

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
        path: AppStrings.homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppStrings.cartRoute,
        builder: (context, state) => const CartScreen(),
      ),
    ],
  );
}

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/features/spash/splash_screen.dart';
import '../features/auth/core/screens/login_screen.dart';
import '../features/onboarding/screen/onboarding_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/favourates/presentation/screens/favorites_screen.dart';
import '../features/cart/screens/cart_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No screen found for "${state.uri}"'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

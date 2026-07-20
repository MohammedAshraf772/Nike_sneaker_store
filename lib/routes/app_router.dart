import 'package:go_router/go_router.dart';
import 'package:nike_sneaker_store/features/spash/splash_screen.dart';
import '../features/auth/core/screens/login_screen.dart';
import '../features/onboarding/screen/onboarding_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';

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
    ],
  );
}

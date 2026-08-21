import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/logic/splash/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..init(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashStatus>(
      listener: (context, status) {
        if (status == SplashStatus.authenticated) {
          context.go('/home');
        } else if (status == SplashStatus.unauthenticated) {
          context.go('/onboarding');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "nike_logo",
                    child: Image.asset('assets/images/Vector.png', width: 170),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "NIKE SNEAKER STORE",
                    style: TextStyle(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

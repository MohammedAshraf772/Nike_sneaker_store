import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/contants/app_text_styles.dart';
import 'package:nike_sneaker_store/features/onboarding/data/onboarding_repository.dart';
import 'package:nike_sneaker_store/features/onboarding/widget/onboarding_background.dart';
import 'package:nike_sneaker_store/features/onboarding/widget/onboarding_bottom_controls.dart';
import 'package:nike_sneaker_store/features/onboarding/widget/onboarding_page_content.dart';

import '../../../logic/onboarding/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: OnboardingRepository().getOnboardingData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: AppColors.primary,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
          );
        }

        final data = snapshot.data ?? [];

        return BlocProvider(
          create: (_) => OnboardingCubit(totalPages: data.length),
          child: _OnboardingView(data: data),
        );
      },
    );
  }
}

class _OnboardingView extends StatefulWidget {
  final List<Map<String, String>> data;

  const _OnboardingView({required this.data});

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  final List<Color> _pageColors = const [
    Color(0xFFE63946),
    Color(0xFF457B9D),
    Color(0xFF2A9D8F),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<OnboardingCubit>().changePage(index);
    _animController.reset();
    _animController.forward();
  }

  void _goNext(OnboardingState state) {
    if (state.isLastPage) {
      context.go('/login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final accentColor = _pageColors[state.currentPage % _pageColors.length];

        return Scaffold(
          backgroundColor: AppColors.primary,
          body: Stack(
            children: [
              OnboardingBackground(accentColor: accentColor),

              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(
                    data: widget.data[index],
                    accentColor: accentColor,
                    fadeAnim: _fadeAnim,
                    slideAnim: _slideAnim,
                    animController: _animController,
                  );
                },
              ),

              Positioned(
                top: 56,
                right: 24,
                child: GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 48,
                left: 28,
                right: 28,
                child: OnboardingBottomControls(
                  state: state,
                  totalPages: widget.data.length,
                  accentColor: accentColor,
                  fadeAnim: _fadeAnim,
                  slideAnim: _slideAnim,
                  onNextPressed: () => _goNext(state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/contants/app_stringes.dart';
import 'package:nike_sneaker_store/core/contants/app_text_styles.dart';

import '../../../logic/onboarding/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

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
      context.go(AppStrings.homeRoute);
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
        final accentColor = _pageColors[state.currentPage];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 0.85,
                    colors: [
                      accentColor.withOpacity(0.3),
                      AppColors.background,
                    ],
                  ),
                ),
              ),

              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: AppStrings.onboardingData.length,
                itemBuilder: (context, index) {
                  final data = AppStrings.onboardingData[index];
                  return _buildPage(data, accentColor);
                },
              ),

              Positioned(
                top: 56,
                right: 24,
                child: GestureDetector(
                  onTap: () => context.go(AppStrings.homeRoute),
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
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(
                            AppStrings.onboardingData.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 6),
                              width: i == state.currentPage ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                    i == state.currentPage
                                        ? accentColor
                                        : AppColors.textHint,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '0${state.currentPage + 1}',
                                    style: AppTextStyles.headingLarge.copyWith(
                                      color: accentColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' / 0${AppStrings.onboardingData.length}',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () => _goNext(state),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.45),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  state.isLastPage
                                      ? Icons.check_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: AppColors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPage(Map<String, String> data, Color accentColor) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 110),

          FadeTransition(
            opacity: _fadeAnim,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentColor.withOpacity(0.35)),
              ),
              child: Text(
                data['tag']!,
                style: AppTextStyles.labelSmall.copyWith(
                  color: accentColor,
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          SlideTransition(
            position: _slideAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Text(data['title']!, style: AppTextStyles.displayLarge),
            ),
          ),
          const SizedBox(height: 14),

          FadeTransition(
            opacity: _fadeAnim,
            child: Text(
              data['subtitle']!,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
            ),
          ),

          const SizedBox(height: 36),

          Expanded(
            child: Center(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animController,
                    curve: Curves.easeOut,
                  ),
                ),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Image.network(
                    data['image']!,
                    height: size.height * 0.3,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: size.height * 0.3,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                    errorBuilder:
                        (_, __, ___) => Icon(
                          Icons.image_not_supported_outlined,
                          size: 100,
                          color: accentColor.withOpacity(0.4),
                        ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 130),
        ],
      ),
    );
  }
}

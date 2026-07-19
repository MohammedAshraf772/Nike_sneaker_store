import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/contants/app_stringes.dart';
import 'package:nike_sneaker_store/core/contants/app_text_styles.dart';
import '../../../logic/onboarding/onboarding_cubit.dart';

class OnboardingBottomControls extends StatelessWidget {
  final OnboardingState state;
  final Color accentColor;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final VoidCallback onNextPressed;

  const OnboardingBottomControls({
    super.key,
    required this.state,
    required this.accentColor,
    required this.fadeAnim,
    required this.slideAnim,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Indicators
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

            // Bottom Counter and Next Button Row
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
                        text: ' / 0${AppStrings.onboardingData.length}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onNextPressed,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'package:nike_sneaker_store/core/contants/app_text_styles.dart';
import 'animated_step_wrapper.dart';

class OnboardingPageContent extends StatelessWidget {
  final Map<String, String> data;
  final Color accentColor;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final AnimationController animController;

  const OnboardingPageContent({
    super.key,
    required this.data,
    required this.accentColor,
    required this.fadeAnim,
    required this.slideAnim,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSlideAnim = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeOut));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 110),

          // Tag Badge
          AnimatedStepWrapper(
            fadeAnim: fadeAnim,
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

          // Title
          AnimatedStepWrapper(
            fadeAnim: fadeAnim,
            slideAnim: slideAnim,
            child: Text(data['title']!, style: AppTextStyles.displayLarge),
          ),
          const SizedBox(height: 14),

          // Subtitle
          AnimatedStepWrapper(
            fadeAnim: fadeAnim,
            child: Text(
              data['subtitle']!,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
            ),
          ),
          const SizedBox(height: 36),

          // Image View
          Expanded(
            child: Center(
              child: AnimatedStepWrapper(
                fadeAnim: fadeAnim,
                slideAnim: imageSlideAnim,
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
          const SizedBox(height: 130),
        ],
      ),
    );
  }
}

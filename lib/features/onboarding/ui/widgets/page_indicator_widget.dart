import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Page indicator widget for onboarding
class PageIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicatorWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => IndicatorDotWidget(
          isActive: index == currentPage,
        ),
      ),
    );
  }
}

/// Individual indicator dot widget
class IndicatorDotWidget extends StatelessWidget {
  final bool isActive;

  const IndicatorDotWidget({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.onboardingIndicatorSpacing,
      ),
      width: isActive ? 24.0 : AppDimensions.onboardingIndicatorSize,
      height: AppDimensions.onboardingIndicatorSize,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
    );
  }
}

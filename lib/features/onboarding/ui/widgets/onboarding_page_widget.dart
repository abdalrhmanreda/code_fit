import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Individual onboarding page widget
class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXLarge),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

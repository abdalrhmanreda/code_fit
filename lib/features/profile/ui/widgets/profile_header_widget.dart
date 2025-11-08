import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Profile header widget with avatar and name
class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final int level;
  final String language;

  const ProfileHeaderWidget({
    Key? key,
    required this.userName,
    required this.level,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.textWhite,
            child: Icon(
              Icons.person,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Text(
            language == 'ar' ? 'المستوى $level' : 'Level $level',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}

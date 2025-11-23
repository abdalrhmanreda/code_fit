import 'package:flutter/material.dart';

import '../../../../config/colors/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/achievement_model.dart';

/// Achievement card widget
class AchievementCardWidget extends StatelessWidget {
  final AchievementModel achievement;
  final String language;

  const AchievementCardWidget({
    Key? key,
    required this.achievement,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginMedium),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            if (achievement.isUnlocked)
              BoxShadow(
                color: Color(achievement.badgeColorCode).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Material(
          elevation: achievement.isUnlocked ? 2 : 1,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          color: achievement.isUnlocked ? Colors.white : Colors.grey.shade50,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            onTap: achievement.isUnlocked ? () {} : null,
            child: Opacity(
              opacity: achievement.isUnlocked ? 1.0 : 0.6,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Row(
                  children: [
                    AchievementBadgeWidget(
                      badgeType: achievement.badgeType,
                      isUnlocked: achievement.isUnlocked,
                    ),
                    const SizedBox(width: AppDimensions.spaceMedium),
                    Expanded(
                      child: AchievementInfoWidget(
                        achievement: achievement,
                        language: language,
                      ),
                    ),
                    if (achievement.isUnlocked)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: AppDimensions.iconMedium,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Achievement badge widget
class AchievementBadgeWidget extends StatelessWidget {
  final String badgeType;
  final bool isUnlocked;

  const AchievementBadgeWidget({
    Key? key,
    required this.badgeType,
    required this.isUnlocked,
  }) : super(key: key);

  Color _getBadgeColor() {
    switch (badgeType.toLowerCase()) {
      case 'bronze':
        return AppColors.badgeBronze;
      case 'silver':
        return AppColors.badgeSilver;
      case 'gold':
        return AppColors.badgeGold;
      case 'platinum':
        return AppColors.badgePlatinum;
      default:
        return AppColors.badgeBronze;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.badgeLarge,
      height: AppDimensions.badgeLarge,
      decoration: BoxDecoration(
        gradient: isUnlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_getBadgeColor(), _getBadgeColor().withOpacity(0.7)],
              )
            : LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
        shape: BoxShape.circle,
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: _getBadgeColor().withOpacity(0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(
          color: isUnlocked
              ? _getBadgeColor().withOpacity(0.3)
              : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.emoji_events,
        color: isUnlocked ? AppColors.textWhite : Colors.grey.shade500,
        size: 32,
      ),
    );
  }
}

/// Achievement info widget
class AchievementInfoWidget extends StatelessWidget {
  final AchievementModel achievement;
  final String language;

  const AchievementInfoWidget({
    Key? key,
    required this.achievement,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          achievement.getTitle(language),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.spaceXSmall),
        Text(
          achievement.getDescription(language),
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

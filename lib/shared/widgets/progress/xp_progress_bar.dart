import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_curves.dart';

/// XP progress bar widget showing level progress
class XpProgressBar extends StatelessWidget {
  final int currentXp;
  final int xpForNextLevel;
  final int level;

  const XpProgressBar({
    Key? key,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = xpForNextLevel > 0
        ? (currentXp / xpForNextLevel).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.xpBar.withOpacity(0.1),
            AppColors.xpBar.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.xpGradient,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.xpBar.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Level $level',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSmall),
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.xpBar,
                    size: 20,
                  ),
                ],
              ),
              Text(
                '$currentXp / $xpForNextLevel XP',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.progressIncomplete,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: AppDurations.xpBarFill,
                curve: AppCurves.xpBarFill,
                width: MediaQuery.of(context).size.width * progress * 0.85,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.xpGradient,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.xpBar.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Text(
            '${(progress * 100).toInt()}% to next level',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

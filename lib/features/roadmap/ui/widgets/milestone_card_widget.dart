import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/milestone_model.dart';

/// Milestone card widget
class MilestoneCardWidget extends StatelessWidget {
  final MilestoneModel milestone;
  final String language;

  const MilestoneCardWidget({
    Key? key,
    required this.milestone,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginMedium),
      child: Material(
        elevation: milestone.isCompleted ? 3 : 2,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        shadowColor: milestone.isCompleted 
            ? AppColors.success.withOpacity(0.3) 
            : Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: milestone.isLocked ? null : () {
            // TODO: Navigate to milestone detail or show checkpoints
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              gradient: milestone.isCompleted
                  ? LinearGradient(
                      colors: [
                        AppColors.success.withOpacity(0.1),
                        AppColors.success.withOpacity(0.05),
                      ],
                    )
                  : null,
              border: Border.all(
                color: milestone.isCompleted
                    ? AppColors.success.withOpacity(0.3)
                    : milestone.isLocked
                        ? AppColors.border
                        : AppColors.primary.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  children: [
                    MilestoneIconWidget(
                      isCompleted: milestone.isCompleted,
                      isLocked: milestone.isLocked,
                    ),
                    const SizedBox(width: AppDimensions.spaceMedium),
                    Expanded(
                      child: MilestoneTitleWidget(
                        milestone: milestone,
                        language: language,
                      ),
                    ),
                    MilestoneStatusWidget(
                      isCompleted: milestone.isCompleted,
                      isLocked: milestone.isLocked,
                      progress: milestone.progress,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMedium),
                MilestoneProgressBarWidget(
                  progress: milestone.progress,
                ),
                const SizedBox(height: AppDimensions.spaceSmall),
                MilestoneStatsWidget(
                  milestone: milestone,
                  language: language,
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

/// Milestone icon widget
class MilestoneIconWidget extends StatelessWidget {
  final bool isCompleted;
  final bool isLocked;

  const MilestoneIconWidget({
    Key? key,
    required this.isCompleted,
    required this.isLocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withOpacity(0.2)
            : isLocked
                ? AppColors.textSecondary.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Icon(
        isCompleted
            ? Icons.check_circle
            : isLocked
                ? Icons.lock
                : Icons.flag,
        color: isCompleted
            ? AppColors.success
            : isLocked
                ? AppColors.textSecondary
                : AppColors.primary,
        size: AppDimensions.iconMedium,
      ),
    );
  }
}

/// Milestone title widget
class MilestoneTitleWidget extends StatelessWidget {
  final MilestoneModel milestone;
  final String language;

  const MilestoneTitleWidget({
    Key? key,
    required this.milestone,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          milestone.getTitle(language),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: milestone.isLocked 
                ? AppColors.textSecondary 
                : AppColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spaceXSmall),
        Text(
          milestone.getDescription(language),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Milestone status widget
class MilestoneStatusWidget extends StatelessWidget {
  final bool isCompleted;
  final bool isLocked;
  final double progress;

  const MilestoneStatusWidget({
    Key? key,
    required this.isCompleted,
    required this.isLocked,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.success,
        size: 24,
      );
    } else if (isLocked) {
      return const Icon(
        Icons.lock,
        color: AppColors.textSecondary,
        size: 24,
      );
    } else {
      final percentage = (progress * 100).toInt();
      return Text(
        '$percentage%',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      );
    }
  }
}

/// Milestone progress bar widget
class MilestoneProgressBarWidget extends StatelessWidget {
  final double progress;

  const MilestoneProgressBarWidget({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: AppColors.progressIncomplete,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        minHeight: 8,
      ),
    );
  }
}

/// Milestone stats widget
class MilestoneStatsWidget extends StatelessWidget {
  final MilestoneModel milestone;
  final String language;

  const MilestoneStatsWidget({
    Key? key,
    required this.milestone,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spaceXSmall),
        Text(
          '${milestone.completedCheckpointsCount}/${milestone.checkpoints.length} ${language == 'ar' ? 'نقاط' : 'checkpoints'}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMedium),
        const Icon(
          Icons.star_outline,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spaceXSmall),
        Text(
          '${milestone.totalXp} XP',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

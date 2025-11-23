import 'package:flutter/material.dart';

import '../../../../config/colors/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/phase_model.dart';
import '../widgets/milestone_card_widget.dart';
import '../widgets/phase_detail_header_widget.dart';

/// Phase detail screen showing milestones for a specific phase
class PhaseDetailScreen extends StatefulWidget {
  final PhaseModel phase;
  final String language;

  const PhaseDetailScreen({
    Key? key,
    required this.phase,
    required this.language,
  }) : super(key: key);

  @override
  State<PhaseDetailScreen> createState() => _PhaseDetailScreenState();
}

class _PhaseDetailScreenState extends State<PhaseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phase.getTitle(widget.language)),
        backgroundColor: Color(widget.phase.colorCode),
        foregroundColor: AppColors.textWhite,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhaseDetailHeaderWidget(
                phase: widget.phase,
                language: widget.language,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              PhaseProgressInfoWidget(
                phase: widget.phase,
                language: widget.language,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              Text(
                widget.language == 'ar'
                    ? AppStrings.milestonesAr
                    : AppStrings.milestones,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              if (widget.phase.milestones.isEmpty)
                EmptyMilestonesWidget(language: widget.language)
              else
                ...widget.phase.milestones.map(
                  (milestone) => MilestoneCardWidget(
                    milestone: milestone,
                    language: widget.language,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Phase progress info widget
class PhaseProgressInfoWidget extends StatelessWidget {
  final PhaseModel phase;
  final String language;

  const PhaseProgressInfoWidget({
    Key? key,
    required this.phase,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (phase.progress * 100).toInt();
    final completedMilestones = phase.milestones
        .where((m) => m.isCompleted)
        .length;
    final totalMilestones = phase.milestones.length;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(phase.colorCode).withOpacity(0.2),
            Color(phase.colorCode).withOpacity(0.1),
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
              Text(
                language == 'ar' ? AppStrings.progressAr : AppStrings.progress,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(phase.colorCode),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            child: LinearProgressIndicator(
              value: phase.progress,
              backgroundColor: AppColors.progressIncomplete,
              valueColor: AlwaysStoppedAnimation<Color>(Color(phase.colorCode)),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProgressStatWidget(
                label: language == 'ar' ? 'المعالم' : 'Milestones',
                value: '$completedMilestones / $totalMilestones',
                icon: Icons.flag,
              ),
              ProgressStatWidget(
                label: language == 'ar' ? 'نقاط التفتيش' : 'Checkpoints',
                value:
                    '${phase.completedCheckpoints} / ${phase.totalCheckpoints}',
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Progress stat widget
class ProgressStatWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProgressStatWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.spaceSmall),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

/// Empty milestones widget
class EmptyMilestonesWidget extends StatelessWidget {
  final String language;

  const EmptyMilestonesWidget({Key? key, required this.language})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        child: Column(
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.spaceMedium),
            Text(
              language == 'ar'
                  ? AppStrings.noMilestonesAr
                  : AppStrings.noMilestones,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

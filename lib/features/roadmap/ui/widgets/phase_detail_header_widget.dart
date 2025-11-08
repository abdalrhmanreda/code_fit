import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/phase_model.dart';

/// Phase detail header widget
class PhaseDetailHeaderWidget extends StatelessWidget {
  final PhaseModel phase;
  final String language;

  const PhaseDetailHeaderWidget({
    Key? key,
    required this.phase,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(phase.colorCode),
            Color(phase.colorCode).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        children: [
          PhaseHeaderIconWidget(
            iconName: phase.iconName,
          ),
          const SizedBox(width: AppDimensions.spaceMedium),
          Expanded(
            child: PhaseHeaderInfoWidget(
              phase: phase,
              language: language,
            ),
          ),
        ],
      ),
    );
  }
}

/// Phase header icon widget
class PhaseHeaderIconWidget extends StatelessWidget {
  final String iconName;

  const PhaseHeaderIconWidget({
    Key? key,
    required this.iconName,
  }) : super(key: key);

  IconData _getIconData() {
    switch (iconName) {
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'account_tree':
        return Icons.account_tree;
      case 'architecture':
        return Icons.architecture;
      case 'storage':
        return Icons.storage;
      case 'psychology':
        return Icons.psychology;
      case 'workspace_premium':
        return Icons.workspace_premium;
      default:
        return Icons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Icon(
        _getIconData(),
        color: AppColors.textWhite,
        size: 40,
      ),
    );
  }
}

/// Phase header info widget
class PhaseHeaderInfoWidget extends StatelessWidget {
  final PhaseModel phase;
  final String language;

  const PhaseHeaderInfoWidget({
    Key? key,
    required this.phase,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          phase.getTitle(language),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSmall),
        Text(
          phase.getDescription(language),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textWhite,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/phase_model.dart';
import '../screens/phase_detail_screen.dart';

/// Phase card widget displaying a learning phase
class PhaseCardWidget extends StatelessWidget {
  final PhaseModel phase;
  final String language;

  const PhaseCardWidget({
    Key? key,
    required this.phase,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginMedium),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        shadowColor: Color(phase.colorCode).withOpacity(0.3),
        child: InkWell(
          onTap: () {
            // Navigate to phase details
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PhaseDetailScreen(
                  phase: phase,
                  language: language,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(phase.colorCode).withOpacity(0.15),
                  Color(phase.colorCode).withOpacity(0.08),
                  Colors.white,
                ],
              ),
              border: Border.all(
                color: Color(phase.colorCode).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Row(
                children: [
                  PhaseIconWidget(
                    iconName: phase.iconName,
                    color: Color(phase.colorCode),
                  ),
                  const SizedBox(width: AppDimensions.spaceMedium),
                  Expanded(
                    child: PhaseInfoWidget(
                      phase: phase,
                      language: language,
                    ),
                  ),
                  PhaseProgressWidget(progress: phase.progress),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Phase icon widget
class PhaseIconWidget extends StatelessWidget {
  final String iconName;
  final Color color;

  const PhaseIconWidget({
    Key? key,
    required this.iconName,
    required this.color,
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
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        _getIconData(),
        color: color,
        size: 36,
      ),
    );
  }
}

/// Phase info widget
class PhaseInfoWidget extends StatelessWidget {
  final PhaseModel phase;
  final String language;

  const PhaseInfoWidget({
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spaceXSmall),
        Text(
          phase.getDescription(language),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Phase progress widget
class PhaseProgressWidget extends StatelessWidget {
  final double progress;

  const PhaseProgressWidget({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();
    
    return Column(
      children: [
        Text(
          '$percentage%',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXSmall),
        if (progress == 1.0)
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
      ],
    );
  }
}

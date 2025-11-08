import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/progress/xp_progress_bar.dart';
import '../../data/models/phase_model.dart';
import '../widgets/phase_card_widget.dart';
import '../widgets/roadmap_header_widget.dart';

/// Roadmap screen showing all learning phases
class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({Key? key}) : super(key: key);

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late List<PhaseModel> _phases;
  int _userXP = 0;
  int _userLevel = 1;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadPhases();
  }

  Future<void> _loadUserData() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _userXP = storage.getUserXP();
      _userLevel = storage.getUserLevel();
      _language = storage.getLanguage();
    });
  }

  void _loadPhases() {
    // Load hardcoded phases for now
    _phases = _getHardcodedPhases();
  }

  List<PhaseModel> _getHardcodedPhases() {
    return [
      PhaseModel(
        id: 'phase_1',
        titleEn: AppStrings.phase1Title,
        titleAr: AppStrings.phase1TitleAr,
        descriptionEn: AppStrings.phase1Desc,
        descriptionAr: AppStrings.phase1DescAr,
        order: 1,
        milestones: const [],
        iconName: 'rocket_launch',
        colorCode: AppColors.phase1.value,
      ),
      PhaseModel(
        id: 'phase_2',
        titleEn: AppStrings.phase2Title,
        titleAr: AppStrings.phase2TitleAr,
        descriptionEn: AppStrings.phase2Desc,
        descriptionAr: AppStrings.phase2DescAr,
        order: 2,
        milestones: const [],
        iconName: 'account_tree',
        colorCode: AppColors.phase2.value,
      ),
      PhaseModel(
        id: 'phase_3',
        titleEn: AppStrings.phase3Title,
        titleAr: AppStrings.phase3TitleAr,
        descriptionEn: AppStrings.phase3Desc,
        descriptionAr: AppStrings.phase3DescAr,
        order: 3,
        milestones: const [],
        iconName: 'architecture',
        colorCode: AppColors.phase3.value,
      ),
      PhaseModel(
        id: 'phase_4',
        titleEn: AppStrings.phase4Title,
        titleAr: AppStrings.phase4TitleAr,
        descriptionEn: AppStrings.phase4Desc,
        descriptionAr: AppStrings.phase4DescAr,
        order: 4,
        milestones: const [],
        iconName: 'storage',
        colorCode: AppColors.phase4.value,
      ),
      PhaseModel(
        id: 'phase_5',
        titleEn: AppStrings.phase5Title,
        titleAr: AppStrings.phase5TitleAr,
        descriptionEn: AppStrings.phase5Desc,
        descriptionAr: AppStrings.phase5DescAr,
        order: 5,
        milestones: const [],
        iconName: 'psychology',
        colorCode: AppColors.phase5.value,
      ),
      PhaseModel(
        id: 'phase_6',
        titleEn: AppStrings.phase6Title,
        titleAr: AppStrings.phase6TitleAr,
        descriptionEn: AppStrings.phase6Desc,
        descriptionAr: AppStrings.phase6DescAr,
        order: 6,
        milestones: const [],
        iconName: 'workspace_premium',
        colorCode: AppColors.phase6.value,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_language == 'ar' ? AppStrings.roadmapAr : AppStrings.roadmap),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoadmapHeaderWidget(
                userName: 'Learner',
                level: _userLevel,
                language: _language,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              XpProgressBar(
                currentXp: _userXP % 100,
                xpForNextLevel: 100,
                level: _userLevel,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              Text(
                _language == 'ar' ? 'المراحل' : 'Phases',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              ..._phases.map((phase) => PhaseCardWidget(
                    phase: phase,
                    language: _language,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

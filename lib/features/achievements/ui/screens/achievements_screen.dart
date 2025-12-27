import 'package:flutter/material.dart';

import '../../../../config/colors/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/achievement_model.dart';
import '../widgets/achievement_card_widget.dart';

/// Achievements screen showing unlocked and locked achievements
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late List<AchievementModel> _achievements;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _language = storage.getLanguage();
      _achievements = _getHardcodedAchievements();
    });
  }

  List<AchievementModel> _getHardcodedAchievements() {
    return [
      const AchievementModel(
        id: 'first_step',
        titleEn: 'First Step',
        titleAr: 'الخطوة الأولى',
        descriptionEn: 'Complete your first checkpoint',
        descriptionAr: 'أكمل أول نقطة تفتيش',
        iconName: 'star',
        badgeType: 'bronze',
        requiredValue: 1,
        isUnlocked: true,
      ),
      const AchievementModel(
        id: 'week_warrior',
        titleEn: 'Week Warrior',
        titleAr: 'محارب الأسبوع',
        descriptionEn: 'Maintain a 7-day streak',
        descriptionAr: 'حافظ على سلسلة 7 أيام',
        iconName: 'fire',
        badgeType: 'silver',
        requiredValue: 7,
        isUnlocked: false,
      ),
      const AchievementModel(
        id: 'phase_master',
        titleEn: 'Phase Master',
        titleAr: 'سيد المرحلة',
        descriptionEn: 'Complete an entire phase',
        descriptionAr: 'أكمل مرحلة كاملة',
        iconName: 'trophy',
        badgeType: 'gold',
        requiredValue: 1,
        isUnlocked: false,
      ),
      const AchievementModel(
        id: 'legendary',
        titleEn: 'Legendary Coder',
        titleAr: 'مبرمج أسطوري',
        descriptionEn: 'Reach level 50',
        descriptionAr: 'اوصل للمستوى 50',
        iconName: 'medal',
        badgeType: 'platinum',
        requiredValue: 50,
        isUnlocked: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unlockedAchievements = _achievements
        .where((a) => a.isUnlocked)
        .toList();
    final lockedAchievements = _achievements
        .where((a) => !a.isUnlocked)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _language == 'ar'
              ? AppStrings.achievementsAr
              : AppStrings.achievements,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AchievementsSummaryWidget(
                totalAchievements: _achievements.length,
                unlockedCount: unlockedAchievements.length,
                language: _language,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              if (unlockedAchievements.isNotEmpty) ...[
                Text(
                  _language == 'ar' ? 'تم الفتح' : 'Unlocked',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMedium),
                ...unlockedAchievements.map(
                  (achievement) => AchievementCardWidget(
                    achievement: achievement,
                    language: _language,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLarge),
              ],
              Text(
                _language == 'ar' ? 'مقفل' : 'Locked',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              ...lockedAchievements.map(
                (achievement) => AchievementCardWidget(
                  achievement: achievement,
                  language: _language,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Achievements summary widget
class AchievementsSummaryWidget extends StatelessWidget {
  final int totalAchievements;
  final int unlockedCount;
  final String language;

  const AchievementsSummaryWidget({
    Key? key,
    required this.totalAchievements,
    required this.unlockedCount,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = totalAchievements > 0
        ? unlockedCount / totalAchievements
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.motivationalGradient),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Text(
            language == 'ar' ? 'إنجازاتك' : 'Your Achievements',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Text(
            '$unlockedCount / $totalAchievements',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.textWhite.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.textWhite,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

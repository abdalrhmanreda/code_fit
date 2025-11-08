import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/xp_calculator.dart';
import '../../../../core/utils/streak_calculator.dart';
import '../widgets/profile_stat_widget.dart';
import '../widgets/profile_header_widget.dart';

/// Profile screen showing user stats and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Learner';
  int _userXP = 0;
  int _userLevel = 1;
  int _currentStreak = 0;
  String _language = 'en';
  List<DateTime> _activityDates = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _userName = storage.getUserName();
      _userXP = storage.getUserXP();
      _userLevel = XpCalculator.calculateLevel(_userXP);
      _language = storage.getLanguage();
      _activityDates = storage.getActivityDates();
      _currentStreak = StreakCalculator.calculateStreak(_activityDates);
    });
  }

  Future<void> _toggleLanguage() async {
    final storage = await StorageService.getInstance();
    final newLanguage = _language == 'en' ? 'ar' : 'en';
    await storage.saveLanguage(newLanguage);
    setState(() {
      _language = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _language == 'ar' ? AppStrings.profileAr : AppStrings.profile,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeaderWidget(
                userName: _userName,
                level: _userLevel,
                language: _language,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              ProfileStatsGridWidget(
                xp: _userXP,
                level: _userLevel,
                streak: _currentStreak,
                language: _language,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              Text(
                _language == 'ar' ? 'إعدادات' : 'Settings',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              SettingsListWidget(language: _language),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profile stats grid widget
class ProfileStatsGridWidget extends StatelessWidget {
  final int xp;
  final int level;
  final int streak;
  final String language;

  const ProfileStatsGridWidget({
    Key? key,
    required this.xp,
    required this.level,
    required this.streak,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProfileStatWidget(
            title: language == 'ar' ? AppStrings.xpAr : AppStrings.xp,
            value: xp.toString(),
            icon: Icons.auto_awesome,
            color: AppColors.xpBar,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMedium),
        Expanded(
          child: ProfileStatWidget(
            title: language == 'ar' ? AppStrings.levelAr : AppStrings.level,
            value: level.toString(),
            icon: Icons.trending_up,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMedium),
        Expanded(
          child: ProfileStatWidget(
            title: language == 'ar' ? AppStrings.streakAr : AppStrings.streak,
            value: streak.toString(),
            icon: Icons.local_fire_department,
            color: AppColors.streakFlame,
          ),
        ),
      ],
    );
  }
}

/// Settings list widget
class SettingsListWidget extends StatelessWidget {
  final String language;

  const SettingsListWidget({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsItemWidget(
          icon: Icons.notifications,
          title: language == 'ar' ? AppStrings.notificationsAr : AppStrings.notifications,
          onTap: () {},
        ),
        SettingsItemWidget(
          icon: Icons.palette,
          title: language == 'ar' ? AppStrings.themeAr : AppStrings.theme,
          onTap: () {},
        ),
        SettingsItemWidget(
          icon: Icons.info,
          title: language == 'ar' ? AppStrings.aboutAr : AppStrings.about,
          onTap: () {},
        ),
      ],
    );
  }
}

/// Settings item widget
class SettingsItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsItemWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

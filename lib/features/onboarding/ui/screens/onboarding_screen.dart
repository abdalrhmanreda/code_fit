import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/storage_service.dart';
import '../../../home/ui/screens/home_screen.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/page_indicator_widget.dart';

/// Onboarding screen with multiple pages
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    final storage = await StorageService.getInstance();
    await storage.setOnboardingComplete(true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeaderWidget(onSkip: _skipOnboarding),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  OnboardingPageWidget(
                    title: AppStrings.onboardingTitle1,
                    description: AppStrings.onboardingDesc1,
                    icon: Icons.rocket_launch,
                    gradient: AppColors.primaryGradient,
                  ),
                  OnboardingPageWidget(
                    title: AppStrings.onboardingTitle2,
                    description: AppStrings.onboardingDesc2,
                    icon: Icons.trending_up,
                    gradient: AppColors.secondaryGradient,
                  ),
                  OnboardingPageWidget(
                    title: AppStrings.onboardingTitle3,
                    description: AppStrings.onboardingDesc3,
                    icon: Icons.local_fire_department,
                    gradient: AppColors.accentGradient,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLarge),
            PageIndicatorWidget(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
            const SizedBox(height: AppDimensions.spaceLarge),
            OnboardingFooterWidget(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onNext: _nextPage,
            ),
            const SizedBox(height: AppDimensions.spaceLarge),
          ],
        ),
      ),
    );
  }
}

/// Header widget with skip button
class OnboardingHeaderWidget extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingHeaderWidget({
    Key? key,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: onSkip,
          child: const Text(
            AppStrings.skip,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

/// Footer widget with next/get started button
class OnboardingFooterWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardingFooterWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == totalPages - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeightMedium,
        child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: Text(
            isLastPage ? AppStrings.getStarted : AppStrings.next,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

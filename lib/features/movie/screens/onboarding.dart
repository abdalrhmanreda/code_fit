import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/constants/app_constant.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/screens/movie_layout.dart';
import 'package:flutter/material.dart';

class AnimeMoviesOnboardingScreen extends StatefulWidget {
  const AnimeMoviesOnboardingScreen({super.key});

  @override
  State<AnimeMoviesOnboardingScreen> createState() =>
      _AnimeMoviesOnboardingScreenState();
}

class _AnimeMoviesOnboardingScreenState
    extends State<AnimeMoviesOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimary,
      body: SizedBox(
        width: AppConstant.deviceWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Image
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Image.asset('assets/images/on_bording.png'),
              ),
            ),
            Spacing.verticalSpace(16),

            // Animated Title
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: MyTextApp(
                  title: 'Anime Movies',
                  size: 24,
                  fontWeight: FontWeightHelper.medium,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ),
            Spacing.verticalSpace(8),

            // Animated Subtitle
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: MyTextApp(
                  title: 'Watch anime movies online',
                  size: 16,
                  fontWeight: FontWeightHelper.regular,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ),
            Spacing.verticalSpace(32),

            // Animated Neon Button
            ScaleTransition(
              scale: _buttonScaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MovieHomeScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 64,
                    width: AppConstant.deviceWidth(context) * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xff19A1BE), Color(0xff7D4192)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff19A1BE).withValues(alpha: 0.5),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                        BoxShadow(
                          color: const Color(0xff7D4192).withValues(alpha: 0.5),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: MyTextApp(
                            title: 'Enter now',
                            size: 20,
                            fontWeight: FontWeightHelper.bold,
                            color: AppColors.kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

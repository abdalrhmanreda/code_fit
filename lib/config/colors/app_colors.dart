import 'package:flutter/material.dart';

/// App color constants following the modern motivating color scheme
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color kPrimaryDark = Color(0xFF1B3C53);
  static const Color kPrimaryMedium = Color(0xFF234C6A);
  static const Color kPrimaryLight = Color(0xFF456882);
  static const Color kAccentWhite = Color(0xFFFFFFFF);
  static const Color kPrimaryDarkest = Color(0xFF0F2436);
  static const Color kPrimaryLightest = Color(0xFF5A7A94);
  static const Color kPrimarySoft = Color(0xFF6B8AA4);
  static const Color kDarkPrimaryColor = Color(0xff2c3e50);
  static const Color kPrimaryColor = Color(0xFF1976D2);
  static const Color kGoldColor = Color(0xffffae00);
  static const Color kProfileCircleColor = Color(0xff86b494);
  static const Color kWhiteColor = Color(0xffffffff);
  static const Color kBlackColor = Color(0xff000000);
  static const Color kDarkThemColor = Color(0xff1f2630);
  static const Color kLoginWithGoogleColor = Color(0xffebe7e8);
  static const Color kAppBarColor = Color(0xff303030);
  static const Color kGreyColor = Color(0xff82898d);
  static const Color kOrangeColor = Color(0xffff6900);
  static const Color kSkyBlueColor = Color(0xffe5eff5);
  static const Color kScaffoldBackGroundColor = Color(0xfff7f7f9);
  static const Color kLabelOfSearchTextFromFeildColor = Color(0xffb2dbf5);
  static const Color kOnBoardingDesc = Color(0xffD8D8D8);
  static const Color kPriceColor = Color(0xff6A6A6A);
  static const Color kProfileCircleAvatarColor = Color(0xff425b77);
  static const Color kIconMap = Color(0xff0070fc);
  static const Color konBoardingAppBarColor = Color(0xfff6f6f6);
  static const Color klightGrey = Color(0xfff6f6f6);
  static const Color kUnFocusBorderColor = Color(0xffEDEDED);
  static const Color kHintTextColor = Color(0xffC2C2C2);
  static const Color kDarkBlueColor = Color(0xff242424);

  static const Color kBackgroundHintTextColor = Color(0xfffdfdff);
  static const Color kGrayColor = Color(0xffbebebe);
  static const Color starColor = Color(0xffed0013);
  static const Color kDarkSkyBlueColor = Color(0xff80acc1);
  static const Color kLightGreyColor = Color(0xfff1f1f1);
  static const Color kScaffoldColor = Color(0xfffaf7f7);
  static const Color kAmberColor = Color(0xffffc107);
  static const Color kRedColor = Color(0xffb31206);
  static const Color kDarkBlue = Color(0xFF334a5c);
  static const Color kBlueGrey = Color(0xFF3c5b62);
  static const Color kMapColor = Color(0xff2d313f);
  static const Color kPurpleColor = Color(0xff717fff);
  static const Color kGreenColor = Color(0xff4caf50);
  static const Color kUnSelectedCircleIndictiorColor = Color(0xff90a6a7);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary Colors
  static const Color secondary = Color(0xFF4CAF50); // Green
  static const Color secondaryDark = Color(0xFF388E3C);
  static const Color secondaryLight = Color(0xFF81C784);

  // Accent Colors
  static const Color accent = Color(0xFFFF9800); // Orange
  static const Color accentDark = Color(0xFFF57C00);
  static const Color accentLight = Color(0xFFFFB74D);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF2196F3);
  static const Color gradientMiddle = Color(0xFF4CAF50);
  static const Color gradientEnd = Color(0xFFFF9800);

  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16213E);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF000000);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // XP and Progress Colors
  static const Color xpBar = Color(0xFF9C27B0); // Purple
  static const Color progressComplete = Color(0xFF4CAF50);
  static const Color progressIncomplete = Color(0xFFE0E0E0);
  static const Color levelUpGold = Color(0xFFFFD700);

  // Badge Colors
  static const Color badgeBronze = Color(0xFFCD7F32);
  static const Color badgeSilver = Color(0xFFC0C0C0);
  static const Color badgeGold = Color(0xFFFFD700);
  static const Color badgePlatinum = Color(0xFFE5E4E2);

  // Streak Colors
  static const Color streakFlame = Color(0xFFFF5722);
  static const Color streakActive = Color(0xFFFF9800);
  static const Color streakInactive = Color(0xFFBDBDBD);

  // Phase Colors (for different learning phases)
  static const Color phase1 = Color(0xFF42A5F5); // Light Blue
  static const Color phase2 = Color(0xFF66BB6A); // Green
  static const Color phase3 = Color(0xFFFFCA28); // Amber
  static const Color phase4 = Color(0xFFFF7043); // Deep Orange
  static const Color phase5 = Color(0xFFAB47BC); // Purple
  static const Color phase6 = Color(0xFFEC407A); // Pink

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xCC000000);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x33000000);

  // Divider Colors
  static const Color divider = Color(0xFFBDBDBD);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF263238);

  // Gradient Lists
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF4CAF50),
    Color(0xFF81C784),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFF9800),
    Color(0xFFFFB74D),
  ];

  static const List<Color> motivationalGradient = [
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
  ];

  static const List<Color> levelUpGradient = [
    Color(0xFFFFD700),
    Color(0xFFFFB74D),
  ];

  static const List<Color> xpGradient = [Color(0xFF9C27B0), Color(0xFFBA68C8)];
}

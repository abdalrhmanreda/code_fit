import 'package:flutter/material.dart';
import '../../l10n/alive_picker_localizations.dart';

enum Season {
  winter,
  spring,
  summer,
  autumn;

  String get name {
    switch (this) {
      case Season.winter:
        return 'Winter';
      case Season.spring:
        return 'Spring';
      case Season.summer:
        return 'Summer';
      case Season.autumn:
        return 'Autumn';
    }
  }

  String localizedName(BuildContext context) {
    final l10n = AlivePickerLocalizations.of(context);
    switch (this) {
      case Season.winter:
        return l10n.winter;
      case Season.spring:
        return l10n.spring;
      case Season.summer:
        return l10n.summer;
      case Season.autumn:
        return l10n.autumn;
    }
  }

  String get months {
    switch (this) {
      case Season.winter:
        return 'Dec - Feb';
      case Season.spring:
        return 'Mar - May';
      case Season.summer:
        return 'Jun - Aug';
      case Season.autumn:
        return 'Sep - Nov';
    }
  }

  String localizedMonths(BuildContext context) {
    final l10n = AlivePickerLocalizations.of(context);
    switch (this) {
      case Season.winter:
        return l10n.winterMonths;
      case Season.spring:
        return l10n.springMonths;
      case Season.summer:
        return l10n.summerMonths;
      case Season.autumn:
        return l10n.autumnMonths;
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case Season.winter:
        return [const Color(0xFFE0F2FE), const Color(0xFFFFFFFF)];
      case Season.spring:
        return [const Color(0xFFD1FAE5), const Color(0xFFDCEEFE)];
      case Season.summer:
        return [const Color(0xFFFEF3C7), const Color(0xFFFED7AA)];
      case Season.autumn:
        return [const Color(0xFFFED7AA), const Color(0xFFFDBA74)];
    }
  }

  String get imagePath {
    switch (this) {
      case Season.winter:
        return 'assets/images/winter.png';
      case Season.spring:
        return 'assets/images/spring.png';
      case Season.summer:
        return 'assets/images/summer.png';
      case Season.autumn:
        return 'assets/images/autom.png';
    }
  }

  IconData get icon {
    switch (this) {
      case Season.winter:
        return Icons.ac_unit;
      case Season.spring:
        return Icons.local_florist;
      case Season.summer:
        return Icons.wb_sunny;
      case Season.autumn:
        return Icons.eco;
    }
  }

  Color get iconColor {
    switch (this) {
      case Season.winter:
        return const Color(0xFF3B82F6);
      case Season.spring:
        return const Color(0xFF10B981);
      case Season.summer:
        return const Color(0xFFF59E0B);
      case Season.autumn:
        return const Color(0xFFEF4444);
    }
  }
}

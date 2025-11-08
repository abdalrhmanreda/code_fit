import 'package:equatable/equatable.dart';

/// Model representing an achievement/badge
class AchievementModel extends Equatable {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String iconName;
  final String badgeType; // bronze, silver, gold, platinum
  final int requiredValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.iconName,
    required this.badgeType,
    required this.requiredValue,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  // Get title based on language
  String getTitle(String languageCode) {
    return languageCode == 'ar' ? titleAr : titleEn;
  }

  // Get description based on language
  String getDescription(String languageCode) {
    return languageCode == 'ar' ? descriptionAr : descriptionEn;
  }

  // Get badge color based on type
  int get badgeColorCode {
    switch (badgeType.toLowerCase()) {
      case 'bronze':
        return 0xFFCD7F32;
      case 'silver':
        return 0xFFC0C0C0;
      case 'gold':
        return 0xFFFFD700;
      case 'platinum':
        return 0xFFE5E4E2;
      default:
        return 0xFFCD7F32;
    }
  }

  // Copy with method
  AchievementModel copyWith({
    String? id,
    String? titleEn,
    String? titleAr,
    String? descriptionEn,
    String? descriptionAr,
    String? iconName,
    String? badgeType,
    int? requiredValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      iconName: iconName ?? this.iconName,
      badgeType: badgeType ?? this.badgeType,
      requiredValue: requiredValue ?? this.requiredValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  // From JSON
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionAr: json['descriptionAr'] as String,
      iconName: json['iconName'] as String,
      badgeType: json['badgeType'] as String,
      requiredValue: json['requiredValue'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'iconName': iconName,
      'badgeType': badgeType,
      'requiredValue': requiredValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        titleEn,
        titleAr,
        descriptionEn,
        descriptionAr,
        iconName,
        badgeType,
        requiredValue,
        isUnlocked,
        unlockedAt,
      ];
}

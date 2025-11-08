import 'package:equatable/equatable.dart';

/// Model representing a checkpoint within a milestone
class CheckpointModel extends Equatable {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int order;
  final bool isCompleted;
  final String difficulty; // easy, medium, hard
  final int estimatedMinutes;

  const CheckpointModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.order,
    this.isCompleted = false,
    required this.difficulty,
    required this.estimatedMinutes,
  });

  // Get title based on language
  String getTitle(String languageCode) {
    return languageCode == 'ar' ? titleAr : titleEn;
  }

  // Get description based on language
  String getDescription(String languageCode) {
    return languageCode == 'ar' ? descriptionAr : descriptionEn;
  }

  // Get XP reward based on difficulty
  int get xpReward {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 50;
      case 'medium':
        return 100;
      case 'hard':
        return 200;
      default:
        return 100;
    }
  }

  // Copy with method
  CheckpointModel copyWith({
    String? id,
    String? titleEn,
    String? titleAr,
    String? descriptionEn,
    String? descriptionAr,
    int? order,
    bool? isCompleted,
    String? difficulty,
    int? estimatedMinutes,
  }) {
    return CheckpointModel(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      difficulty: difficulty ?? this.difficulty,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  // From JSON
  factory CheckpointModel.fromJson(Map<String, dynamic> json) {
    return CheckpointModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionAr: json['descriptionAr'] as String,
      order: json['order'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      difficulty: json['difficulty'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int,
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
      'order': order,
      'isCompleted': isCompleted,
      'difficulty': difficulty,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        titleEn,
        titleAr,
        descriptionEn,
        descriptionAr,
        order,
        isCompleted,
        difficulty,
        estimatedMinutes,
      ];
}

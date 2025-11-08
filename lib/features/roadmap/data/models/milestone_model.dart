import 'package:equatable/equatable.dart';
import 'checkpoint_model.dart';

/// Model representing a milestone within a phase
class MilestoneModel extends Equatable {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int order;
  final List<CheckpointModel> checkpoints;
  final bool isLocked;

  const MilestoneModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.order,
    required this.checkpoints,
    this.isLocked = false,
  });

  // Get title based on language
  String getTitle(String languageCode) {
    return languageCode == 'ar' ? titleAr : titleEn;
  }

  // Get description based on language
  String getDescription(String languageCode) {
    return languageCode == 'ar' ? descriptionAr : descriptionEn;
  }

  // Calculate milestone progress
  double get progress {
    if (checkpoints.isEmpty) return 0.0;
    final completedCount = checkpoints.where((c) => c.isCompleted).length;
    return completedCount / checkpoints.length;
  }

  // Check if milestone is completed
  bool get isCompleted => progress == 1.0;

  // Get total XP for milestone
  int get totalXp {
    return checkpoints.fold(0, (sum, checkpoint) => sum + checkpoint.xpReward);
  }

  // Get earned XP (from completed checkpoints)
  int get earnedXp {
    return checkpoints
        .where((c) => c.isCompleted)
        .fold(0, (sum, checkpoint) => sum + checkpoint.xpReward);
  }

  // Get estimated time in minutes
  int get estimatedMinutes {
    return checkpoints.fold(0, (sum, checkpoint) => sum + checkpoint.estimatedMinutes);
  }

  // Get completed checkpoints count
  int get completedCheckpointsCount {
    return checkpoints.where((c) => c.isCompleted).length;
  }

  // Copy with method
  MilestoneModel copyWith({
    String? id,
    String? titleEn,
    String? titleAr,
    String? descriptionEn,
    String? descriptionAr,
    int? order,
    List<CheckpointModel>? checkpoints,
    bool? isLocked,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      order: order ?? this.order,
      checkpoints: checkpoints ?? this.checkpoints,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  // From JSON
  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionAr: json['descriptionAr'] as String,
      order: json['order'] as int,
      checkpoints: (json['checkpoints'] as List)
          .map((c) => CheckpointModel.fromJson(c as Map<String, dynamic>))
          .toList(),
      isLocked: json['isLocked'] as bool? ?? false,
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
      'checkpoints': checkpoints.map((c) => c.toJson()).toList(),
      'isLocked': isLocked,
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
        checkpoints,
        isLocked,
      ];
}

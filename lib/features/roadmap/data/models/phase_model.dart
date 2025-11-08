import 'package:equatable/equatable.dart';
import 'milestone_model.dart';

/// Model representing a learning phase
class PhaseModel extends Equatable {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int order;
  final List<MilestoneModel> milestones;
  final String iconName;
  final int colorCode;

  const PhaseModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.order,
    required this.milestones,
    required this.iconName,
    required this.colorCode,
  });

  // Get title based on language
  String getTitle(String languageCode) {
    return languageCode == 'ar' ? titleAr : titleEn;
  }

  // Get description based on language
  String getDescription(String languageCode) {
    return languageCode == 'ar' ? descriptionAr : descriptionEn;
  }

  // Calculate phase progress
  double get progress {
    if (milestones.isEmpty) return 0.0;
    final completedCount = milestones.where((m) => m.isCompleted).length;
    return completedCount / milestones.length;
  }

  // Check if phase is completed
  bool get isCompleted => progress == 1.0;

  // Check if phase is unlocked (previous phase completed or first phase)
  bool isUnlocked(List<PhaseModel> allPhases) {
    if (order == 1) return true;

    final previousPhase = allPhases.firstWhere(
      (phase) => phase.order == order - 1,
      orElse: () => this,
    );

    return previousPhase.isCompleted;
  }

  // Get total checkpoints count
  int get totalCheckpoints {
    return milestones.fold(0, (sum, milestone) => sum + milestone.checkpoints.length);
  }

  // Get completed checkpoints count
  int get completedCheckpoints {
    return milestones.fold(
      0,
      (sum, milestone) => sum + milestone.checkpoints.where((c) => c.isCompleted).length,
    );
  }

  // Copy with method
  PhaseModel copyWith({
    String? id,
    String? titleEn,
    String? titleAr,
    String? descriptionEn,
    String? descriptionAr,
    int? order,
    List<MilestoneModel>? milestones,
    String? iconName,
    int? colorCode,
  }) {
    return PhaseModel(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      order: order ?? this.order,
      milestones: milestones ?? this.milestones,
      iconName: iconName ?? this.iconName,
      colorCode: colorCode ?? this.colorCode,
    );
  }

  // From JSON
  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionAr: json['descriptionAr'] as String,
      order: json['order'] as int,
      milestones: (json['milestones'] as List)
          .map((m) => MilestoneModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      iconName: json['iconName'] as String,
      colorCode: json['colorCode'] as int,
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
      'milestones': milestones.map((m) => m.toJson()).toList(),
      'iconName': iconName,
      'colorCode': colorCode,
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
        milestones,
        iconName,
        colorCode,
      ];
}

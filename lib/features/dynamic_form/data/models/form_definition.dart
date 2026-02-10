import 'form_step_model.dart';

class FormDefinition {
  final List<FormStepModel> steps;
  final List<dynamic> conditions;

  const FormDefinition({required this.steps, this.conditions = const []});

  factory FormDefinition.fromJson(Map<String, dynamic> json) {
    return FormDefinition(
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => FormStepModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      conditions: (json['conditions'] as List<dynamic>?) ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((e) => e.toJson()).toList(),
      'conditions': conditions,
    };
  }
}

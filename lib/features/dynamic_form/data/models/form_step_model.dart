import 'form_field_model.dart';
import 'localized_text.dart';

class FormStepModel {
  final LocalizedText title;
  final List<FormFieldModel> fields;

  const FormStepModel({required this.title, required this.fields});

  factory FormStepModel.fromJson(Map<String, dynamic> json) {
    return FormStepModel(
      title: json['title'] is Map
          ? LocalizedText.fromJson(json['title'] as Map<String, dynamic>)
          : LocalizedText.fromString(json['title'] as String? ?? ''),
      fields:
          (json['fields'] as List<dynamic>?)
              ?.map((e) => FormFieldModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.toJson(),
      'fields': fields.map((e) => e.toJson()).toList(),
    };
  }
}

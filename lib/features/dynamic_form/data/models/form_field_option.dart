import 'localized_text.dart';


class FormFieldOption {
  final String value;
  final LocalizedText label;

  const FormFieldOption({required this.value, required this.label});

  factory FormFieldOption.fromJson(Map<String, dynamic> json) {
    return FormFieldOption(
      value: json['value'] as String? ?? '',
      label: LocalizedText.fromJson(
        json['label'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'label': label.toJson()};
  }
}


class DynamicOptions {
  final String model;
  final String valueField;
  final String labelField;
  final Map<String, dynamic>? constrains;

  const DynamicOptions({
    required this.model,
    required this.valueField,
    required this.labelField,
    this.constrains,
  });

  factory DynamicOptions.fromJson(Map<String, dynamic> json) {
    return DynamicOptions(
      model: json['model'] as String? ?? '',
      valueField: json['value_field'] as String? ?? '',
      labelField: json['label_field'] as String? ?? '',
      constrains: json['constrains'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'value_field': valueField,
      'label_field': labelField,
      if (constrains != null) 'constrains': constrains,
    };
  }
}

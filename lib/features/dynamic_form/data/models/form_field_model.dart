import 'localized_text.dart';
import 'form_field_option.dart';
import 'dynamic_options.dart';


enum FormFieldType { text, textarea, select, radio, checkbox, file, group }


class FormFieldModel {
  final String key;
  final FormFieldType type;
  final LocalizedText label;
  final int span;
  final String? rules;
  final bool required;
  final bool repeatable;
  final int? minInstances;
  final int? maxInstances;
  final List<FormFieldOption>? options;
  final DynamicOptions? dynamicOptions;
  final bool multiple;
  final List<FormFieldModel>? fields;

  const FormFieldModel({
    required this.key,
    required this.type,
    required this.label,
    this.span = 12,
    this.rules,
    this.required = false,
    this.repeatable = false,
    this.minInstances,
    this.maxInstances,
    this.options,
    this.dynamicOptions,
    this.multiple = false,
    this.fields,
  });


  bool get hasValidation => rules != null && rules!.isNotEmpty;


  bool get isRequired => required || (rules?.contains('required') ?? false);


  int get minimumInstances => minInstances ?? (repeatable ? 1 : 0);


  int get maximumInstances => maxInstances ?? (repeatable ? 10 : 1);

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {

    FormFieldType fieldType = FormFieldType.text;
    final typeStr = (json['type'] as String? ?? 'text').toLowerCase();
    switch (typeStr) {
      case 'textarea':
        fieldType = FormFieldType.textarea;
        break;
      case 'select':
        fieldType = FormFieldType.select;
        break;
      case 'radio':
        fieldType = FormFieldType.radio;
        break;
      case 'checkbox':
        fieldType = FormFieldType.checkbox;
        break;
      case 'file':
        fieldType = FormFieldType.file;
        break;
      case 'group':
        fieldType = FormFieldType.group;
        break;
      default:
        fieldType = FormFieldType.text;
    }

    return FormFieldModel(
      key: json['key'] as String? ?? '',
      type: fieldType,
      label: LocalizedText.fromJson(
        json['label'] as Map<String, dynamic>? ?? {},
      ),
      span: json['span'] as int? ?? 12,
      rules: json['rules'] as String?,
      required: json['required'] as bool? ?? false,
      repeatable: json['repeatable'] as bool? ?? false,
      minInstances: json['min_instances'] as int?,
      maxInstances: json['max_instances'] as int?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => FormFieldOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      dynamicOptions: json['dynamic_options'] != null
          ? DynamicOptions.fromJson(
              json['dynamic_options'] as Map<String, dynamic>,
            )
          : null,
      multiple: json['multiple'] as bool? ?? false,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => FormFieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type.name,
      'label': label.toJson(),
      'span': span,
      if (rules != null) 'rules': rules,
      'required': required,
      'repeatable': repeatable,
      if (minInstances != null) 'min_instances': minInstances,
      if (maxInstances != null) 'max_instances': maxInstances,
      if (options != null) 'options': options!.map((e) => e.toJson()).toList(),
      if (dynamicOptions != null) 'dynamic_options': dynamicOptions!.toJson(),
      'multiple': multiple,
      if (fields != null) 'fields': fields!.map((e) => e.toJson()).toList(),
    };
  }
}

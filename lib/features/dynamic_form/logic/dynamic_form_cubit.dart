import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/form_schema.dart';
import '../data/models/form_field_model.dart';
import '../data/validators/form_validator.dart';
import 'dynamic_form_state.dart';

class DynamicFormCubit extends Cubit<DynamicFormState> {
  DynamicFormCubit() : super(const DynamicFormState());

  void initializeForm(FormSchema schema) {
    emit(
      state.copyWith(
        formSchema: schema,
        totalSteps: schema.definition.steps.length,
        currentStep: 0,
        formData: {},
        validationErrors: {},
        isSubmitted: false,
      ),
    );
  }

  void updateField(String fieldKey, dynamic value) {
    final updatedData = Map<String, dynamic>.from(state.formData);
    updatedData[fieldKey] = value;

    emit(state.copyWith(formData: updatedData));

    if (state.validationErrors.containsKey(fieldKey)) {
      final updatedErrors = Map<String, String>.from(state.validationErrors);
      updatedErrors.remove(fieldKey);
      emit(state.copyWith(validationErrors: updatedErrors));
    }
  }

  void updateRepeatableField(
    String fieldKey,
    int index,
    String subKey,
    dynamic value,
  ) {
    final updatedData = Map<String, dynamic>.from(state.formData);

    if (updatedData[fieldKey] == null) {
      updatedData[fieldKey] = [];
    }

    // Safely convert to list of maps
    final rawList = updatedData[fieldKey];
    List<Map<String, dynamic>> list;

    if (rawList is List) {
      list = rawList.whereType<Map<String, dynamic>>().toList();
    } else {
      list = [];
    }

    while (list.length <= index) {
      list.add({});
    }

    list[index][subKey] = value;
    updatedData[fieldKey] = list;

    emit(state.copyWith(formData: updatedData));
  }

  void addRepeatableInstance(String fieldKey) {
    final updatedData = Map<String, dynamic>.from(state.formData);

    if (updatedData[fieldKey] == null) {
      updatedData[fieldKey] = [];
    }

    var list = updatedData[fieldKey];
    List<dynamic> newList;
    if (list is List) {
      newList = List.from(list);
    } else {
      newList = [];
    }

    // Determine what to add based on existing items or safe default?
    // If the field is a group, it uses Map. If it's a primitive field (text), it uses String.
    // The previous implementation forced Map<String, dynamic>.
    // Since we don't have the field definition here easily without passing it, checking the list content is a heuristic.
    // But if the list is empty, we might not know.
    // However, looking at the error: "type 'String' is not a subtype of type 'Map<String, dynamic>'",
    // it confirms that the list already contained Strings (so it's a simple repeatable field).

    // Safer approach: Check if we can infer type, otherwise defaulting to empty string for simple fields might break groups if empty.
    // Actually, `addRepeatableInstance` in `DynamicRepeatableField` (simple) calls this.
    // `DynamicGroupField` ALSO calls this.
    // We ideally should know if it's a group or not.
    // But let's check the first element if exists.
    if (newList.isNotEmpty && newList.first is Map) {
      newList.add({});
    } else if (newList.isNotEmpty && newList.first is String) {
      newList.add('');
    } else {
      // List is empty. If this method is called from DynamicRepeatableField, it expects Strings (mostly).
      // If called from DynamicGroupField, it expects Maps.
      // We can't distinguish easily without the field model.
      // Let's rely on the fact that if we just added '{}' it crashes simple fields.
      // If we add '' it might crash Group fields later?
      // actually the error happened at `List<Map<...>>.from(...)`.
      // Let's use `List<dynamic>` and maybe pass a parameter strictly?
      // For now, let's try assuming Map if not sure, BUT detecting if the crash was because it was NOT a map.
      // The crash was: `type 'String' is not a subtype of type 'Map<String, dynamic>'`.
      // This means the list HAD strings. So we should add a String.
      // So the logic: if we have strings, add string. If we have maps, add map.
      // Defaulting to empty string might be safer for "simple" repeatable fields, but Group fields need Map.
      // If empty... we have a problem.
      // But `DynamicFormCubit` doesn't know the field Type here.
      // Let's assume simple string for now to fix the reported crash, but we should probably check `state.formSchema` to be correct.

      // CORRECT FIX: Check schema if possible with recursive search
      bool isGroup = _isGroupField(fieldKey);

      if (isGroup) {
        newList.add({});
      } else {
        newList.add('');
      }
    }

    updatedData[fieldKey] = newList;

    emit(state.copyWith(formData: updatedData));
  }

  // Helper method to check if a field is a group type
  bool _isGroupField(String fieldKey) {
    final steps = state.formSchema?.definition.steps ?? [];

    for (var step in steps) {
      for (var field in step.fields) {
        if (field.key == fieldKey && field.type == FormFieldType.group) {
          return true;
        }

        // Check nested fields within groups
        if (field.type == FormFieldType.group && field.fields != null) {
          for (var nestedField in field.fields!) {
            if (nestedField.key == fieldKey &&
                nestedField.type == FormFieldType.group) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  void removeRepeatableInstance(String fieldKey, int index) {
    final updatedData = Map<String, dynamic>.from(state.formData);
    final rawList = updatedData[fieldKey];

    if (rawList is List) {
      final list = List.from(rawList);
      if (index >= 0 && index < list.length) {
        list.removeAt(index);
        updatedData[fieldKey] = list;
        emit(state.copyWith(formData: updatedData));
      }
    }
  }

  bool validateCurrentStep(String locale) {
    if (state.formSchema == null) return false;

    final currentStepModel =
        state.formSchema!.definition.steps[state.currentStep];
    final errors = <String, String>{};

    for (final field in currentStepModel.fields) {
      final validationError = _validateField(field, locale);
      if (validationError != null) {
        errors[field.key] = validationError;
      }
    }

    emit(state.copyWith(validationErrors: errors));
    return errors.isEmpty;
  }

  String? _validateField(FormFieldModel field, String locale) {
    final fieldValue = state.formData[field.key];
    final fieldLabel = field.label.getLocalized(locale);

    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.textarea:
        // Handle repeatable fields differently
        if (field.repeatable && fieldValue is List) {
          // Validate each item in the list
          for (int i = 0; i < fieldValue.length; i++) {
            final itemValue = fieldValue[i];
            final result = FormValidator.validate(
              value: itemValue?.toString(),
              rules: field.rules,
              fieldLabel: fieldLabel,
              locale: locale,
            );
            if (!result.isValid) {
              return result.errorMessage;
            }
          }

          // Check minimum instances requirement
          if (fieldValue.length < field.minimumInstances) {
            return locale.startsWith('ar')
                ? 'يجب إضافة $fieldLabel (الحد الأدنى: ${field.minimumInstances})'
                : 'Please add $fieldLabel (minimum: ${field.minimumInstances})';
          }

          return null;
        } else {
          // Single field validation
          final result = FormValidator.validate(
            value: fieldValue?.toString(),
            rules: field.rules,
            fieldLabel: fieldLabel,
            locale: locale,
          );
          return result.isValid ? null : result.errorMessage;
        }

      case FormFieldType.select:
      case FormFieldType.checkbox:
        if (field.multiple) {
          final values = fieldValue as List<String>?;
          final result = FormValidator.validateList(
            values: values,
            isRequired: field.isRequired,
            fieldLabel: fieldLabel,
            locale: locale,
          );
          return result.isValid ? null : result.errorMessage;
        } else {
          final result = FormValidator.validate(
            value: fieldValue?.toString(),
            rules: field.rules,
            fieldLabel: fieldLabel,
            locale: locale,
          );
          return result.isValid ? null : result.errorMessage;
        }

      case FormFieldType.radio:
        final result = FormValidator.validate(
          value: fieldValue?.toString(),
          rules: field.rules,
          fieldLabel: fieldLabel,
          locale: locale,
        );
        return result.isValid ? null : result.errorMessage;

      case FormFieldType.file:
        final result = FormValidator.validateFile(
          file: fieldValue,
          isRequired: field.isRequired,
          fieldLabel: fieldLabel,
          locale: locale,
        );
        return result.isValid ? null : result.errorMessage;

      case FormFieldType.group:
        if (field.repeatable) {
          // Safe cast to List and then filter Maps
          final rawList = fieldValue as List?;
          final instances = rawList?.whereType<Map<String, dynamic>>().toList();

          if (field.isRequired && (instances == null || instances.isEmpty)) {
            return locale.startsWith('ar')
                ? '$fieldLabel مطلوب'
                : '$fieldLabel is required';
          }

          if (instances != null) {
            if (instances.length < field.minimumInstances) {
              return locale.startsWith('ar')
                  ? 'يجب إضافة $fieldLabel (الحد الأدنى: ${field.minimumInstances})'
                  : 'Please add $fieldLabel (minimum: ${field.minimumInstances})';
            }

            // PERFORMS RECURSIVE VALIDATION FOR NESTED FIELDS
            if (field.fields != null) {
              for (int i = 0; i < instances.length; i++) {
                final instanceData = instances[i];
                for (final subField in field.fields!) {
                  final subValue = instanceData[subField.key];
                  // Reuse existing validation logic
                  final subResult = _validateRule(subField, subValue, locale);
                  if (subResult != null) {
                    // Return error with Item index context
                    final itemIndex = i + 1;
                    final prefix = locale.startsWith('ar')
                        ? 'عنصر $itemIndex'
                        : 'Item $itemIndex';
                    return '$prefix: $subResult';
                  }
                }
              }
            }
          }
        }
        return null;
    }
  }

  // Helper method to validate a single field definition against a value
  // We need to extract logic from _validateField or FormValidator to share it
  String? _validateRule(FormFieldModel field, dynamic value, String locale) {
    final fieldLabel = field.label.getLocalized(locale);

    if (field.type == FormFieldType.text ||
        field.type == FormFieldType.textarea ||
        field.type == FormFieldType.radio) {
      final result = FormValidator.validate(
        value: value?.toString(),
        rules: field.rules,
        fieldLabel: fieldLabel,
        locale: locale,
      );
      return result.isValid ? null : result.errorMessage;
    } else if (field.type == FormFieldType.select) {
      if (field.multiple) {
        final result = FormValidator.validateList(
          values: value as List<String>?,
          isRequired: field.isRequired,
          fieldLabel: fieldLabel,
          locale: locale,
        );
        return result.isValid ? null : result.errorMessage;
      } else {
        final result = FormValidator.validate(
          value: value?.toString(),
          rules: field.rules,
          fieldLabel: fieldLabel,
          locale: locale,
        );
        return result.isValid ? null : result.errorMessage;
      }
    }

    // Basic required check for any other types
    if (field.isRequired &&
        (value == null || (value is String && value.isEmpty))) {
      return locale.startsWith('ar')
          ? '$fieldLabel مطلوب'
          : '$fieldLabel is required';
    }

    return null;
  }

  void nextStep(String locale) {
    if (validateCurrentStep(locale) && !state.isLastStep) {
      emit(
        state.copyWith(
          currentStep: state.currentStep + 1,
          validationErrors: {},
        ),
      );
    }
  }

  void previousStep() {
    if (!state.isFirstStep) {
      emit(
        state.copyWith(
          currentStep: state.currentStep - 1,
          validationErrors: {},
        ),
      );
    }
  }

  void goToStep(int step, String locale) {
    if (step >= 0 && step < state.totalSteps) {
      bool allValid = true;
      for (int i = state.currentStep; i < step; i++) {
        emit(state.copyWith(currentStep: i));
        if (!validateCurrentStep(locale)) {
          allValid = false;
          break;
        }
      }

      if (allValid) {
        emit(state.copyWith(currentStep: step, validationErrors: {}));
      }
    }
  }

  Future<void> submitForm(String locale) async {
    if (!validateCurrentStep(locale)) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      if (state.formSchema == null) {
        throw Exception('Form schema is missing');
      }

      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(isSubmitting: false, isSubmitted: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  void resetForm() {
    if (state.formSchema != null) {
      initializeForm(state.formSchema!);
    }
  }

  dynamic getFieldValue(String fieldKey) {
    return state.formData[fieldKey];
  }

  String? getFieldError(String fieldKey) {
    return state.validationErrors[fieldKey];
  }
}

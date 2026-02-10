import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/form_field_model.dart';
import '../../logic/dynamic_form_cubit.dart';
import 'dynamic_text_field.dart';
import 'dynamic_select_field.dart';
import 'dynamic_radio_field.dart';
import 'dynamic_checkbox_field.dart';
import 'dynamic_file_field.dart';
import 'dynamic_group_field.dart';
import 'dynamic_repeatable_field.dart';

class FormFieldRenderer extends StatelessWidget {
  final FormFieldModel field;
  final String locale;
  final Function(dynamic)? onChanged;
  final dynamic value;

  const FormFieldRenderer({
    super.key,
    required this.field,
    this.locale = 'en',
    this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DynamicFormCubit>();

    return BlocBuilder<DynamicFormCubit, dynamic>(
      builder: (context, state) {
        // If onChanged is provided (Nested mode), use the passed value.
        // Otherwise (Root mode), fetch from cubit.
        final fieldValue = onChanged != null
            ? value
            : cubit.getFieldValue(field.key);
        final errorText = cubit.getFieldError(field.key);

        if (field.repeatable && field.type != FormFieldType.group) {
          return DynamicRepeatableField(
            field: field,
            cubit: cubit,
            value: fieldValue,
            errorText: errorText,
            locale: locale,
          );
        }

        void handleChanged(dynamic val) {
          if (onChanged != null) {
            onChanged!(val);
          } else {
            cubit.updateField(field.key, val);
          }
        }

        switch (field.type) {
          case FormFieldType.text:
          case FormFieldType.textarea:
            return DynamicTextField(
              field: field,
              value: fieldValue?.toString(),
              errorText: errorText,
              onChanged: handleChanged,
              locale: locale,
            );

          case FormFieldType.select:
            return DynamicSelectField(
              field: field,
              value: fieldValue,
              errorText: errorText,
              onChanged: handleChanged,
              locale: locale,
            );

          case FormFieldType.radio:
            return DynamicRadioField(
              field: field,
              value: fieldValue?.toString(),
              errorText: errorText,
              onChanged: handleChanged,
              locale: locale,
            );

          case FormFieldType.checkbox:
            return DynamicCheckboxField(
              field: field,
              value: fieldValue as List<String>?,
              errorText: errorText,
              onChanged: handleChanged,
              locale: locale,
            );

          case FormFieldType.file:
            return DynamicFileField(
              field: field,
              value: fieldValue,
              errorText: errorText,
              onChanged: handleChanged,
              locale: locale,
            );

          case FormFieldType.group:
            return DynamicGroupField(field: field, locale: locale);
        }
      },
    );
  }
}

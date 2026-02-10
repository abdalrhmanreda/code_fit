import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/form_field_model.dart';
import '../../data/models/form_field_option.dart';
import '../../data/providers/static_options_provider.dart';

import '../../../../config/colors/app_colors.dart';

class DynamicSelectField extends StatelessWidget {
  final FormFieldModel field;
  final dynamic value;
  final String? errorText;
  final Function(dynamic) onChanged;
  final String locale;

  const DynamicSelectField({
    super.key,
    required this.field,
    this.value,
    this.errorText,
    required this.onChanged,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = locale.startsWith('ar');
    final label = field.label.getLocalized(locale);
    final options = _getOptions();

    if (field.multiple) {
      return _buildMultiSelect(context, label, options, isRtl);
    } else {
      return _buildSingleSelect(context, label, options, isRtl);
    }
  }

  Widget _buildSingleSelect(
    BuildContext context,
    String label,
    List<FormFieldOption> options,
    bool isRtl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                children: [
                  if (field.isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ),

        DropdownButtonFormField<String>(
          initialValue: value as String?,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: label,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.kGrayColor.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.kWhiteColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option.value,
              child: Text(
                option.label.getLocalized(locale),
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildMultiSelect(
    BuildContext context,
    String label,
    List<FormFieldOption> options,
    bool isRtl,
  ) {
    final selectedValues = (value as List<String>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                children: [
                  if (field.isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ),

        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : AppColors.kGrayColor.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.kWhiteColor,
          ),
          padding: EdgeInsets.all(12.w),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: options.map((option) {
              final isSelected = selectedValues.contains(option.value);
              return FilterChip(
                label: Text(
                  option.label.getLocalized(locale),
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.kWhiteColor
                        : AppColors.textPrimary,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final newValues = List<String>.from(selectedValues);
                  if (selected) {
                    newValues.add(option.value);
                  } else {
                    newValues.remove(option.value);
                  }
                  onChanged(newValues);
                },
                backgroundColor: AppColors.kWhiteColor,
                selectedColor: AppColors.kPrimary,
              );
            }).toList(),
          ),
        ),

        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: Text(
              errorText!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.error),
            ),
          ),
      ],
    );
  }

  List<FormFieldOption> _getOptions() {
    if (field.dynamicOptions != null) {
      return StaticOptionsProvider.getOptions(field.dynamicOptions!.model);
    }

    return field.options ?? [];
  }
}

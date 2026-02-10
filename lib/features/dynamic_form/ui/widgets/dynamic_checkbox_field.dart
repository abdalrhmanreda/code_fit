import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/form_field_model.dart';

import '../../../../config/colors/app_colors.dart';

class DynamicCheckboxField extends StatelessWidget {
  final FormFieldModel field;
  final List<String>? value;
  final String? errorText;
  final Function(List<String>) onChanged;
  final String locale;

  const DynamicCheckboxField({
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
    final options = field.options ?? [];
    final selectedValues = value ?? [];

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
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            children: options.map((option) {
              final isSelected = selectedValues.contains(option.value);

              return CheckboxListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(
                  option.label.getLocalized(locale),
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(fontSize: 13.sp),
                ),
                value: isSelected,
                onChanged: (checked) {
                  final newValues = List<String>.from(selectedValues);
                  if (checked == true) {
                    newValues.add(option.value);
                  } else {
                    newValues.remove(option.value);
                  }
                  onChanged(newValues);
                },
                activeColor: AppColors.kPrimary,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
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
}

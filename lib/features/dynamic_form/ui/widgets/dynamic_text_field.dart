import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/form_field_model.dart';

import '../../../../config/colors/app_colors.dart';

class DynamicTextField extends StatelessWidget {
  final FormFieldModel field;
  final String? value;
  final String? errorText;
  final Function(String) onChanged;
  final String locale;
  final Widget? suffixIcon;

  const DynamicTextField({
    super.key,
    required this.field,
    this.value,
    this.errorText,
    required this.onChanged,
    this.suffixIcon,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = locale.startsWith('ar');
    final label = field.label.getLocalized(locale);
    final isTextArea = field.type == FormFieldType.textarea;

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

        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          maxLines: isTextArea ? 5 : 1,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          keyboardType: _getKeyboardType(),
          decoration: InputDecoration(
            hintText: label,
            errorText: errorText,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.kGrayColor.withValues(alpha: 0.5),
              ),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            filled: true,
            fillColor: AppColors.kWhiteColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: isTextArea ? 16.h : 14.h,
            ),
          ),
        ),
      ],
    );
  }

  TextInputType _getKeyboardType() {
    final rules = field.rules?.toLowerCase() ?? '';

    if (rules.contains('email')) {
      return TextInputType.emailAddress;
    } else if (rules.contains('numeric') || rules.contains('number')) {
      return TextInputType.number;
    } else if (rules.contains('phone')) {
      return TextInputType.phone;
    } else if (rules.contains('url')) {
      return TextInputType.url;
    } else if (field.type == FormFieldType.textarea) {
      return TextInputType.multiline;
    }

    return TextInputType.text;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/form_field_model.dart';
import '../../logic/dynamic_form_cubit.dart';
import '../../../../config/colors/app_colors.dart';
import 'dynamic_text_field.dart';

class DynamicRepeatableField extends StatelessWidget {
  final FormFieldModel field;
  final DynamicFormCubit cubit;
  final dynamic value;
  final String? errorText;
  final String locale;

  const DynamicRepeatableField({
    super.key,
    required this.field,
    required this.cubit,
    this.value,
    this.errorText,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final instances = (value as List?) ?? [];
    final canAdd = instances.length < field.maximumInstances;
    final canRemove = instances.length > field.minimumInstances;
    final label = field.label.getLocalized(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
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
            if (canAdd)
              Container(
                margin: EdgeInsets.only(left: 8.w),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => cubit.addRepeatableInstance(field.key),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColors.kWhiteColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        ...List.generate(instances.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSingleInstance(
                    context,
                    cubit,
                    index,
                    instances[index],
                  ),
                ),
                if (canRemove)
                  Container(
                    margin: EdgeInsets.only(left: 8.w, top: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            cubit.removeRepeatableInstance(field.key, index),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.remove_rounded,
                            color: AppColors.error,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
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

  Widget _buildSingleInstance(
    BuildContext context,
    DynamicFormCubit cubit,
    int index,
    dynamic instanceValue,
  ) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.textarea:
        return DynamicTextField(
          field: field,
          value: instanceValue?.toString(),
          errorText: null,
          onChanged: (val) {
            final list = List.from(
              (cubit.getFieldValue(field.key) as List?) ?? [],
            );
            if (list.length <= index) {
              list.add(val);
            } else {
              list[index] = val;
            }
            cubit.updateField(field.key, list);
          },
          locale: locale,
        );

      default:
        // Other types of repeatable fields can be added here if needed
        return const SizedBox();
    }
  }
}

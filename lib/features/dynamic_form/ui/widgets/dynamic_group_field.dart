import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/form_field_model.dart';
import '../../logic/dynamic_form_cubit.dart';
import 'form_field_renderer.dart';
import '../../../../config/colors/app_colors.dart';

class DynamicGroupField extends StatelessWidget {
  final FormFieldModel field;
  final String locale;

  const DynamicGroupField({super.key, required this.field, this.locale = 'en'});

  @override
  Widget build(BuildContext context) {
    final isRtl = locale.startsWith('ar');
    final label = field.label.getLocalized(locale);
    final cubit = context.read<DynamicFormCubit>();

    return BlocBuilder<DynamicFormCubit, dynamic>(
      builder: (context, state) {
        final fieldValue = cubit.getFieldValue(field.key);
        List<Map<String, dynamic>> instances = [];

        // Safely check if it's a list and filter only Map items
        if (fieldValue is List) {
          instances = fieldValue.whereType<Map<String, dynamic>>().toList();
        }
        final canAdd = instances.length < field.maximumInstances;
        final canRemove = instances.length > field.minimumInstances;

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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
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
                  IconButton(
                    onPressed: () => cubit.addRepeatableInstance(field.key),
                    icon: Icon(Icons.add_circle_outline, size: 24.sp),
                    color: AppColors.kPrimary,
                  ),
              ],
            ),

            SizedBox(height: 12.h),

            ...List.generate(instances.length, (index) {
              return _buildInstance(
                context,
                cubit,
                index,
                instances.length,
                canRemove,
                isRtl,
                instances[index],
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildInstance(
    BuildContext context,
    DynamicFormCubit cubit,
    int index,
    int totalInstances,
    bool canRemove,
    bool isRtl,
    Map<String, dynamic> instanceData,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.kGrayColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.kWhiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isRtl ? 'العنصر ${index + 1}' : 'Item ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kPrimary,
                  ),
                ),
              ),

              if (canRemove)
                IconButton(
                  onPressed: () =>
                      cubit.removeRepeatableInstance(field.key, index),
                  icon: Icon(Icons.delete_outline, size: 20.sp),
                  color: AppColors.error,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          SizedBox(height: 12.h),

          ...field.fields!.map((subField) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: FormFieldRenderer(
                field: subField,
                locale: locale,
                value: instanceData[subField.key],
                onChanged: (value) {
                  cubit.updateRepeatableField(
                    field.key,
                    index,
                    subField.key,
                    value,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

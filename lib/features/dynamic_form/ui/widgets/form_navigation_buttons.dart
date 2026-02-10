import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../core/utils/app_button.dart';
import '../../logic/dynamic_form_cubit.dart';
import '../../logic/dynamic_form_state.dart';

class FormButtons extends StatelessWidget {
  final DynamicFormState state;
  final bool isRtl;
  final String locale;

  const FormButtons({
    super.key,
    required this.state,
    required this.isRtl,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!state.isFirstStep)
            Expanded(
              child: AppButton(
                height: 52.h,
                borderRadius: 26,
                type: AppButtonType.outlined,
                borderWidth: 1,
                onPressed: state.isSubmitting
                    ? null
                    : () => context.read<DynamicFormCubit>().previousStep(),
                text: isRtl ? 'السابق' : 'Previous',
                borderColor: AppColors.kGrayColor.withValues(alpha: .5),
                foregroundColor: AppColors.kPrimary,
              ),
            ),

          if (!state.isFirstStep) SizedBox(width: 12.w),

          Expanded(
            flex: 1,
            child: AppButton(
              height: 52.h,
              borderRadius: 26,
              type: AppButtonType.elevated,
              isLoading: state.isSubmitting,
              onPressed: () {
                if (state.isLastStep) {
                  context.read<DynamicFormCubit>().submitForm(locale);
                } else {
                  context.read<DynamicFormCubit>().nextStep(locale);
                }
              },
              text: state.isLastStep
                  ? (isRtl ? 'إرسال' : 'Submit')
                  : (isRtl ? 'التالي' : 'Next'),
              backgroundColor: AppColors.kPrimary,
              foregroundColor: AppColors.kWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

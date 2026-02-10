import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/form_schema.dart';
import '../../logic/dynamic_form_cubit.dart';
import '../../logic/dynamic_form_state.dart';
import '../widgets/form_step_indicator.dart';
import '../widgets/form_field_renderer.dart';
import '../widgets/form_navigation_buttons.dart';
import '../../../../config/colors/app_colors.dart';

class DynamicFormScreen extends StatelessWidget {
  final FormSchema formSchema;
  final String locale;
  final Function(Map<String, dynamic>)? onSubmit;

  const DynamicFormScreen({
    super.key,
    required this.formSchema,
    this.locale = 'en',
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DynamicFormCubit()..initializeForm(formSchema),
      child: Directionality(
        textDirection: locale.startsWith('ar')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: AppColors.kWhiteColor,
          appBar: AppBar(
            title: Text(
              (locale.startsWith('ar') ? 'نموذج ديناميكي' : 'Dynamic Form'),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColors.kWhiteColor,
          ),
          body: BlocConsumer<DynamicFormCubit, DynamicFormState>(
            listener: (context, state) {
              if (state.isSubmitted) {
                _showSuccessDialog(context);
                onSubmit?.call(state.formData);
              }

              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.formSchema == null) {
                return Center(
                  child: Text(
                    locale.startsWith('ar') ? 'جاري التحميل...' : 'Loading...',
                  ),
                );
              }

              final currentStepModel =
                  state.formSchema!.definition.steps[state.currentStep];
              final stepTitles = state.formSchema!.definition.steps
                  .map((step) => step.title.getLocalized(locale))
                  .toList();

              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    color: AppColors.kWhiteColor,
                    child: FormStepIndicator(
                      currentStep: state.currentStep,
                      totalSteps: state.totalSteps,
                      stepTitles: stepTitles,
                      locale: locale,
                    ),
                  ),

                  Divider(height: 1.h),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentStepModel.title.getLocalized(locale),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: 24.h),

                          _buildFormFields(currentStepModel.fields),

                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),

                  FormButtons(
                    state: state,
                    isRtl: locale.startsWith('ar'),
                    locale: locale,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(List fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: fields.map<Widget>((field) {
            return Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.only(bottom: 20.h),
              child: FormFieldRenderer(field: field, locale: locale),
            );
          }).toList(),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    final isRtl = locale.startsWith('ar');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: AppColors.kWhiteColor,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 56.sp,
                  color: AppColors.success,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                isRtl ? 'تم الإرسال بنجاح!' : 'Successfully Submitted!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                isRtl
                    ? 'تم إرسال النموذج الخاص بك بنجاح. سيتم مراجعته قريباً.'
                    : 'Your form has been submitted successfully. It will be reviewed shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close Dialog
                    Navigator.of(context).pop(); // Close Screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isRtl ? 'حسناً' : 'Done',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

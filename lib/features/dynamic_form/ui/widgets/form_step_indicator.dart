import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/colors/app_colors.dart';

class FormStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;
  final String locale;
  final Function(int)? onStepTap;

  const FormStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
    this.locale = 'en',
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (currentStep + 1) / totalSteps,
          backgroundColor: AppColors.kGrayColor.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
          minHeight: 6.h,
          borderRadius: BorderRadius.circular(3.r),
        ),

        SizedBox(height: 16.h),

        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: GestureDetector(
                onTap: onStepTap != null ? () => onStepTap!(index) : null,
                child: Column(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppColors.kPrimary
                            : AppColors.kGrayColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.kPrimary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                size: 18.sp,
                                color: AppColors.kWhiteColor,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrent || isCompleted
                                      ? AppColors.kWhiteColor
                                      : AppColors.textSecondary.withValues(
                                          alpha: 0.4,
                                        ),
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    if (stepTitles.length > index)
                      Text(
                        stepTitles[index],
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isCurrent
                              ? AppColors.kPrimary
                              : isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

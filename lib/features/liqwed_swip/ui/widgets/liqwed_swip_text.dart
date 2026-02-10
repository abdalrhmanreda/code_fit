import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/constants/app_constant.dart';
import 'package:code_fit/core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LiqwedSwipText extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const LiqwedSwipText({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),

          SizedBox(height: 10.h),

          Text(
                description,
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF757575),
                  height: 1.5,
                ),
              )
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
          SizedBox(height: 20.h),

          AppButton(
            width: AppConstant.deviceWidth(context) / 2,
            backgroundColor: AppColors.kAppBarColor,
            text: "Get Started",
            onPressed: onTap,
            borderRadius: 26.r,
            textStyle: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.kWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

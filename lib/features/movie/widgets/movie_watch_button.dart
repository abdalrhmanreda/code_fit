import 'package:code_fit/config/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieWatchButton extends StatelessWidget {
  const MovieWatchButton({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF16CAF1), Color(0xFFCC00FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16CAF1).withValues(alpha: .3),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0), // For border effect
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.kPrimary, // Inner dark background
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Center(
              child: Text(
                'Watch now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

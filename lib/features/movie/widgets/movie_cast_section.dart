import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/data/models/movie_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieCastSection extends StatelessWidget {
  final List<StaffModel> staff;

  const MovieCastSection({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextApp(
          title: 'Cast & Crew',
          size: 20,
          fontWeight: FontWeightHelper.bold,
          color: Colors.white,
        ),
        Spacing.verticalSpace(16),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: staff.length,
            itemBuilder: (context, index) {
              final member = staff[index];
              return Container(
                width: 120.w,
                margin: EdgeInsets.only(right: 16.w),
                child: Column(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF16CAF1), Color(0xFFCC00FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: EdgeInsets.all(3.r),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.all(2.r),
                        child: CircleAvatar(
                          radius: 45.r,
                          backgroundImage: member.image.isNotEmpty
                              ? NetworkImage(member.image)
                              : null,
                          backgroundColor: Colors.grey.withValues(alpha: 0.3),
                          child: member.image.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 40.sp,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Spacing.verticalSpace(12),
                    MyTextApp(
                      title: member.name,
                      size: 13,
                      fontWeight: FontWeightHelper.semiBold,
                      color: Colors.white,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      align: TextAlign.center,
                    ),
                    Spacing.verticalSpace(4),
                    MyTextApp(
                      title: member.role,
                      size: 11,
                      fontWeight: FontWeightHelper.medium,
                      color: Colors.grey.shade400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

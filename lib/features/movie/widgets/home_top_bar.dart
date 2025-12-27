import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildProfileAvatar(),
        Spacing.horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextApp(
                title: 'Welcome back',
                size: 14,
                color: AppColors.kWhiteColor.withOpacity(0.7),
              ),
              Spacing.verticalSpace(2),
              MyTextApp(
                title: 'Abdalrhman Reda',
                size: 20,
                fontWeight: FontWeightHelper.bold,
                color: AppColors.kWhiteColor,
              ),
            ],
          ),
        ),
        _buildMenuButton(),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF16CAF1), Color(0xFFCC00FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16CAF1).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.kPrimary,
        ),
        child: CircleAvatar(
          radius: 24.r,
          backgroundImage: const NetworkImage(
            'https://scontent.fcai19-11.fna.fbcdn.net/v/t39.30808-6/597660568_4175856096076900_8803484162296257962_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGZhGGL7YDRA2TCl-sWXhWREoWvNzRsMKkSha83NGwwqV9fVjKm_cTcuwAyUDbjXSPXXyOm2XqPZ6NY9aJg3u4p&_nc_ohc=c--EW5Vyz4EQ7kNvwFxeyXb&_nc_oc=AdlKj90qspoQTVptBgz8QjrfPIezgr513wrf1LQI85kg7qQfStOqXLAXKwU5J6FUyqI&_nc_zt=23&_nc_ht=scontent.fcai19-11.fna&_nc_gid=4C0Waeo1NuWYyYSde2PNcg&oh=00_AfkaLw17X8D5SU6XY1wQUVogOvDxjadGN5oFU1nnVod--g&oe=695572D7',
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          color: AppColors.kWhiteColor,
          size: 24.sp,
        ),
        onPressed: () {},
      ),
    );
  }
}

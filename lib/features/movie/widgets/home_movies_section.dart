import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/data/models/home_movie_model.dart';
import 'package:code_fit/features/movie/widgets/horizontal_list_movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeMoviesSection extends StatelessWidget {
  const HomeMoviesSection({
    super.key,
    required this.title,
    required this.movies,
    this.onViewAll,
  });

  final String title;
  final List<HomeMovieModel> movies;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionWithViewAll(title, onViewAll),
        Spacing.verticalSpace(16),
        HorizontalListMovies(movies: movies),
      ],
    );
  }

  Widget _buildSectionWithViewAll(String title, VoidCallback? onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyTextApp(
          title: title,
          size: 20,
          fontWeight: FontWeightHelper.semiBold,
          color: AppColors.kWhiteColor,
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Row(
              children: [
                MyTextApp(
                  title: 'View All',
                  size: 14,
                  fontWeight: FontWeightHelper.medium,
                  color: const Color(0xFF16CAF1),
                ),
                Spacing.horizontalSpace(4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color(0xFF16CAF1),
                  size: 14.sp,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

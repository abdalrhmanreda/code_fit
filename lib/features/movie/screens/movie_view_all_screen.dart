import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/data/models/home_movie_model.dart';
import 'package:code_fit/features/movie/widgets/movie_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieViewAllScreen extends StatelessWidget {
  const MovieViewAllScreen({
    super.key,
    required this.title,
    required this.movies,
  });

  final String title;
  final List<HomeMovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            elevation: 0,
            backgroundColor: AppColors.kPrimary,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: MyTextApp(
              title: title,
              size: 20,
              fontWeight: FontWeightHelper.bold,
              color: Colors.white,
            ),
            centerTitle: true,
            // Add a subtle bottom border when scrolling
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.kPrimary,
                    AppColors.kPrimary.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                MyTextApp(
                  title: '${movies.length} Movies',
                  size: 14,
                  color: Colors.grey.shade400,
                ),
                Spacing.verticalSpace(16),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieGridCard(movie: movies[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Spacing.verticalSpace(16);
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

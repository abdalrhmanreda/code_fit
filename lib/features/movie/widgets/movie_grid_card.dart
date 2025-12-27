import 'package:code_fit/core/constants/app_constant.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/data/models/home_movie_model.dart';
import 'package:code_fit/features/movie/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';

class MovieGridCard extends StatelessWidget {
  const MovieGridCard({super.key, required this.movie});

  final HomeMovieModel movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(id: movie.id),
          ),
        );
      },
      child: Container(
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: movie.movieImage.isNotEmpty
                  ? Image.network(
                      movie.movieImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildLoadingIndicator();
                      },
                    )
                  : _buildPlaceholder(),
            ),

            // Gradient overlay on left side for text visibility
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Play button in center
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Iconsax.play_outline,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ),

            // Rating badge at top right
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 14.sp),
                    Spacing.horizontalSpace(4),
                    MyTextApp(
                      title: '4.5',
                      size: 12,
                      fontWeight: FontWeightHelper.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            // Movie info overlay on the left
            Positioned(
              left: 16.w,
              top: 16.h,
              bottom: 16.h,
              child: SizedBox(
                width: AppConstant.deviceWidth(context) * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Movie Title
                    MyTextApp(
                      title: movie.movieName,
                      size: 18,
                      fontWeight: FontWeightHelper.bold,
                      color: Colors.white,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Bottom info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: MyTextApp(
                            title: 'Anime',
                            size: 11,
                            fontWeight: FontWeightHelper.medium,
                            color: Colors.white,
                          ),
                        ),
                        Spacing.verticalSpace(8),
                        // Year with icon
                        Row(
                          children: [
                            Icon(
                              Iconsax.calendar_outline,
                              size: 14.sp,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            Spacing.horizontalSpace(6),
                            MyTextApp(
                              title: movie.seasonYear,
                              size: 13,
                              fontWeight: FontWeightHelper.medium,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          color: Colors.white.withValues(alpha: 0.3),
          size: 50.sp,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.grey.withValues(alpha: 0.2),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF16CAF1)),
        ),
      ),
    );
  }
}

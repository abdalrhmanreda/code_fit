import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/data/models/movie_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieInfoSection extends StatelessWidget {
  final MovieDetailsModel movie;

  const MovieInfoSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: MyTextApp(
                      title: movie.title,
                      size: 32,
                      fontWeight: FontWeightHelper.bold,
                      color: Colors.white,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacing.horizontalSpace(8),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: MyTextApp(
                      title: movie.seasonYear.toString(),
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Spacing.verticalSpace(4),
              MyTextApp(
                title: movie.studios.isNotEmpty
                    ? movie.studios.first
                    : 'Unknown Studio',
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: List.generate(
                5,
                (index) =>
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
              ),
            ),
            Spacing.verticalSpace(4),
            MyTextApp(
              title: 'From ${movie.reviews.length} users',
              size: 10,
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }
}

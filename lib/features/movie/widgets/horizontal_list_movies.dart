import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/features/movie/data/models/home_movie_model.dart';
import 'package:code_fit/features/movie/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalListMovies extends StatelessWidget {
  const HorizontalListMovies({super.key, required this.movies});

  final List<HomeMovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => MovieCard(movie: movies[index]),
        separatorBuilder: (context, index) => Spacing.horizontalSpace(16),
        itemCount: movies.length,
      ),
    );
  }
}

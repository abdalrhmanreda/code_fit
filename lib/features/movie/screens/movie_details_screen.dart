import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/features/movie/data/models/movie_details_model.dart';
import 'package:code_fit/features/movie/logic/anime_cubit.dart';
import 'package:code_fit/features/movie/logic/anime_state.dart';
import 'package:code_fit/features/movie/widgets/movie_cast_section.dart';
import 'package:code_fit/features/movie/widgets/movie_description_section.dart';
import 'package:code_fit/features/movie/widgets/movie_details_app_bar.dart';
import 'package:code_fit/features/movie/widgets/movie_info_section.dart';
import 'package:code_fit/features/movie/widgets/movie_watch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, required this.id});

  final int id;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  // Dummy data for loading state
  final MovieDetailsModel _loadingMovie = MovieDetailsModel(
    siteUrl: '',
    title: 'Loading Title...',
    studios: ['Studio Name'],
    description:
        'Loading description text that is long enough to show some lines of text when the shimmer effect is active.',
    seasonYear: 2024,
    bannerImage:
        '', // Skeletonizer handles images usually, or we pass a placeholder
    staff: List.generate(
      4,
      (index) => StaffModel(name: 'Actor Name', image: '', role: 'Role'),
    ),
    reviews: List.generate(5, (index) => 5),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimeCubit()..getMovieDetail(id: widget.id),
      child: BlocBuilder<AnimeCubit, AnimeState>(
        builder: (context, state) {
          if (state is GetMovieDetailsError) {
            return Scaffold(
              backgroundColor: AppColors.kPrimary,
              body: Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          final isLoading = state is! GetMovieDetailsLoaded;
          final movie = state is GetMovieDetailsLoaded
              ? state.movie
              : _loadingMovie;

          return Scaffold(
            backgroundColor: AppColors.kPrimary,
            body: Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor: Colors.grey.withValues(alpha: 0.1),
                highlightColor: Colors.grey.withValues(alpha: 0.3),
              ),
              child: CustomScrollView(
                slivers: [
                  MovieDetailsAppBar(bannerImage: movie.bannerImage),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MovieInfoSection(movie: movie),
                          Spacing.verticalSpace(24),
                          MovieDescriptionSection(
                            description: movie.description,
                          ),
                          Spacing.verticalSpace(32),
                          MovieCastSection(staff: movie.staff),
                          Spacing.verticalSpace(40),
                          MovieWatchButton(
                            onTap: () async {
                              await launchUrl(Uri.parse(movie.siteUrl));
                            },
                          ),
                          Spacing.verticalSpace(40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

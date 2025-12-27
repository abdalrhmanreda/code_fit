import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/features/movie/data/models/home_movie_model.dart';
import 'package:code_fit/features/movie/screens/movie_view_all_screen.dart';
import 'package:code_fit/features/movie/widgets/home_categories_section.dart';
import 'package:code_fit/features/movie/widgets/home_movies_section.dart';
import 'package:code_fit/features/movie/widgets/home_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/logic/anime_cubit.dart';
import 'package:code_fit/features/movie/logic/anime_state.dart';
import 'package:code_fit/features/movie/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieHomeScreen extends StatefulWidget {
  const MovieHomeScreen({super.key});

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  Color _getAppBarColor() {
    // Transition from transparent to dark color based on scroll
    double opacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    return Color.lerp(
      Colors.transparent,
      const Color(0xFF1a1d29), // Slightly lighter dark color
      opacity,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return BlocProvider(
      create: (context) => AnimeCubit()..getHomeData(),
      child: BlocBuilder<AnimeCubit, AnimeState>(
        builder: (context, state) {
          final cubit = context.read<AnimeCubit>();
          final isLoading = state is HomeLoadingData;

          return Scaffold(
            backgroundColor: AppColors.kPrimary,
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Custom App Bar with dynamic color
                SliverAppBar(
                  expandedHeight: 90.h,
                  floating: false,
                  elevation: _scrollOffset > 10 ? 4 : 0,
                  backgroundColor: _getAppBarColor(),
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.kPrimary,
                            AppColors.kPrimary.withValues(alpha: .8),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [HomeTopBar()],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Skeletonizer(
                    containersColor: Colors.grey.withValues(alpha: .2),
                    enabled: isLoading,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Section
                          MyTextApp(
                            title: 'Search for content',
                            size: 20,
                            fontWeight: FontWeightHelper.semiBold,
                            color: AppColors.kWhiteColor,
                          ),
                          Spacing.verticalSpace(12),
                          const CustomSearchBar(),
                          Spacing.verticalSpace(32),

                          // Categories Section
                          const HomeCategoriesSection(),
                          Spacing.verticalSpace(32),

                          // Most Searched Section
                          if (isLoading || cubit.homeMovies.isNotEmpty) ...[
                            HomeMoviesSection(
                              title: 'Most Searched',
                              movies: isLoading
                                  ? _generateLoadingMovies()
                                  : cubit.homeMovies.take(10).toList(),
                              onViewAll: isLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieViewAllScreen(
                                                title: 'Most Searched',
                                                movies: cubit.homeMovies
                                                    .take(30)
                                                    .toList(),
                                              ),
                                        ),
                                      );
                                    },
                            ),
                            Spacing.verticalSpace(32),
                          ],

                          // New Releases Section
                          if (isLoading || cubit.homeMovies.length > 10) ...[
                            HomeMoviesSection(
                              title: 'New Releases',
                              movies: isLoading
                                  ? _generateLoadingMovies()
                                  : cubit.homeMovies.skip(10).take(30).toList(),
                              onViewAll: isLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieViewAllScreen(
                                                title: 'New Releases',
                                                movies: cubit.homeMovies
                                                    .skip(10)
                                                    .take(30)
                                                    .toList(),
                                              ),
                                        ),
                                      );
                                    },
                            ),
                            Spacing.verticalSpace(32),
                          ],

                          // Top Rated Section
                          if (isLoading || cubit.homeMovies.length > 20) ...[
                            HomeMoviesSection(
                              title: 'Top Rated',
                              movies: isLoading
                                  ? _generateLoadingMovies()
                                  : cubit.homeMovies.skip(20).take(10).toList(),
                              onViewAll: isLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieViewAllScreen(
                                                title: 'Top Rated',
                                                movies: cubit.homeMovies
                                                    .skip(20)
                                                    .take(10)
                                                    .toList(),
                                              ),
                                        ),
                                      );
                                    },
                            ),
                            Spacing.verticalSpace(32),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<HomeMovieModel> _generateLoadingMovies() {
    return List.generate(
      10,
      (index) => HomeMovieModel(
        movieName: 'Loading Movie Title',
        seasonYear: '2024',
        movieImage: '',
        id: 0,
      ),
    );
  }
}

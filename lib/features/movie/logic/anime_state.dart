import 'package:code_fit/features/movie/data/models/home_movie_model.dart';
import 'package:code_fit/features/movie/data/models/movie_details_model.dart';

abstract class AnimeState {}

final class AnimeInitialState extends AnimeState {}

final class HomeLoadingData extends AnimeState {}

final class HomeLoadedData extends AnimeState {
  final List<HomeMovieModel> homeMovies;

  HomeLoadedData({required this.homeMovies});
}

final class HomeErrorData extends AnimeState {
  final String error;

  HomeErrorData({required this.error});
}

final class GetMovieDetailsLoading extends AnimeState {}

final class GetMovieDetailsLoaded extends AnimeState {
  final MovieDetailsModel movie;

  GetMovieDetailsLoaded({required this.movie});
}

final class GetMovieDetailsError extends AnimeState {
  final String error;

  GetMovieDetailsError({required this.error});
}

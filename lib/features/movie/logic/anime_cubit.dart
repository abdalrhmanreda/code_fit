import 'package:code_fit/core/helpers/graphql_helper.dart';
import 'package:code_fit/features/movie/data/models/home_movie_model.dart';
import 'package:code_fit/features/movie/data/models/movie_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'anime_state.dart';

class AnimeCubit extends Cubit<AnimeState> {
  AnimeCubit() : super(AnimeInitialState());
  String getAnimationInHomeScreen = """
  query getAnimationInHomeScreen {
    Page(perPage: 100) {
      media {
        siteUrl
        title {
          english
        }
        id
        seasonYear
        bannerImage
      }
    }
  }
""";
  List<HomeMovieModel> homeMovies = [];
  void getHomeData() async {
    emit(HomeLoadingData());
    final respose = await GraphqlHelper.client.value.query(
      QueryOptions(document: gql(getAnimationInHomeScreen)),
    );
    if (respose.hasException) {
      emit(HomeErrorData(error: respose.exception.toString()));
    } else {
      var data = respose.data!['Page']['media'];
      homeMovies = [];
      for (var element in data) {
        if (element['title']['english'] != null &&
            element['bannerImage'] != null) {
          homeMovies.add(
            HomeMovieModel(
              movieName: element['title']['english'],
              seasonYear: element['seasonYear']?.toString() ?? 'Unknown',
              movieImage: element['bannerImage'],
              id: element['id'],
            ),
          );
        }
      }
      emit(HomeLoadedData(homeMovies: homeMovies));
    }
  }

  String getMovieDetails = """
query getMovieDetails(\$id: Int) {
  Media(id: \$id) {
    siteUrl
    title {
      english
    }
    studios {
      nodes {
        name
      }
    }
    description
    seasonYear
    bannerImage
    staff {
      edges {
      role
        node {
          name {
            first 
            last
          }
          image {
            medium
          }
        }
      }
    }
    reviews {
      nodes {
        ratingAmount
      }
    }
  }
}
""";

  MovieDetailsModel? movieDetailsModel;
  void getMovieDetail({required int id}) async {
    emit(GetMovieDetailsLoading());
    final result = await GraphqlHelper.client.value.query(
      QueryOptions(document: gql(getMovieDetails), variables: {'id': id}),
    );
    if (result.hasException) {
      emit(GetMovieDetailsError(error: result.exception.toString()));
    } else {
      if (result.data?['Media'] != null) {
        movieDetailsModel = MovieDetailsModel.fromJson(result.data!['Media']);
        emit(GetMovieDetailsLoaded(movie: movieDetailsModel!));
      } else {
        emit(GetMovieDetailsError(error: "No data found"));
      }
    }
  }
}

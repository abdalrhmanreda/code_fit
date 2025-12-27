class HomeMovieModel {
  final String movieName;
  final String seasonYear;
  final String movieImage;
  final int id;

  HomeMovieModel({
    required this.movieName,
    required this.seasonYear,
    required this.movieImage,
    required this.id,
  });
  HomeMovieModel.fromJson(Map<String, dynamic> json)
    : movieName = json['movieName'],
      seasonYear = json['seasonYear'],
      movieImage = json['movieImage'],
      id = json['id'];
}

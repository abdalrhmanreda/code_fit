class MovieDetailsModel {
  final String siteUrl;
  final String title;
  final List<String> studios;
  final String description;
  final int seasonYear;
  final String bannerImage;
  final List<StaffModel> staff;
  final List<int> reviews;

  MovieDetailsModel({
    required this.siteUrl,
    required this.title,
    required this.studios,
    required this.description,
    required this.seasonYear,
    required this.bannerImage,
    required this.staff,
    required this.reviews,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      siteUrl: json['siteUrl'] ?? '',
      title: json['title']?['english'] ?? 'Unknown',
      studios:
          (json['studios']?['nodes'] as List?)
              ?.map((e) => e['name'] as String)
              .toList() ??
          [],
      description: json['description'] ?? '',
      seasonYear: json['seasonYear'] ?? 0,
      bannerImage: json['bannerImage'] ?? '',
      staff:
          (json['staff']?['edges'] as List?)
              ?.map((e) => StaffModel.fromJson(e))
              .toList() ??
          [],
      reviews:
          (json['reviews']?['nodes'] as List?)
              ?.map((e) => e['ratingAmount'] as int)
              .toList() ??
          [],
    );
  }
}

class StaffModel {
  final String name;
  final String image;
  final String role;

  StaffModel({required this.name, required this.image, required this.role});

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    final nodeData = json['node'];
    final nameData = nodeData?['name'];
    final first = nameData?['first'] ?? '';
    final last = nameData?['last'] ?? '';

    return StaffModel(
      name: '$first $last'.trim(),
      image: nodeData?['image']?['medium'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

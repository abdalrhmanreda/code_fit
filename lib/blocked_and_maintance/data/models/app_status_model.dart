class AppStatusModel {
  final bool? isBlocked;
  final bool? isMantainance;

  AppStatusModel({this.isBlocked, this.isMantainance});

  factory AppStatusModel.fromJson(Map<String, dynamic> json) {
    return AppStatusModel(
      isBlocked: json['isBlocked'] as bool?,
      isMantainance: json['isMantainance'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'isBlocked': isBlocked, 'isMantainance': isMantainance};
  }
}

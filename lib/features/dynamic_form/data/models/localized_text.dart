class LocalizedText {
  final String en;
  final String ar;

  const LocalizedText({required this.en, required this.ar});

  String getLocalized(String locale) {
    return locale.startsWith('ar') ? ar : en;
  }

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      en: json['en'] as String? ?? '',
      ar: json['ar'] as String? ?? '',
    );
  }

  factory LocalizedText.fromString(String value) {
    return LocalizedText(en: value, ar: value);
  }

  Map<String, dynamic> toJson() {
    return {'en': en, 'ar': ar};
  }
}

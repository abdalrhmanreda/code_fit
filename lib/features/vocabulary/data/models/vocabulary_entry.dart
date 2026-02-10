class VocabularyEntry {
  final int id;
  final String word;
  final String meaning;
  final String exampleSentence;
  final DateTime dateAdded;

  VocabularyEntry({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.dateAdded,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'exampleSentence': exampleSentence,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // Convert to Map for insertion (excludes id to let SQLite auto-generate)
  Map<String, dynamic> toMapForInsert() {
    return {
      'word': word,
      'meaning': meaning,
      'exampleSentence': exampleSentence,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // Create from Map
  factory VocabularyEntry.fromMap(Map<String, dynamic> map) {
    return VocabularyEntry(
      id: map['id'] as int,
      word: map['word'] as String,
      meaning: map['meaning'] as String,
      exampleSentence: map['exampleSentence'] as String,
      dateAdded: DateTime.parse(map['dateAdded'] as String),
    );
  }

  // CopyWith method
  VocabularyEntry copyWith({
    int? id,
    String? word,
    String? meaning,
    String? exampleSentence,
    DateTime? dateAdded,
  }) {
    return VocabularyEntry(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

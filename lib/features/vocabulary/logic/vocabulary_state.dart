part of 'vocabulary_cubit.dart';

abstract class VocabularyState extends Equatable {
  const VocabularyState();

  @override
  List<Object?> get props => [];
}

class VocabularyInitial extends VocabularyState {}

class VocabularyLoading extends VocabularyState {}

class VocabularyLoaded extends VocabularyState {
  final List<VocabularyEntry> entries;
  final int totalCount;
  final int weekCount;

  const VocabularyLoaded({
    required this.entries,
    required this.totalCount,
    required this.weekCount,
  });

  @override
  List<Object?> get props => [entries, totalCount, weekCount];
}

class VocabularySearchResults extends VocabularyState {
  final List<VocabularyEntry> results;

  const VocabularySearchResults({required this.results});

  @override
  List<Object?> get props => [results];
}

class VocabularyError extends VocabularyState {
  final String message;

  const VocabularyError({required this.message});

  @override
  List<Object?> get props => [message];
}

class VocabularyDuplicateError extends VocabularyState {
  final String word;

  const VocabularyDuplicateError({required this.word});

  @override
  List<Object?> get props => [word];
}

class VocabularySuccess extends VocabularyState {
  final String message;
  final VocabularyEntry? entry;

  const VocabularySuccess({required this.message, this.entry});

  @override
  List<Object?> get props => [message, entry];
}

class VocabularyExporting extends VocabularyState {}

class VocabularyExported extends VocabularyState {
  final String filePath;
  final int count;

  const VocabularyExported({required this.filePath, required this.count});

  @override
  List<Object?> get props => [filePath, count];
}

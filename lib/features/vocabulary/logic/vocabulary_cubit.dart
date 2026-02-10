import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/database/vocabulary_database.dart';
import '../data/models/vocabulary_entry.dart';
import '../data/services/excel_service.dart';

part 'vocabulary_state.dart';

class VocabularyCubit extends Cubit<VocabularyState> {
  final VocabularyDatabase _database;
  final ExcelService _excelService;

  VocabularyCubit({VocabularyDatabase? database, ExcelService? excelService})
    : _database = database ?? VocabularyDatabase.instance,
      _excelService = excelService ?? ExcelService(),
      super(VocabularyInitial());

  // Load all entries
  Future<void> loadEntries() async {
    try {
      emit(VocabularyLoading());
      final entries = await _database.readAllEntries();
      final totalCount = await _database.getCount();
      final weekCount = await _database.getWeekCount();

      emit(
        VocabularyLoaded(
          entries: entries,
          totalCount: totalCount,
          weekCount: weekCount,
        ),
      );
    } catch (e) {
      emit(VocabularyError(message: 'Failed to load vocabulary: $e'));
    }
  }

  // Add new entry
  Future<void> addEntry({
    required String word,
    required String meaning,
    String? exampleSentence,
  }) async {
    try {
      // Check for duplicate
      final exists = await _database.wordExists(word);
      if (exists) {
        emit(VocabularyDuplicateError(word: word));
        await loadEntries(); // Reload to show existing data
        return;
      }

      // Create new entry
      final entry = VocabularyEntry(
        id: 0, // Will be auto-generated
        word: word.trim(),
        meaning: meaning.trim(),
        exampleSentence: exampleSentence?.trim() ?? 'N/A',
        dateAdded: DateTime.now(),
      );

      final createdEntry = await _database.create(entry);

      emit(
        VocabularySuccess(
          message: 'Word added successfully!',
          entry: createdEntry,
        ),
      );

      // Reload entries
      await loadEntries();
    } catch (e) {
      emit(VocabularyError(message: 'Failed to add word: $e'));
    }
  }

  // Delete entry
  Future<void> deleteEntry(int id) async {
    try {
      await _database.delete(id);
      emit(const VocabularySuccess(message: 'Word deleted successfully!'));
      await loadEntries();
    } catch (e) {
      emit(VocabularyError(message: 'Failed to delete word: $e'));
    }
  }

  // Delete all entries
  Future<void> deleteAllEntries() async {
    try {
      await _database.deleteAll();
      emit(const VocabularySuccess(message: 'All words deleted!'));
      await loadEntries();
    } catch (e) {
      emit(VocabularyError(message: 'Failed to delete all words: $e'));
    }
  }

  // Search entries
  Future<void> searchEntries(String query) async {
    try {
      if (query.trim().isEmpty) {
        await loadEntries();
        return;
      }

      final results = await _database.searchEntries(query);
      emit(VocabularySearchResults(results: results));
    } catch (e) {
      emit(VocabularyError(message: 'Search failed: $e'));
    }
  }

  // Export to Excel
  Future<void> exportToExcel() async {
    try {
      emit(VocabularyExporting());

      final entries = await _database.readAllEntries();

      if (entries.isEmpty) {
        emit(const VocabularyError(message: 'No data to export!'));
        await loadEntries();
        return;
      }

      // Sort by ID ascending for export
      entries.sort((a, b) => a.id.compareTo(b.id));

      final filePath = await _excelService.exportToExcel(entries);

      if (filePath != null) {
        emit(VocabularyExported(filePath: filePath, count: entries.length));
      } else {
        emit(const VocabularyError(message: 'Export failed!'));
      }

      await loadEntries();
    } catch (e) {
      emit(VocabularyError(message: 'Export failed: $e'));
      await loadEntries();
    }
  }

  // Get statistics
  Future<Map<String, int>> getStatistics() async {
    final totalCount = await _database.getCount();
    final weekCount = await _database.getWeekCount();
    return {'total': totalCount, 'week': weekCount};
  }
}

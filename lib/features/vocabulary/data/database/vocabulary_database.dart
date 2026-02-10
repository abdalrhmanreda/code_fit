import 'package:sqflite/sqflite.dart';
import '../models/vocabulary_entry.dart';

class VocabularyDatabase {
  static final VocabularyDatabase instance = VocabularyDatabase._init();
  static Database? _database;

  VocabularyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vocabulary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$filePath';

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE vocabulary (
        id $idType,
        word $textType,
        meaning $textType,
        exampleSentence $textType,
        dateAdded $textType
      )
    ''');
  }

  // Create
  Future<VocabularyEntry> create(VocabularyEntry entry) async {
    final db = await instance.database;
    final id = await db.insert('vocabulary', entry.toMapForInsert());
    return entry.copyWith(id: id);
  }

  // Read single entry
  Future<VocabularyEntry?> readEntry(int id) async {
    final db = await instance.database;
    final maps = await db.query('vocabulary', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return VocabularyEntry.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Read all entries
  Future<List<VocabularyEntry>> readAllEntries() async {
    final db = await instance.database;
    const orderBy = 'id DESC';
    final result = await db.query('vocabulary', orderBy: orderBy);
    return result.map((json) => VocabularyEntry.fromMap(json)).toList();
  }

  // Check if word exists (for duplicate detection)
  Future<bool> wordExists(String word) async {
    final db = await instance.database;
    final result = await db.query(
      'vocabulary',
      where: 'LOWER(word) = ?',
      whereArgs: [word.toLowerCase()],
    );
    return result.isNotEmpty;
  }

  // Update
  Future<int> update(VocabularyEntry entry) async {
    final db = await instance.database;
    return db.update(
      'vocabulary',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // Delete
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('vocabulary', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all
  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete('vocabulary');
  }

  // Get total count
  Future<int> getCount() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM vocabulary',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Get count for last 7 days
  Future<int> getWeekCount() async {
    final db = await instance.database;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM vocabulary WHERE dateAdded >= ?',
      [weekAgo.toIso8601String()],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Search entries
  Future<List<VocabularyEntry>> searchEntries(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'vocabulary',
      where:
          'LOWER(word) LIKE ? OR LOWER(meaning) LIKE ? OR LOWER(exampleSentence) LIKE ?',
      whereArgs: [
        '%${query.toLowerCase()}%',
        '%${query.toLowerCase()}%',
        '%${query.toLowerCase()}%',
      ],
      orderBy: 'id DESC',
    );
    return result.map((json) => VocabularyEntry.fromMap(json)).toList();
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

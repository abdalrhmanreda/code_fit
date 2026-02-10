import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/vocabulary_entry.dart';
import 'package:intl/intl.dart';

class ExcelService {
  Future<String?> exportToExcel(List<VocabularyEntry> entries) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        if (await Permission.storage.request().isGranted ||
            await Permission.manageExternalStorage.request().isGranted) {
          return await _generateExcelFile(entries);
        } else {
          throw Exception('Storage permission denied');
        }
      } else {
        return await _generateExcelFile(entries);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _generateExcelFile(List<VocabularyEntry> entries) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Vocabulary'];

    // Set column widths
    sheetObject.setColumnWidth(0, 8); // ID
    sheetObject.setColumnWidth(1, 20); // Word
    sheetObject.setColumnWidth(2, 30); // Meaning
    sheetObject.setColumnWidth(3, 40); // Example
    sheetObject.setColumnWidth(4, 15); // Date

    // Add header row with styling
    List<String> headers = [
      'ID',
      'Word',
      'Meaning',
      'Example Sentence',
      'Date Added',
    ];

    for (var i = 0; i < headers.length; i++) {
      var cell = sheetObject.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        backgroundColorHex: ExcelColor.fromHexString('#7C3AED'),
        fontColorHex: ExcelColor.white,
      );
    }

    // Add data rows
    for (var i = 0; i < entries.length; i++) {
      var entry = entries[i];
      var rowIndex = i + 1;

      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = IntCellValue(
        entry.id,
      );

      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = TextCellValue(
        entry.word,
      );

      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = TextCellValue(
        entry.meaning,
      );

      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = TextCellValue(
        entry.exampleSentence,
      );

      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value = TextCellValue(
        DateFormat('yyyy-MM-dd').format(entry.dateAdded),
      );
    }

    // Get the directory to save the file
    Directory? directory;

    if (Platform.isAndroid) {
      // Try multiple Download folder paths for Android
      final downloadPaths = [
        Directory('/storage/emulated/0/Download'),
        Directory('/storage/emulated/0/Downloads'),
      ];

      directory = null;
      for (var path in downloadPaths) {
        if (await path.exists()) {
          directory = path;
          break;
        }
      }

      // If Download folder not found, create it or use external storage
      if (directory == null) {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Try to create Downloads folder in app's external directory
          final downloadsDir = Directory('${externalDir.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          directory = downloadsDir;
        } else {
          // Fallback to app documents
          directory = await getApplicationDocumentsDirectory();
        }
      }
    } else if (Platform.isIOS) {
      // For iOS, use Documents directory (accessible via Files app)
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      // For desktop platforms (macOS, Linux, Windows)
      // Try to use the Downloads folder
      final home =
          Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      if (home != null) {
        final downloadsDir = Directory('$home/Downloads');
        if (await downloadsDir.exists()) {
          directory = downloadsDir;
        } else {
          // Fallback to Documents if Downloads doesn't exist
          directory = await getApplicationDocumentsDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
    } else {
      // Fallback for any other platform
      directory = await getApplicationDocumentsDirectory();
    }

    // Create file name with current date
    final now = DateTime.now();
    final fileName =
        'vocabulary_${DateFormat('yyyy-MM-dd_HHmmss').format(now)}.xlsx';
    final filePath = '${directory.path}/$fileName';

    // Save the file
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }

    // For iOS simulator or when running on macOS, also copy to user's Downloads
    if (Platform.isIOS || Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home != null) {
        final userDownloads = Directory('$home/Downloads');
        if (await userDownloads.exists()) {
          final userFilePath = '${userDownloads.path}/$fileName';
          try {
            // Copy the file to user's Downloads folder
            await File(filePath).copy(userFilePath);
            // Return the user-accessible path instead
            return userFilePath;
          } catch (e) {
            // If copy fails, return original path
            return filePath;
          }
        }
      }
    }

    // Return user-friendly path
    return filePath;
  }
}

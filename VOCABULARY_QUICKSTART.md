# 📚 Vocabulary Assistant - Quick Start Guide

## ⚡ Quick Setup

### 1. Android Permissions (IMPORTANT for Excel Export)

Add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permission lines -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
    
    <application
        android:label="code_fit"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:requestLegacyExternalStorage="true">
        <!-- Your existing application content -->
    </application>
</manifest>
```

### 2. Run the App

```bash
# Method 1: Run as standalone vocabulary app
flutter run lib/vocabulary_main.dart

# Method 2: Integrate into your existing app (see below)
```

## 🔧 Integration into Existing App

### Option A: Add as a new route

In your `app.dart` or router file:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/vocabulary/logic/vocabulary_cubit.dart';
import 'features/vocabulary/ui/screens/vocabulary_screen.dart';

// Then in your routes:
'/vocabulary': (context) => BlocProvider(
  create: (context) => VocabularyCubit(),
  child: const VocabularyScreen(),
),
```

### Option B: Add as a navigation destination

```dart
// In your navigation widget:
ListTile(
  leading: const Icon(Icons.book),
  title: const Text('Vocabulary'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => VocabularyCubit(),
          child: const VocabularyScreen(),
        ),
      ),
    );
  },
),
```

## 📋 Features Checklist

✅ Add English words with meanings (EN/AR)  
✅ Add optional example sentences  
✅ Auto-incrementing IDs  
✅ Date tracking  
✅ Duplicate word detection  
✅ Search functionality  
✅ Statistics (total words, this week)  
✅ Excel export (.xlsx)  
✅ Delete individual words  
✅ Clear all words  
✅ SQLite local storage  
✅ Beautiful dark themed UI  
✅ Smooth animations  

## 🎯 Usage Example

```dart
// 1. User opens the vocabulary screen
// 2. Fills in the form:
//    - Word: "Serendipity"
//    - Meaning: "The occurrence of events by chance in a happy way"
//    - Example: "Finding this app was pure serendipity!"
// 3. Taps "Add Word"
// 4. Word is saved with:
//    - ID: 1 (auto-generated)
//    - Date: 2025-12-27 (automatically added)
// 5. Word appears in the list below
// 6. User can search, export, or delete later
```

## 📊 Excel Export Location

### Android
- **Downloads folder**: `/storage/emulated/0/Download/vocabulary_YYYY-MM-DD_HHMMSS.xlsx`
- Access via Files app → Downloads

### iOS  
- **Documents folder**: App's document directory
- Access via Files app → On My iPhone → code_fit

## 🎨 Customization

### Change Theme Colors

Edit `vocabulary_screen.dart`:

```dart
// Primary color (currently purple)
backgroundColor: const Color(0xFF7C3AED)  // Change hex value

// Success color (currently green)  
backgroundColor: const Color(0xFF22C55E)  // Change hex value

// Background colors
backgroundColor: const Color(0xFF0F0F14)  // Main background
color: const Color(0xFF1A1A24)           // Card background
```

### Change App Title

```dart
// In vocabulary_screen.dart, find:
Text('Vocabulary Assistant')
// Change to whatever you want
```

## 🐛 Troubleshooting

### Excel export not working?
1. Check Android permissions in AndroidManifest.xml
2. Grant storage permission when prompted
3. Check device storage space

### Database not saving?
- The app uses SQLite which is automatically configured
- Data persists between app restarts
- Database location: App's databases folder

### Build errors?
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Testing Guide

1. **Add a word** - Verify it appears in the list
2. **Add duplicate** - Should show error message
3. **Search** - Type partial word, should filter
4. **Export** - Check Downloads folder for Excel file
5. **Delete** - Remove a word, verify it's gone
6. **Clear all** - Confirm all words deleted
7. **Restart app** - Data should persist

## 🚀 Performance Tips

- The app can handle thousands of words efficiently
- Search is optimized with SQLite LIKE queries
- Excel exports are generated in background
- All UI operations are smooth and responsive

## 📞 Support

For issues or questions:
1. Check the README.md file
2. Review the code comments
3. Examine the feature structure

---

**Enjoy building your vocabulary! 🎓📖**

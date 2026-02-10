# 📚 English Vocabulary Assistant

A beautiful Flutter application to help you record, manage, and export your English vocabulary learning journey.

## ✨ Features

### 📝 Word Management
- **Add New Words**: Record English words with their meanings (in English or Arabic)
- **Example Sentences**: Add optional example sentences to better understand word usage
- **Auto-increment IDs**: Each word gets a unique sequential ID automatically
- **Date Tracking**: Automatically records when each word was added

### 🔍 Smart Features
- **Duplicate Detection**: Prevents adding the same word twice
- **Live Search**: Instantly search through words, meanings, and examples
- **Statistics**: View total words and this week's additions at a glance

### 📊 Data Management
- **Excel Export**: Export all vocabulary to a formatted Excel file (.xlsx)
- **Local Database**: All data stored locally using SQLite
- **Delete Operations**: Delete individual words or clear entire vocabulary
- **Persistent Storage**: Your data is saved automatically

### 🎨 Modern UI
- **Dark Theme**: Beautiful purple-themed dark interface
- **Smooth Animations**: Polished transitions and micro-interactions
- **Responsive Design**: Works great on all screen sizes
- **Premium Aesthetics**: Modern gradient effects and glassmorphism

## 📱 Screenshots

[Your vocabulary is displayed in beautiful cards with:]
- Word ID badge
- Word name in prominent purple text
- Meaning with lightbulb icon
- Example sentence (if provided)
- Date added
- Delete button

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart 3.0 or higher

### Installation

1. **Install dependencies:**
```bash
flutter pub get
```

2. **Run the app:**
```bash
# To run the full app
flutter run

# To run only the vocabulary assistant
flutter run lib/vocabulary_main.dart
```

### Android Permissions

For Excel export on Android, add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

For Android 11+, also add:
```xml
<application
    android:requestLegacyExternalStorage="true"
    ...>
```

## 📖 How to Use

### Adding a New Word
1. Enter the English word in the first field
2. Enter the meaning (in English or Arabic) in the second field
3. Optionally add an example sentence
4. Tap "Add Word"
5. The word will be saved and displayed in the list below

### Searching Words
- Type in the search box to filter words by word, meaning, or example
- Search is case-insensitive and searches all fields

### Exporting to Excel
1. Tap the "Export Excel" button
2. Grant storage permissions if prompted
3. File will be saved to your Downloads folder (Android) or Documents (iOS)
4. File name format: `vocabulary_YYYY-MM-DD_HHMMSS.xlsx`

### Deleting Words
- **Single word**: Tap the trash icon on any word card
- **All words**: Tap "Clear All" button and confirm

## 🏗️ Project Structure

```
lib/features/vocabulary/
├── data/
│   ├── database/
│   │   └── vocabulary_database.dart      # SQLite database operations
│   ├── models/
│   │   └── vocabulary_entry.dart         # Vocabulary entry model
│   └── services/
│       └── excel_service.dart            # Excel export functionality
├── logic/
│   ├── vocabulary_cubit.dart             # State management
│   └── vocabulary_state.dart             # State definitions
└── ui/
    └── screens/
        └── vocabulary_screen.dart        # Main UI screen
```

## 🛠️ Tech Stack

- **Flutter & Dart**: Cross-platform mobile development
- **flutter_bloc**: State management with Cubit
- **sqflite**: Local SQLite database
- **excel**: Excel file generation
- **path_provider**: File system access
- **permission_handler**: Storage permissions
- **intl**: Date formatting

## 📊 Database Schema

### vocabulary table
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Auto-increment unique ID |
| word | TEXT NOT NULL | English word |
| meaning | TEXT NOT NULL | Word meaning (EN/AR) |
| exampleSentence | TEXT NOT NULL | Example sentence or 'N/A' |
| dateAdded | TEXT | ISO 8601 date string |

## 🎯 Features in Detail

### State Management
The app uses **Cubit** (from flutter_bloc) for state management with the following states:
- `VocabularyInitial`: Initial state
- `VocabularyLoading`: Loading data
- `VocabularyLoaded`: Data loaded successfully
- `VocabularySearchResults`: Search results available
- `VocabularySuccess`: Operation successful
- `VocabularyDuplicateError`: Duplicate word detected
- `VocabularyError`: Error occurred
- `VocabularyExporting`: Exporting to Excel
- `VocabularyExported`: Export completed

### Excel Export Format
- **Header Row**: Styled with purple background and white text
- **Columns**: ID, Word, Meaning, Example Sentence, Date Added
- **Column Widths**: Optimized for readability
- **Data**: Sorted by ID in ascending order

## 🎨 Color Palette

- **Primary Purple**: `#7C3AED`
- **Light Purple**: `#9D5CFF`
- **Success Green**: `#22C55E`
- **Danger Red**: `#EF4444`
- **Background Dark**: `#0F0F14`
- **Surface**: `#1A1A24`
- **Border**: `#2A2A38`

## 🤝 Contributing

Feel free to fork this project and customize it for your needs!

## 📝 License

This project is open source and available for personal and educational use.

---

**Happy Learning! 📚✨**

Made with ❤️ using Flutter

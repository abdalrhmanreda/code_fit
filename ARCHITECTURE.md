# Code Fit Architecture Documentation

## 🏛️ Core Architectural Principles

This project strictly follows these **NON-NEGOTIABLE** rules learned from refactoring a 248-file Flutter project:

### Rule #1: File Size Limit ⚠️
- **NEVER** create files exceeding 250 lines
- Split files at 200 lines
- Break large screens into multiple widget files

### Rule #2: No Widget-Returning Methods 🚫

**FORBIDDEN:**
```dart
Widget _buildCard() {
  return Card(...);
}
```

**REQUIRED:**
```dart
// Create separate file: card_widget.dart
class CardWidget extends StatelessWidget {
  const CardWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(...);
  }
}
```

**Why:** Methods returning widgets prevent optimization, reduce reusability, and hurt performance.

### Rule #3: DRY Principle
- ❌ Never duplicate code
- ✅ Extract all reusable widgets to `shared/widgets/`
- ✅ Extract repeated logic to `core/utils/`
- ✅ Create base classes for similar components

### Rule #4: Constants Extraction
- ❌ No hardcoded values in UI code
- ✅ All colors in `app_colors.dart`
- ✅ All dimensions in `app_dimensions.dart`
- ✅ All strings in `app_strings.dart`
- ✅ All durations in `app_durations.dart`

## 📂 Detailed Folder Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Root widget configuration
│
├── config/                      # App-level configuration
│   ├── routes/
│   │   ├── app_router.dart     # Navigation routing
│   │   └── route_names.dart    # Route name constants
│   └── themes/
│       └── app_theme.dart      # Light/dark theme config
│
├── core/                        # Core functionality (no UI)
│   ├── constants/              # All app constants
│   │   ├── app_colors.dart
│   │   ├── app_dimensions.dart
│   │   ├── app_strings.dart
│   │   ├── app_durations.dart
│   │   ├── app_curves.dart
│   │   ├── app_images.dart
│   │   └── app_icons.dart
│   │
│   ├── utils/                  # Utility classes
│   │   ├── xp_calculator.dart
│   │   ├── streak_calculator.dart
│   │   ├── progress_calculator.dart
│   │   └── date_formatter.dart
│   │
│   ├── extensions/             # Dart extensions
│   │   ├── context_extension.dart
│   │   ├── string_extension.dart
│   │   └── datetime_extension.dart
│   │
│   └── services/              # Core services
│       └── storage_service.dart
│
├── shared/                     # Shared across features
│   └── widgets/               # Reusable UI components
│       ├── buttons/
│       │   ├── primary_button.dart
│       │   ├── secondary_button.dart
│       │   └── icon_button_widget.dart
│       │
│       ├── cards/
│       │   ├── milestone_card.dart
│       │   ├── progress_card.dart
│       │   └── achievement_card.dart
│       │
│       ├── progress/
│       │   ├── linear_progress_bar.dart
│       │   ├── circular_progress_widget.dart
│       │   └── xp_progress_bar.dart
│       │
│       └── ...
│
└── features/                   # Feature modules
    ├── splash/
    │   └── ui/
    │       └── screens/
    │           └── splash_screen.dart
    │
    ├── onboarding/
    │   └── ui/
    │       ├── screens/
    │       │   └── onboarding_screen.dart
    │       └── widgets/
    │           ├── onboarding_page_widget.dart
    │           └── page_indicator_widget.dart
    │
    ├── home/
    │   └── ui/
    │       └── screens/
    │           └── home_screen.dart
    │
    ├── roadmap/
    │   ├── data/
    │   │   └── models/
    │   │       ├── phase_model.dart
    │   │       ├── milestone_model.dart
    │   │       └── checkpoint_model.dart
    │   └── ui/
    │       ├── screens/
    │       │   └── roadmap_screen.dart
    │       └── widgets/
    │           ├── phase_card_widget.dart
    │           └── roadmap_header_widget.dart
    │
    ├── achievements/
    │   ├── data/
    │   │   └── models/
    │   │       └── achievement_model.dart
    │   └── ui/
    │       ├── screens/
    │       │   └── achievements_screen.dart
    │       └── widgets/
    │           └── achievement_card_widget.dart
    │
    └── profile/
        └── ui/
            ├── screens/
            │   └── profile_screen.dart
            └── widgets/
                ├── profile_header_widget.dart
                └── profile_stat_widget.dart
```

## 🎨 Widget Hierarchy Best Practices

### ✅ Good Example

```dart
// main_screen.dart (< 250 lines)
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          HeaderWidget(),
          ContentListWidget(),
          FooterWidget(),
        ],
      ),
    );
  }
}

// header_widget.dart
class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          LogoWidget(),
          TitleWidget(),
        ],
      ),
    );
  }
}
```

### ❌ Bad Example

```dart
// main_screen.dart (500+ lines, methods returning widgets)
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          _buildContent(),
          _buildFooter(),
        ],
      ),
    );
  }
  
  Widget _buildAppBar() { ... }  // ❌ BAD
  Widget _buildHeader() { ... }  // ❌ BAD
  Widget _buildContent() { ... } // ❌ BAD
  Widget _buildFooter() { ... }  // ❌ BAD
}
```

## 🎯 Constants Usage

### Colors Example
```dart
// ✅ Good
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textWhite),
  ),
)

// ❌ Bad
Container(
  color: Color(0xFF2196F3),
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.white),
  ),
)
```

### Dimensions Example
```dart
// ✅ Good
Padding(
  padding: EdgeInsets.all(AppDimensions.paddingMedium),
  child: Container(
    height: AppDimensions.buttonHeightMedium,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
    ),
  ),
)

// ❌ Bad
Padding(
  padding: EdgeInsets.all(16.0),
  child: Container(
    height: 48.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
)
```

## 🔄 Data Flow

```
┌─────────────────┐
│  Splash Screen  │
└────────┬────────┘
         │
    ┌────▼─────────┐
    │ Onboarding   │ (First time only)
    └────┬─────────┘
         │
    ┌────▼──────────┐
    │  Home Screen  │
    │ (BottomNavBar)│
    └───┬───┬───┬───┘
        │   │   │
  ┌─────▼┐ ┌▼──────┐ ┌──────▼┐
  │Roadmap│ │Achieve│ │Profile│
  └───────┘ └───────┘ └───────┘
```

## 💾 State Management Strategy

- **Local State**: `setState()` for simple UI updates
- **Bloc Pattern**: Ready for implementation with flutter_bloc
- **Storage**: SharedPreferences for persistence

## 📦 Models Pattern

All models follow this pattern:
```dart
class SomeModel extends Equatable {
  final String id;
  final String titleEn;
  final String titleAr;
  
  const SomeModel({...});
  
  // Getters
  String getTitle(String languageCode) => 
    languageCode == 'ar' ? titleAr : titleEn;
  
  // Copy with
  SomeModel copyWith({...}) => SomeModel(...);
  
  // Serialization
  factory SomeModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
  
  // Equatable
  @override
  List<Object?> get props => [...];
}
```

## 🚀 Performance Considerations

1. **Const Constructors**: All stateless widgets use const constructors
2. **Widget Separation**: Reduces rebuild scope
3. **Optimized Animations**: Use AnimatedContainer, AnimatedOpacity
4. **Lazy Loading**: Lists use efficient builders
5. **Image Optimization**: Assets properly sized

## 🧪 Testing Strategy

- **Unit Tests**: Utilities and calculators
- **Widget Tests**: Individual widgets
- **Integration Tests**: Feature flows

## 📝 Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE`
- **Widget Files**: End with `_widget.dart`
- **Screen Files**: End with `_screen.dart`
- **Model Files**: End with `_model.dart`

## 🎓 Learning Resources

This architecture is designed to:
- Scale easily
- Maintain code quality
- Enable team collaboration
- Reduce technical debt
- Improve developer experience

Follow these principles, and your Flutter app will remain maintainable even at 1000+ files!

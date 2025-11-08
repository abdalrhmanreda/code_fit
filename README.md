# Code Fit 🚀

A gamified programming learning roadmap app built with Flutter. Learn programming step-by-step like a fitness journey!

## 📋 Overview

Code Fit transforms programming education into an engaging, game-like experience. Users progress through 6 learning phases, earn XP, unlock achievements, maintain streaks, and level up as they master programming concepts.

### ✨ Key Features

- **6 Learning Phases**: From Programming Warm-Up to Final Project Showcase
- **Gamification**: XP system, levels, badges, and achievements
- **Progress Tracking**: Visual roadmap with milestones and checkpoints
- **Streak System**: Daily activity tracking with flame animations
- **Bilingual Support**: English and Arabic (العربية)
- **Modern UI**: Beautiful gradients, smooth animations, and motivating design
- **Offline-First**: Local data storage with SharedPreferences

## 🏗️ Architecture

This project follows **CRITICAL ARCHITECTURAL RULES** learned from refactoring a 248-file Flutter project:

### ✅ Strict Rules Followed

1. **File Size Limit**: No file exceeds 250 lines (split at 200 lines)
2. **No Widget-Returning Methods**: Every UI component is a separate StatelessWidget class
3. **DRY Principle**: All reusable widgets extracted to `shared/widgets/`
4. **Constants Extraction**: No hardcoded values in UI code
   - Colors → `app_colors.dart`
   - Dimensions → `app_dimensions.dart`
   - Strings → `app_strings.dart`
   - Durations → `app_durations.dart`

### 📁 Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── config/
│   ├── routes/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── themes/
│       └── app_theme.dart
│
├── core/
│   ├── constants/          # All app constants
│   ├── utils/             # Utility classes
│   ├── extensions/        # Dart extensions
│   └── services/          # Core services
│
├── shared/
│   └── widgets/           # Reusable widgets
│       ├── buttons/
│       ├── cards/
│       ├── progress/
│       └── ...
│
└── features/
    ├── splash/
    ├── onboarding/
    ├── home/
    ├── roadmap/
    ├── achievements/
    └── profile/
```

## 🎮 Learning Phases

1. **Phase 1: Programming Warm-Up** (المرحلة الأولى: الأساسيات)
   - Learn the fundamentals
   
2. **Phase 2: Data Structures & Algorithms** (هياكل البيانات)
   - Master core concepts
   
3. **Phase 3: Software Design Principles** (مبادئ التصميم)
   - Learn clean code practices
   
4. **Phase 4: Databases** (قواعد البيانات)
   - Work with data storage
   
5. **Phase 5: Advanced Topics** (مواضيع متقدمة)
   - Dive into advanced concepts
   
6. **Phase 6: Final Project Showcase** (مشروع التخرج)
   - Build your capstone project

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: flutter_bloc ^8.1.3
- **Local Storage**: shared_preferences ^2.2.2
- **Animations**: lottie ^3.0.0, animated_text_kit ^4.2.2
- **Icons**: font_awesome_flutter ^10.6.0
- **Utilities**: intl ^0.19.0, equatable ^2.0.5

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/code_fit.git
cd code_fit
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 Screens

### Splash Screen
- Animated logo with gradient background
- Auto-navigates to onboarding or home

### Onboarding
- 3-page introduction to app features
- Skip button and page indicators
- Smooth page transitions

### Home (Bottom Navigation)
1. **Roadmap**: Browse all 6 learning phases
2. **Achievements**: View unlocked and locked badges
3. **Profile**: User stats, streak, and settings

### Roadmap Screen
- User welcome header with level
- XP progress bar
- Phase cards with progress indicators
- Gradient backgrounds per phase

### Achievements Screen
- Summary card showing progress
- Unlocked achievements (full color)
- Locked achievements (grayed out)
- Badge types: Bronze, Silver, Gold, Platinum

### Profile Screen
- User avatar and level
- Stats grid (XP, Level, Streak)
- Settings: Notifications, Theme, About
- Language toggle

## 🎨 Design System

### Colors
- **Primary**: Blue (#2196F3)
- **Secondary**: Green (#4CAF50)
- **Accent**: Orange (#FF9800)
- **Gradients**: Motivational multi-color gradients
- **Phase Colors**: Unique color for each phase

### Typography
- Material Design 3 typography
- Bold headings, regular body text
- Bilingual font support

### Animations
- Fade transitions
- Scale animations
- Smooth page transitions
- Progress bar fills
- Celebration effects

## 💾 Data Models

### PhaseModel
- 6 learning phases
- Milestones and checkpoints
- Progress tracking
- Bilingual titles/descriptions

### MilestoneModel
- Multiple per phase
- Checkpoint lists
- XP rewards
- Completion status

### CheckpointModel
- Individual learning tasks
- Difficulty levels (easy/medium/hard)
- Estimated time
- XP rewards (50/100/200)

### AchievementModel
- Unlockable badges
- Badge types (bronze/silver/gold/platinum)
- Progress tracking
- Unlock timestamps

## 🔧 Utilities

### XpCalculator
- Exponential XP requirements
- Level calculation from total XP
- Progress calculation
- Bonus multipliers

### StreakCalculator
- Daily streak tracking
- Longest streak calculation
- Active streak detection
- Streak bonus calculations

### ProgressCalculator
- Overall progress percentage
- Phase/milestone progress
- Time estimates
- Performance metrics

## 🌐 Localization

Currently supports:
- **English (en)**
- **Arabic (ar)** - العربية

Toggle language via profile screen settings.

## 📦 Storage

Uses SharedPreferences for local storage:
- User XP and level
- Activity dates for streaks
- Completed milestones/checkpoints
- Unlocked achievements
- Language preference
- Onboarding completion status

## 🎯 Future Enhancements

- [ ] Add actual learning content for each checkpoint
- [ ] Implement dark mode
- [ ] Add more achievements
- [ ] Social features (leaderboards, sharing)
- [ ] Push notifications for streak reminders
- [ ] Analytics dashboard
- [ ] Custom milestone creation
- [ ] Cloud sync

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Built with ❤️ following strict architectural principles for maintainability and scalability.

## 🙏 Acknowledgments

- Inspired by fitness and language learning apps
- Designed to make programming education engaging
- Built with Flutter best practices

---

**Remember**: Code every day, master your way! 💪

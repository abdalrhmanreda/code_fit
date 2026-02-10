# App Status Feature - Architecture Flow

## 📋 Overview
This document explains the clean architecture flow used for the App Status (Blocked/Maintenance) feature.

## 🏗️ Architecture Pattern: Clean Architecture + BLoC

```
┌─────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                   │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ UI (Screens & Widgets)                                │  │
│  │ - BlockedScreenAndMaintance                           │  │
│  │ - Custom Widgets (PremiumButton, GlassmorphicCard)    │  │
│  └───────────────────────────────────────────────────────┘  │
│                           ↕                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ BLoC (Business Logic Component)                       │  │
│  │ - AppStatusCubit                                      │  │
│  │ - AppStatusState (Initial, Loading, Success, Error)   │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                         │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Repository (Business Rules)                           │  │
│  │ - AppStatusRepo                                       │  │
│  │   • getAppStatus()                                    │  │
│  │   • setAppStatus()                                    │  │
│  │   • Error handling with Either<Error, Success>        │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                          DATA LAYER                          │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ API Services (Network Calls)                          │  │
│  │ - ApiServices                                         │  │
│  │   • Manual Dio implementation (no code generation)    │  │
│  └───────────────────────────────────────────────────────┘  │
│                           ↕                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Models (Data Transfer Objects)                        │  │
│  │ - AppStatusModel                                      │  │
│  │   • Manual JSON serialization                         │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            ↕
                    ┌───────────────┐
                    │  REST API     │
                    │  (Backend)    │
                    └───────────────┘
```

## 🔄 Complete Data Flow

### 1. **User Action Flow (Setting Status)**

```
User Presses Button
       ↓
StatusActionButtons Widget
       ↓
AppStatusCubit.setMaintenanceMode(appId) or .setBlockedMode(appId)
       ↓
emit(AppStatusLoading)
       ↓
AppStatusRepo.setAppStatus(appId, isBlocked, isMaintainance)
       ↓
ApiServices.setStatus(appId, isBlocked, isMaintainance)
       ↓
Dio HTTP GET Request to: http://testblock2.runasp.net/Status/SetStatus
       ↓
API Response (JSON)
       ↓
AppStatusModel.fromJson(response.data)
       ↓
Repository returns Either<String, AppStatusModel>
       ↓
Cubit receives result
       ↓
Success: emit(AppStatusSuccess(model))
Error: emit(AppStatusError(message))
       ↓
UI Widget (BlocBuilder/BlocListener) reacts to state change
       ↓
Update UI display
```

### 2. **Initial Load Flow (Getting Status)**

```
App Starts
       ↓
BlockedScreenAndMaintance created with isMaintenance flag
       ↓
BlocProvider creates AppStatusCubit
       ↓
(Optional) Cubit.getAppStatus(appId) can be called
       ↓
emit(AppStatusLoading)
       ↓
AppStatusRepo.getAppStatus(appId)
       ↓
ApiServices.getStatus(appId)
       ↓
Dio HTTP GET Request to: http://testblock2.runasp.net/Status/GetStatus
       ↓
API Response processes through same flow
       ↓
UI updates based on state
```

## 📁 File Structure

```
lib/
└── blocked_and_maintance/
    ├── data/
    │   ├── models/
    │   │   └── app_status_model.dart          # Data model
    │   └── repo/
    │       └── app_status_repo.dart           # Repository pattern
    ├── logic/
    │   ├── app_status_state.dart              # State definitions
    │   └── app_status_cubit.dart              # Business logic
    └── ui/
        ├── screens/
        │   └── blocked_screen_and_maintance.dart  # Main screen
        └── widgets/
            ├── premium_button.dart            # Custom widgets
            ├── glassmorphic_card.dart
            ├── gradient_title.dart
            ├── status_action_buttons.dart
            ├── status_animation_container.dart
            └── animated_background_circles.dart
```

## 🔑 Key Components

### 1. **Data Layer** (`data/`)

#### AppStatusModel
```dart
class AppStatusModel {
  final bool? isBlocked;
  final bool? isMantainance;
  
  // Manual JSON serialization (no code generation)
  factory AppStatusModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### AppStatusRepo
```dart
class AppStatusRepo {
  final ApiServices _apiServices;
  
  // Returns Either<Error, Success> for clean error handling
  Future<Either<String, AppStatusModel>> getAppStatus(int appId);
  Future<Either<String, AppStatusModel>> setAppStatus(...);
}
```

### 2. **Logic Layer** (`logic/`)

#### AppStatusState
```dart
abstract class AppStatusState {}
class AppStatusInitial extends AppStatusState {}
class AppStatusLoading extends AppStatusState {}
class AppStatusSuccess extends AppStatusState {
  final AppStatusModel statusModel;
}
class AppStatusError extends AppStatusState {
  final String errorMessage;
}
```

#### AppStatusCubit
```dart
class AppStatusCubit extends Cubit<AppStatusState> {
  final AppStatusRepo _appStatusRepo;
  
  Future<void> getAppStatus(int appId) async {
    emit(AppStatusLoading());
    final result = await _appStatusRepo.getAppStatus(appId);
    result.fold(
      ifLeft: (error) => emit(AppStatusError(error)),
      ifRight: (model) => emit(AppStatusSuccess(model)),
    );
  }
}
```

### 3. **Presentation Layer** (`ui/`)

#### Main Screen
```dart
class BlockedScreenAndMaintance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppStatusCubit>(),
      child: _BlockedScreenContent(isMaintenance: isMaintenance),
    );
  }
}
```

## 🎯 Design Patterns Used

### 1. **Repository Pattern**
- Abstracts data sources
- Handles error mapping
- Returns Either<Error, Success> for type-safe error handling

### 2. **BLoC Pattern**
- Separates business logic from UI
- Reactive state management
- Testable and maintainable

### 3. **Dependency Injection**
```dart
// In dependency_injection.dart
getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio));
getIt.registerLazySingleton<AppStatusRepo>(() => AppStatusRepo(getIt()));
getIt.registerFactory<AppStatusCubit>(() => AppStatusCubit(getIt()));
```

### 4. **Widget Composition**
- Small, focused, reusable widgets
- Each widget has single responsibility
- Easier to test and maintain

## ⚡ Performance Optimizations

1. **No Code Generation**
   - Manual JSON parsing (faster build times)
   - Simpler debugging

2. **Efficient Color Handling**
   - Use `withValues(alpha:)` instead of deprecated `withOpacity`
   - Better performance

3. **Widget Extraction**
   - Reduced rebuild scope
   - Better widget tree structure

4. **Dio Logger Integration**
   - All HTTP requests logged via PrettyDioLogger
   - Easy debugging

## 🔒 Error Handling

```dart
// Repository level
try {
  final response = await _apiServices.getStatus(appId);
  return Right(response);
} catch (error) {
  if (error is DioException) {
    return Left(error.response?.data['message'] ?? 'Network error');
  }
  return Left('Unexpected error');
}

// Cubit level
result.fold(
  ifLeft: (error) => emit(AppStatusError(error)),
  ifRight: (model) => emit(AppStatusSuccess(model)),
);

// UI level (can use BlocListener for side effects)
BlocListener<AppStatusCubit, AppStatusState>(
  listener: (context, state) {
    if (state is AppStatusError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    }
  },
)
```

## 📊 API Endpoints

### Get Status
```
GET http://testblock2.runasp.net/Status/GetStatus?appId=1
```

### Set Status
```
GET http://testblock2.runasp.net/Status/SetStatus?appId=1&isBlocked=true&isMantainance=false
```

## ✅ Best Practices Followed

1. ✅ Clean Architecture (separation of concerns)
2. ✅ SOLID Principles
3. ✅ Type-safe error handling with Either
4. ✅ Dependency Injection
5. ✅ Widget composition over inheritance
6. ✅ Meaningful naming conventions
7. ✅ No business logic in UI
8. ✅ Testable code structure
9. ✅ Performance optimizations
10. ✅ Proper state management

## 🧪 How to Test Each Layer

### Unit Tests
```dart
// Test Repository
test('getAppStatus returns success', () async {
  when(mockApiServices.getStatus(1))
    .thenAnswer((_) async => AppStatusModel(...));
  
  final result = await repo.getAppStatus(1);
  expect(result.isRight, true);
});

// Test Cubit
blocTest<AppStatusCubit, AppStatusState>(
  'emits [Loading, Success] when getAppStatus succeeds',
  build: () => AppStatusCubit(mockRepo),
  act: (cubit) => cubit.getAppStatus(1),
  expect: () => [
    AppStatusLoading(),
    AppStatusSuccess(model),
  ],
);
```

### Widget Tests
```dart
testWidgets('displays maintenance UI', (tester) async {
  await tester.pumpWidget(
    BlockedScreenAndMaintance(isMaintenance: true),
  );
  expect(find.text('Under Maintenance'), findsOneWidget);
});
```

## 🎓 Summary

This architecture provides:
- **Scalability**: Easy to add new features
- **Maintainability**: Clear separation makes updates simple
- **Testability**: Each layer can be tested independently
- **Reusability**: Widgets and logic can be reused
- **Clean Code**: Following Flutter/Dart best practices

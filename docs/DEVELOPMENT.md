# Development Guide

## Getting Started

### Prerequisites

- Flutter SDK (3.24.0 or later)
- Dart SDK (3.5.0 or later)
- Android Studio / VS Code with Flutter extensions
- Git

### Environment Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd task_pulse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if needed)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## Development Workflow

### Code Organization

The project follows Clean Architecture with feature-based organization:

```
lib/
├── core/                 # Shared utilities and services
├── features/
│   └── task_management/  # Task management feature
│       ├── data/         # Data layer
│       ├── domain/       # Business logic
│       └── presentation/ # UI layer
└── main.dart            # Application entry point
```

### Feature Development Process

1. **Define Domain Layer**
   - Create entities
   - Define repository interfaces
   - Implement use cases

2. **Implement Data Layer**
   - Create data models
   - Implement repositories
   - Set up data sources

3. **Build Presentation Layer**
   - Create BLoC for state management
   - Implement UI screens
   - Add widgets and components

4. **Write Tests**
   - Unit tests for domain and data layers
   - BLoC tests for state management
   - Widget tests for UI components

### Code Style and Standards

#### Dart/Flutter Conventions
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` for code formatting
- Run `flutter analyze` to check for issues
- Maintain consistent naming conventions

#### Architecture Guidelines
- Separate concerns across layers
- Use dependency injection with GetIt
- Implement interfaces for testability
- Follow single responsibility principle

### Git Workflow

#### Branch Strategy
- `master` - Production-ready code
- `develop` - Development integration branch
- `feature/*` - Feature development branches
- `hotfix/*` - Critical bug fixes

#### Commit Message Format
```
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat(task): add priority filtering functionality

Implement priority-based task filtering in the task list screen.
Includes UI controls and BLoC state management.

Closes #123
```

### Code Generation

The project uses code generation for:
- Hive adapters for data models
- JSON serialization
- Mocks for testing

#### Running Code Generation
```bash
# One-time generation
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### State Management

#### BLoC Pattern Implementation
1. **Define Events** - User actions and external triggers
2. **Define States** - Application state representations
3. **Implement BLoC** - Business logic and state transitions
4. **Connect UI** - Use BlocProvider and BlocBuilder

#### Example BLoC Implementation
```dart
// Event
abstract class TaskEvent extends Equatable {}

class LoadTasks extends TaskEvent {
  @override
  List<Object?> get props => [];
}

// State
abstract class TaskState extends Equatable {}

class TaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

// BLoC
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;

  TaskBloc({required this.getTasks}) : super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await getTasks();
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (tasks) => emit(TaskLoaded(tasks: tasks)),
    );
  }
}
```

### Dependency Injection

Using GetIt for dependency management:

```dart
// Registration
final sl = GetIt.instance;

void init() {
  // Services
  sl.registerSingleton<HiveService>(HiveServiceImpl());

  // Repositories
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(hiveService: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTasks(sl()));

  // BLoC
  sl.registerFactory(() => TaskBloc(getTasks: sl()));
}

// Usage
final taskBloc = sl<TaskBloc>();
```

### Error Handling

#### Domain Layer Errors
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required String message})
    : super(message: message);
}
```

#### Repository Implementation
```dart
Future<Either<Failure, List<Task>>> getTasks() async {
  try {
    final tasks = await dataSource.getTasks();
    return Right(tasks.map((model) => model.toEntity()).toList());
  } catch (e) {
    return Left(DatabaseFailure(message: e.toString()));
  }
}
```

### Local Storage

#### Hive Configuration
```dart
// Model with Hive annotations
@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  // ... other fields
}

// Service implementation
class HiveServiceImpl implements HiveService {
  static const String taskBoxName = 'tasks';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    await Hive.openBox<TaskModel>(taskBoxName);
  }
}
```

### Testing Guidelines

#### Unit Test Structure
```dart
group('CreateTask', () {
  late CreateTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = CreateTask(mockRepository);
  });

  test('should create task when repository succeeds', () async {
    // arrange
    when(mockRepository.createTask(any))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(testTask);

    // assert
    expect(result, const Right(null));
    verify(mockRepository.createTask(testTask));
  });
});
```

#### Widget Test Structure
```dart
testWidgets('should display task list when loaded', (tester) async {
  // arrange
  when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: testTasks));

  // act
  await tester.pumpWidget(createWidgetUnderTest());

  // assert
  expect(find.text('Test Task'), findsOneWidget);
});
```

### Performance Optimization

#### Best Practices
- Use `const` constructors where possible
- Implement efficient list rendering with `ListView.builder`
- Minimize unnecessary widget rebuilds
- Optimize state management with proper equality checks

#### Memory Management
- Dispose controllers and streams properly
- Close Hive boxes when not needed
- Use `AutomaticKeepAliveClientMixin` for expensive widgets

### Debugging

#### Common Tools
- Flutter Inspector for widget tree analysis
- Dart DevTools for performance profiling
- VS Code/Android Studio debugger
- `print()` statements for quick debugging

#### Performance Profiling
```bash
# Run with performance overlay
flutter run --profile

# Generate performance report
flutter drive --target=test_driver/app.dart --profile
```

### Deployment

#### Android Build
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
flutter build appbundle --release
```

#### Code Signing
- Configure `android/app/build.gradle` for release signing
- Store signing keys securely
- Use environment variables for sensitive data

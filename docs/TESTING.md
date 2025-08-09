# Testing Documentation

## Overview

Task Pulse follows a comprehensive testing strategy covering unit tests, widget tests, and integration tests to ensure code quality and reliability.

## Test Structure

```
test/
├── features/
│   └── task_management/
│       ├── data/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           └── pages/
├── integration/
└── widget_test.dart
```

## Testing Framework

- **Flutter Test**: Core testing framework
- **Bloc Test**: BLoC-specific testing utilities
- **Mockito**: Mocking framework for dependencies
- **Integration Test**: End-to-end testing

## Unit Tests

### Entity Tests
**Location**: `test/features/task_management/domain/entities/`

Tests for core business objects:
- Task entity creation and properties
- Priority enumeration behavior
- Equatable implementation verification

### Use Case Tests
**Location**: `test/features/task_management/domain/usecases/`

Tests for business logic:
- `CreateTask` - Task creation logic
- `GetTasks` - Task retrieval logic
- `UpdateTask` - Task modification logic
- `DeleteTask` - Task deletion logic
- `ToggleTaskCompletion` - Status change logic
- `SearchTasks` - Search functionality
- `GetTasksByPriority` - Priority filtering

### Repository Tests
**Location**: `test/features/task_management/data/repositories/`

Tests for data layer:
- Repository implementation with mocked data sources
- Error handling scenarios
- Data transformation between models and entities

## BLoC Tests

**Location**: `test/features/task_management/presentation/bloc/`

Tests for state management:
- Event handling verification
- State transition validation
- Use case interaction testing
- Error state handling

### Example BLoC Test Structure
```dart
group('TaskBloc', () {
  late TaskBloc taskBloc;
  late MockGetTasks mockGetTasks;
  late MockCreateTask mockCreateTask;

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockCreateTask = MockCreateTask();
    taskBloc = TaskBloc(
      getTasks: mockGetTasks,
      createTask: mockCreateTask,
      // ... other dependencies
    );
  });

  blocTest<TaskBloc, TaskState>(
    'emits [TaskLoading, TaskLoaded] when LoadTasks is added',
    build: () => taskBloc,
    act: (bloc) => bloc.add(LoadTasks()),
    expect: () => [TaskLoading(), TaskLoaded(tasks: [])],
  );
});
```

## Widget Tests

**Location**: `test/features/task_management/presentation/pages/`

Tests for UI components:
- Widget rendering verification
- User interaction handling
- BLoC integration testing
- Navigation behavior

### Key Widget Tests
- `TaskListScreen` - Task list display and interactions
- `TaskFormScreen` - Task creation/editing form
- Custom widgets and components

## Integration Tests

**Location**: `test/integration/`

End-to-end testing scenarios:
- Complete task workflow (create → view → edit → delete)
- Database persistence verification
- Notification scheduling and handling
- Cross-platform functionality

## Test Coverage

### Current Coverage Targets
- **Unit Tests**: >95% coverage
- **Widget Tests**: >90% coverage
- **Integration Tests**: Core user journeys covered

### Coverage Analysis
```bash
# Generate coverage report
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Data and Mocks

### Mock Repository
**Location**: `test/features/task_management/domain/usecases/mock_task_repository.dart`

Provides consistent test data for use case testing.

### Test Fixtures
Standardized test data for consistent testing:
- Sample tasks with various priorities
- Test date/time values
- Error scenarios

## Running Tests

### All Tests
```bash
flutter test
```

### Specific Test Categories
```bash
# Unit tests only
flutter test test/features/task_management/domain/

# Widget tests only
flutter test test/features/task_management/presentation/

# Integration tests only
flutter test integration_test/
```

### With Coverage
```bash
flutter test --coverage
```

## CI/CD Integration

Tests are automatically run in GitHub Actions:
- Unit tests on every push/PR
- Integration tests on emulator
- Coverage reporting to Codecov

## Best Practices

### Test Organization
- One test file per source file
- Descriptive test names
- Grouped related tests
- Clear arrange-act-assert structure

### Mocking Strategy
- Mock external dependencies
- Use dependency injection for testability
- Verify mock interactions
- Reset mocks between tests

### Test Maintenance
- Update tests with code changes
- Maintain test data consistency
- Regular coverage analysis
- Refactor tests for readability

## Debugging Tests

### Common Issues
- Mock setup problems
- Async test handling
- Widget test pump/settle timing
- State management test complexity

### Debugging Tools
- Flutter Inspector for widget tests
- Debugger integration in IDEs
- Print statements for complex scenarios
- Test isolation for problem identification

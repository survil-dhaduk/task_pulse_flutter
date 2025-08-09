# Constants Directory

This directory contains all application constants to provide centralized string management and prepare for internationalization.

## Files

- `app_strings.dart` - All user-facing string constants
- `constants.dart` - Barrel file for exporting all constants

## Usage

Import the constants in your Dart files:

```dart
import 'package:task_pulse/core/constants/app_strings.dart';

// Usage
Text(AppStrings.appName)
```

Or use the barrel file:

```dart
import 'package:task_pulse/core/constants/constants.dart';

// Usage
Text(AppStrings.appName)
```

## String Types

### Static Strings
Use for simple, unchanging strings:
```dart
static const String appName = 'TaskPulse';
```

### Dynamic Strings
Use for strings that require parameters:
```dart
static String searchResults(String query, int count) =>
    "Search: '$query' — $count result(s)";
```

## Benefits

1. **Centralized Management**: All strings in one place
2. **Easy Updates**: Change strings without searching through multiple files
3. **Internationalization Ready**: Foundation for adding multiple languages
4. **Type Safety**: Compile-time checking for string references
5. **Maintainability**: Easier to track and update all user-facing text

## Adding New Strings

When adding new strings:
1. Add the constant to `AppStrings` class
2. Use descriptive, camelCase names
3. Group related strings together
4. For dynamic strings, use static methods
5. Update imports in files that need the new constants

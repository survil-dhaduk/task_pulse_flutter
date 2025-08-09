import '../../../../core/constants/app_strings.dart';

/// Priority levels for tasks
enum Priority {
  low,
  medium,
  high;

  /// Get the display name for the priority
  String get displayName {
    switch (this) {
      case Priority.low:
        return AppStrings.lowPriority;
      case Priority.medium:
        return AppStrings.mediumPriority;
      case Priority.high:
        return AppStrings.highPriority;
    }
  }

  /// Get the color for the priority
  int get colorValue {
    switch (this) {
      case Priority.low:
        return 0xFF4CAF50; // Green
      case Priority.medium:
        return 0xFFFF9800; // Orange
      case Priority.high:
        return 0xFFF44336; // Red
    }
  }
}

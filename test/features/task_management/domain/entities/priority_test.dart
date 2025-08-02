import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';

void main() {
  group('Priority Enum', () {
    test('should have correct display names', () {
      expect(Priority.low.displayName, 'Low');
      expect(Priority.medium.displayName, 'Medium');
      expect(Priority.high.displayName, 'High');
    });

    test('should have correct color values', () {
      expect(Priority.low.colorValue, 0xFF4CAF50); // Green
      expect(Priority.medium.colorValue, 0xFFFF9800); // Orange
      expect(Priority.high.colorValue, 0xFFF44336); // Red
    });

    test('should have correct enum values', () {
      expect(Priority.values.length, 3);
      expect(Priority.values, contains(Priority.low));
      expect(Priority.values, contains(Priority.medium));
      expect(Priority.values, contains(Priority.high));
    });

    test('should have correct enum names', () {
      expect(Priority.low.name, 'low');
      expect(Priority.medium.name, 'medium');
      expect(Priority.high.name, 'high');
    });
  });
}

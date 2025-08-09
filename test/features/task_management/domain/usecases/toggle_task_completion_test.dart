import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/usecases/toggle_task_completion.dart';

import 'mock_task_repository.dart';

void main() {
  group('ToggleTaskCompletion Use Case', () {
    late ToggleTaskCompletion useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = ToggleTaskCompletion(mockRepository);
    });

    test('should toggle task completion successfully', () async {
      // Arrange
      const taskId = '1';

      // Act
      final result = await useCase(taskId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(result.isRight(), true);
    });

    test('should handle multiple toggle operations', () async {
      // Arrange
      const taskId = '1';

      // Act - Toggle twice
      final result1 = await useCase(taskId);
      final result2 = await useCase(taskId);

      // Assert
      expect(result1, isA<Right<Failure, void>>());
      expect(result2, isA<Right<Failure, void>>());
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
    });

    test('should handle empty task id', () async {
      // Arrange
      const taskId = '';

      // Act
      final result = await useCase(taskId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(result.isRight(), true);
    });
  });
}

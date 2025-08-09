import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';
import 'package:task_pulse/features/task_management/domain/usecases/get_tasks_by_priority.dart';

import 'mock_task_repository.dart';

void main() {
  group('GetTasksByPriority Use Case', () {
    late GetTasksByPriority useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = GetTasksByPriority(mockRepository);
    });

    test('should get high priority tasks successfully', () async {
      // Arrange
      const priority = Priority.high;

      // Act
      final result = await useCase(priority);

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });

    test('should get medium priority tasks successfully', () async {
      // Arrange
      const priority = Priority.medium;

      // Act
      final result = await useCase(priority);

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });

    test('should get low priority tasks successfully', () async {
      // Arrange
      const priority = Priority.low;

      // Act
      final result = await useCase(priority);

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });

    test('should handle all priority levels', () async {
      // Act
      final highPriorityResult = await useCase(Priority.high);
      final mediumPriorityResult = await useCase(Priority.medium);
      final lowPriorityResult = await useCase(Priority.low);

      // Assert
      expect(highPriorityResult, isA<Right<Failure, List<Task>>>());
      expect(mediumPriorityResult, isA<Right<Failure, List<Task>>>());
      expect(lowPriorityResult, isA<Right<Failure, List<Task>>>());

      expect(highPriorityResult.isRight(), true);
      expect(mediumPriorityResult.isRight(), true);
      expect(lowPriorityResult.isRight(), true);
    });
  });
}

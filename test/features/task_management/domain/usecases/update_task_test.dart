import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';
import 'package:task_pulse/features/task_management/domain/usecases/update_task.dart';

import 'mock_task_repository.dart';

void main() {
  group('UpdateTask Use Case', () {
    late UpdateTask useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = UpdateTask(mockRepository);
    });

    test('should update a task successfully', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Updated Task',
        description: 'Updated task description',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: Priority.high,
        isCompleted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await useCase(task);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(result.isRight(), true);
    });

    test('should handle task update with different priorities', () async {
      // Arrange
      final lowPriorityTask = Task(
        id: '1',
        title: 'Low Priority Task',
        description: 'Low priority task description',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: Priority.low,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final highPriorityTask = lowPriorityTask.copyWith(
        priority: Priority.high,
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await useCase(highPriorityTask);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(result.isRight(), true);
    });

    test('should handle task completion toggle', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: Priority.medium,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final completedTask = task.copyWith(
        isCompleted: true,
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await useCase(completedTask);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(result.isRight(), true);
    });
  });
}

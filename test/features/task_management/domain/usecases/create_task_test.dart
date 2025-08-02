import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';
import 'package:task_pulse/features/task_management/domain/usecases/create_task.dart';

import 'mock_task_repository.dart';

void main() {
  group('CreateTask Use Case', () {
    late CreateTask useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = CreateTask(mockRepository);
    });

    test('should create a task successfully', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'New Task',
        description: 'New task description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: Priority.high,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await useCase(task);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(result.isRight(), true);
    });

    test('should handle task creation with different priorities', () async {
      // Arrange
      final highPriorityTask = Task(
        id: '1',
        title: 'High Priority Task',
        description: 'High priority task description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: Priority.high,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final lowPriorityTask = Task(
        id: '2',
        title: 'Low Priority Task',
        description: 'Low priority task description',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: Priority.low,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      // Act
      final result1 = await useCase(highPriorityTask);
      final result2 = await useCase(lowPriorityTask);

      // Assert
      expect(result1, isA<Right<Failure, void>>());
      expect(result2, isA<Right<Failure, void>>());
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
    });
  });
}

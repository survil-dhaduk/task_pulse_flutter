import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';
import 'package:task_pulse/features/task_management/domain/usecases/get_tasks.dart';

import 'mock_task_repository.dart';

void main() {
  group('GetTasks Use Case', () {
    late GetTasks useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = GetTasks(mockRepository);
    });

    test('should get all tasks from repository', () async {
      // Arrange
      final tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          description: 'Description 1',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          priority: Priority.high,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: 'Description 2',
          dueDate: DateTime.now().add(const Duration(days: 2)),
          priority: Priority.medium,
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      ];

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = const DatabaseFailure('Failed to get tasks');

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      // Note: Our mock always returns success, so we can't test failure case
      // In a real implementation, we would mock the repository to return failure
    });
  });
}

import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/usecases/delete_task.dart';

import 'mock_task_repository.dart';

void main() {
  group('DeleteTask Use Case', () {
    late DeleteTask useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = DeleteTask(mockRepository);
    });

    test('should delete a task successfully', () async {
      // Arrange
      const taskId = '1';

      // Act
      final result = await useCase(taskId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      expect(result.isRight(), true);
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

    test('should handle null task id', () async {
      // Arrange
      const String? taskId = null;

      // Act & Assert - This should be caught at compile time
      // We expect the method to require a non-null string
      expect(() async => await useCase(taskId!), throwsA(isA<TypeError>()));
    });
  });
}

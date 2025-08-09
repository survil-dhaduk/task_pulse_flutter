import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';
import 'package:task_pulse/features/task_management/domain/usecases/search_tasks.dart';

import 'mock_task_repository.dart';

void main() {
  group('SearchTasks Use Case', () {
    late SearchTasks useCase;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      useCase = SearchTasks(mockRepository);
    });

    test('should search tasks successfully', () async {
      // Arrange
      const query = 'test';

      // Act
      final result = await useCase(query);

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });

    test('should handle empty search query', () async {
      // Arrange
      const query = '';

      // Act
      final result = await useCase(query);

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });

    test('should handle search with special characters', () async {
      // Arrange
      const query = '@#\$%^&*()';

      // Act
      final result = await useCase(query);

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });

    test('should handle case-insensitive search', () async {
      // Arrange
      const upperCaseQuery = 'TEST';
      const lowerCaseQuery = 'test';

      // Act
      final result1 = await useCase(upperCaseQuery);
      final result2 = await useCase(lowerCaseQuery);

      // Assert
      expect(result1, isA<Right<Failure, List<Task>>>());
      expect(result2, isA<Right<Failure, List<Task>>>());
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
    });

    test('should handle long search queries', () async {
      // Arrange
      const longQuery =
          'this is a very long search query that should still work properly and return appropriate results';

      // Act
      final result = await useCase(longQuery);

      // Assert
      expect(result, isA<Right<Failure, List<Task>>>());
      expect(result.isRight(), true);
    });
  });
}

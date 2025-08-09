import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/core/services/hive_service.dart';
import 'package:task_pulse/features/task_management/data/models/priority_model.dart';
import 'package:task_pulse/features/task_management/data/models/task_model.dart';
import 'package:task_pulse/features/task_management/data/repositories/task_repository_impl.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';

import 'task_repository_impl_test.mocks.dart';

@GenerateMocks([HiveService, Box])
void main() {
  group('TaskRepositoryImpl', () {
    late TaskRepositoryImpl repository;
    late MockHiveService mockHiveService;
    late MockBox mockBox;
    late TaskModel testTaskModel;
    late Task testTask;

    setUp(() {
      mockHiveService = MockHiveService();
      mockBox = MockBox();
      repository = TaskRepositoryImpl(hiveService: mockHiveService);

      final now = DateTime.now();
      testTask = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: now.add(const Duration(days: 1)),
        priority: Priority.medium,
        isCompleted: false,
        createdAt: now,
      );

      testTaskModel = TaskModel.fromEntity(testTask);
    });

    group('getTasks', () {
      test('should return all tasks when successful', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.values).thenReturn([testTaskModel]);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result, isA<Right<Failure, List<Task>>>());
        result.fold((failure) => fail('Expected Right but got Left'), (tasks) {
          expect(tasks.length, 1);
          expect(tasks.first.id, testTask.id);
          expect(tasks.first.title, testTask.title);
        });
      });

      test('should return empty list when no tasks exist', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.values).thenReturn([]);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result, isA<Right<Failure, List<Task>>>());
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (tasks) => expect(tasks, isEmpty),
        );
      });

      test('should return DatabaseFailure when exception occurs', () async {
        // Arrange
        when(
          mockHiveService.openBox('tasks'),
        ).thenThrow(Exception('Database error'));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result, isA<Left<Failure, List<Task>>>());
        result.fold((failure) {
          expect(failure, isA<DatabaseFailure>());
          expect(failure.message, contains('Database error'));
        }, (tasks) => fail('Expected Left but got Right'));
      });
    });

    group('getTask', () {
      test('should return task when found', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.get('1')).thenReturn(testTaskModel);

        // Act
        final result = await repository.getTask('1');

        // Assert
        expect(result, isA<Right<Failure, Task>>());
        result.fold((failure) => fail('Expected Right but got Left'), (task) {
          expect(task.id, testTask.id);
          expect(task.title, testTask.title);
        });
      });

      test('should return DatabaseFailure when task not found', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.get('1')).thenReturn(null);

        // Act
        final result = await repository.getTask('1');

        // Assert
        expect(result, isA<Left<Failure, Task>>());
        result.fold((failure) {
          expect(failure, isA<DatabaseFailure>());
          expect(failure.message, 'Task not found');
        }, (task) => fail('Expected Left but got Right'));
      });
    });

    group('createTask', () {
      test('should create task successfully', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.put('1', any)).thenAnswer((_) async {
          return;
        });

        // Act
        final result = await repository.createTask(testTask);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        verify(mockBox.put('1', any)).called(1);
      });

      test('should return DatabaseFailure when creation fails', () async {
        // Arrange
        when(
          mockHiveService.openBox('tasks'),
        ).thenThrow(Exception('Creation failed'));

        // Act
        final result = await repository.createTask(testTask);

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold((failure) {
          expect(failure, isA<DatabaseFailure>());
          expect(failure.message, contains('Creation failed'));
        }, (_) => fail('Expected Left but got Right'));
      });
    });

    group('updateTask', () {
      test('should update task successfully', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.put('1', any)).thenAnswer((_) async {
          return;
        });

        // Act
        final result = await repository.updateTask(testTask);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        verify(mockBox.put('1', any)).called(1);
      });
    });

    group('deleteTask', () {
      test('should delete task successfully', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.delete('1')).thenAnswer((_) async {
          return;
        });

        // Act
        final result = await repository.deleteTask('1');

        // Assert
        expect(result, isA<Right<Failure, void>>());
        verify(mockBox.delete('1')).called(1);
      });
    });

    group('toggleTaskCompletion', () {
      test('should toggle task completion successfully', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.get('1')).thenReturn(testTaskModel);
        when(mockBox.put('1', any)).thenAnswer((_) async {
          return;
        });

        // Act
        final result = await repository.toggleTaskCompletion('1');

        // Assert
        expect(result, isA<Right<Failure, void>>());
        verify(mockBox.put('1', any)).called(1);
      });

      test('should return DatabaseFailure when task not found', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.get('1')).thenReturn(null);

        // Act
        final result = await repository.toggleTaskCompletion('1');

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold((failure) {
          expect(failure, isA<DatabaseFailure>());
          expect(failure.message, 'Task not found');
        }, (_) => fail('Expected Left but got Right'));
      });
    });

    group('getTasksByPriority', () {
      test('should return tasks with specified priority', () async {
        // Arrange
        final highPriorityTask = testTaskModel.copyWith(
          priority: PriorityModel.fromEntity(Priority.high),
        );
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.values).thenReturn([testTaskModel, highPriorityTask]);

        // Act
        final result = await repository.getTasksByPriority(Priority.high);

        // Assert
        expect(result, isA<Right<Failure, List<Task>>>());
        result.fold((failure) => fail('Expected Right but got Left'), (tasks) {
          expect(tasks.length, 1);
          expect(tasks.first.priority, Priority.high);
        });
      });
    });

    group('getCompletedTasks', () {
      test('should return only completed tasks', () async {
        // Arrange
        final completedTask = testTaskModel.copyWith(isCompleted: true);
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.values).thenReturn([testTaskModel, completedTask]);

        // Act
        final result = await repository.getCompletedTasks();

        // Assert
        expect(result, isA<Right<Failure, List<Task>>>());
        result.fold((failure) => fail('Expected Right but got Left'), (tasks) {
          expect(tasks.length, 1);
          expect(tasks.first.isCompleted, true);
        });
      });
    });

    group('getPendingTasks', () {
      test('should return only pending tasks', () async {
        // Arrange
        final completedTask = testTaskModel.copyWith(isCompleted: true);
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.values).thenReturn([testTaskModel, completedTask]);

        // Act
        final result = await repository.getPendingTasks();

        // Assert
        expect(result, isA<Right<Failure, List<Task>>>());
        result.fold((failure) => fail('Expected Right but got Left'), (tasks) {
          expect(tasks.length, 1);
          expect(tasks.first.isCompleted, false);
        });
      });
    });

    group('searchTasks', () {
      test('should return tasks matching search query in title', () async {
        // Arrange
        final task2 = testTaskModel.copyWith(title: 'Another Task');
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.values).thenReturn([testTaskModel, task2]);

        // Act
        final result = await repository.searchTasks('Test');

        // Assert
        expect(result, isA<Right<Failure, List<Task>>>());
        result.fold((failure) => fail('Expected Right but got Left'), (tasks) {
          expect(tasks.length, 1);
          expect(tasks.first.title, contains('Test'));
        });
      });

      test(
        'should return tasks matching search query in description',
        () async {
          // Arrange
          final task2 = testTaskModel.copyWith(
            description: 'Another Description',
          );
          when(
            mockHiveService.openBox('tasks'),
          ).thenAnswer((_) async => mockBox);
          when(mockBox.values).thenReturn([testTaskModel, task2]);

          // Act
          final result = await repository.searchTasks('Test');

          // Assert
          expect(result, isA<Right<Failure, List<Task>>>());
          result.fold((failure) => fail('Expected Right but got Left'), (
            tasks,
          ) {
            expect(tasks.length, 1);
            expect(tasks.first.description, contains('Test'));
          });
        },
      );

      test('should perform case-insensitive search', () async {
        // Arrange
        when(mockHiveService.openBox('tasks')).thenAnswer((_) async => mockBox);
        when(mockBox.values).thenReturn([testTaskModel]);

        // Act
        final result = await repository.searchTasks('test');

        // Assert
        expect(result, isA<Right<Failure, List<Task>>>());
        result.fold((failure) => fail('Expected Right but got Left'), (tasks) {
          expect(tasks.length, 1);
          expect(tasks.first.title, 'Test Task');
        });
      });
    });
  });
}

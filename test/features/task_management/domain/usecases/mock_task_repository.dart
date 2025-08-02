import 'package:dartz/dartz.dart' hide Task;
import 'package:task_pulse/core/errors/failures.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';
import 'package:task_pulse/features/task_management/domain/repositories/task_repository.dart';

/// Mock implementation of TaskRepository for testing
class MockTaskRepository implements TaskRepository {
  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    final now = DateTime.now();
    return Right(Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      dueDate: now.add(const Duration(days: 1)),
      priority: Priority.medium,
      isCompleted: false,
      createdAt: now,
    ));
  }

  @override
  Future<Either<Failure, void>> createTask(Task task) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateTask(Task task) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> toggleTaskCompletion(String id) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByPriority(Priority priority) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<Task>>> getCompletedTasks() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<Task>>> getPendingTasks() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<Task>>> searchTasks(String query) async {
    return const Right([]);
  }
} 
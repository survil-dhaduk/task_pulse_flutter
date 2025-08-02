import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../entities/priority.dart';

/// Repository interface for task operations
abstract class TaskRepository {
  /// Get all tasks
  Future<Either<Failure, List<Task>>> getTasks();

  /// Get a single task by ID
  Future<Either<Failure, Task>> getTask(String id);

  /// Create a new task
  Future<Either<Failure, void>> createTask(Task task);

  /// Update an existing task
  Future<Either<Failure, void>> updateTask(Task task);

  /// Delete a task by ID
  Future<Either<Failure, void>> deleteTask(String id);

  /// Toggle the completion status of a task
  Future<Either<Failure, void>> toggleTaskCompletion(String id);

  /// Get tasks by priority
  Future<Either<Failure, List<Task>>> getTasksByPriority(Priority priority);

  /// Get completed tasks
  Future<Either<Failure, List<Task>>> getCompletedTasks();

  /// Get pending tasks
  Future<Either<Failure, List<Task>>> getPendingTasks();

  /// Search tasks by title or description
  Future<Either<Failure, List<Task>>> searchTasks(String query);
} 
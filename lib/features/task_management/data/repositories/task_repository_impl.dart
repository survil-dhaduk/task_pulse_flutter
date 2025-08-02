import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/hive_service.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/priority_model.dart';
import '../models/task_model.dart';

/// Implementation of TaskRepository using Hive for local persistence
class TaskRepositoryImpl implements TaskRepository {
  final HiveService _hiveService;
  static const String _taskBoxName = 'tasks';

  const TaskRepositoryImpl({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModels = box.values.cast<TaskModel>().toList();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModel = box.get(id) as TaskModel?;

      if (taskModel == null) {
        return Left(DatabaseFailure('Task not found'));
      }

      return Right(taskModel.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createTask(Task task) async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModel = TaskModel.fromEntity(task);
      await box.put(task.id, taskModel);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(Task task) async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModel = TaskModel.fromEntity(task);
      await box.put(task.id, taskModel);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      await box.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTaskCompletion(String id) async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModel = box.get(id) as TaskModel?;

      if (taskModel == null) {
        return Left(DatabaseFailure('Task not found'));
      }

      final updatedTask = taskModel.copyWith(
        isCompleted: !taskModel.isCompleted,
        updatedAt: DateTime.now(),
      );

      await box.put(id, updatedTask);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByPriority(
    Priority priority,
  ) async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final priorityModel = PriorityModel.fromEntity(priority);
      final taskModels = box.values
          .cast<TaskModel>()
          .where((task) => task.priority == priorityModel)
          .toList();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getCompletedTasks() async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModels = box.values
          .cast<TaskModel>()
          .where((task) => task.isCompleted)
          .toList();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getPendingTasks() async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModels = box.values
          .cast<TaskModel>()
          .where((task) => !task.isCompleted)
          .toList();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> searchTasks(String query) async {
    try {
      final box = await _hiveService.openBox(_taskBoxName);
      final taskModels = box.values.cast<TaskModel>().where((task) {
        final lowercaseQuery = query.toLowerCase();
        return task.title.toLowerCase().contains(lowercaseQuery) ||
            task.description.toLowerCase().contains(lowercaseQuery);
      }).toList();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

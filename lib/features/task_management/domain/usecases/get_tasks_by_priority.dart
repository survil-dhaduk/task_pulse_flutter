import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../entities/priority.dart';
import '../repositories/task_repository.dart';

/// Use case for getting tasks by priority
class GetTasksByPriority {
  final TaskRepository repository;

  const GetTasksByPriority(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Task>>> call(Priority priority) async {
    return await repository.getTasksByPriority(priority);
  }
} 
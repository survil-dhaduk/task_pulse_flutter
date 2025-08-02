import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for creating a new task
class CreateTask {
  final TaskRepository repository;

  const CreateTask(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(Task task) async {
    return await repository.createTask(task);
  }
} 
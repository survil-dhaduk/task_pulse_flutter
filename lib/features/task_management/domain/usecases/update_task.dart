import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for updating an existing task
class UpdateTask {
  final TaskRepository repository;

  const UpdateTask(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(Task task) async {
    return await repository.updateTask(task);
  }
} 
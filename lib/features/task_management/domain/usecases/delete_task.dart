import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

/// Use case for deleting a task
class DeleteTask {
  final TaskRepository repository;

  const DeleteTask(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTask(id);
  }
}

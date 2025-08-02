import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

/// Use case for toggling task completion status
class ToggleTaskCompletion {
  final TaskRepository repository;

  const ToggleTaskCompletion(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(String id) async {
    return await repository.toggleTaskCompletion(id);
  }
}

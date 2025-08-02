import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for getting all tasks
class GetTasks {
  final TaskRepository repository;

  const GetTasks(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getTasks();
  }
} 
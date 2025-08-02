import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for searching tasks
class SearchTasks {
  final TaskRepository repository;

  const SearchTasks(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Task>>> call(String query) async {
    return await repository.searchTasks(query);
  }
} 
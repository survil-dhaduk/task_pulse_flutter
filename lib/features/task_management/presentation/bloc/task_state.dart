import 'package:equatable/equatable.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/task.dart';

/// Base class for all task states
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

/// State when tasks are being loaded
class TaskLoading extends TaskState {
  const TaskLoading();
}

/// State when tasks have been loaded successfully
class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final String? hint; // e.g., "sorted by due date", "filtered: completed"

  const TaskLoaded(this.tasks, {this.hint});

  @override
  List<Object?> get props => [tasks, hint];
}

/// State when an error occurs
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a task operation is in progress
class TaskOperationInProgress extends TaskState {
  final List<Task> tasks;
  final String? hint;

  const TaskOperationInProgress(this.tasks, {this.hint});

  @override
  List<Object?> get props => [tasks, hint];
}

/// State when tasks are being searched
class TaskSearching extends TaskState {
  final List<Task> tasks;

  const TaskSearching(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// State when search results are available
class TaskSearchResults extends TaskState {
  final List<Task> tasks;
  final String query;

  const TaskSearchResults(this.tasks, this.query);

  @override
  List<Object?> get props => [tasks, query];
}

/// State when tasks are filtered by priority
class TaskFilteredByPriority extends TaskState {
  final List<Task> tasks;
  final Priority priority;

  const TaskFilteredByPriority(this.tasks, this.priority);

  @override
  List<Object?> get props => [tasks, priority];
}

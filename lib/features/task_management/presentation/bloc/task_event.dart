import 'package:equatable/equatable.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/task.dart';

/// Base class for all task events
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all tasks
class LoadTasks extends TaskEvent {
  const LoadTasks();
}

/// Event to create a new task
class CreateTask extends TaskEvent {
  final Task task;

  const CreateTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event to update an existing task
class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event to delete a task
class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Event to toggle task completion status
class ToggleTaskCompletion extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Event to search tasks
class SearchTasks extends TaskEvent {
  final String query;

  const SearchTasks(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to get tasks by priority
class GetTasksByPriority extends TaskEvent {
  final Priority priority;

  const GetTasksByPriority(this.priority);

  @override
  List<Object?> get props => [priority];
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/usecases.dart' as usecases;
import 'task_event.dart';
import 'task_state.dart';

/// BLoC for managing task-related state and operations
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final usecases.GetTasks getTasks;
  final usecases.CreateTask createTask;
  final usecases.UpdateTask updateTask;
  final usecases.DeleteTask deleteTask;
  final usecases.ToggleTaskCompletion toggleTaskCompletion;
  final usecases.SearchTasks searchTasks;
  final usecases.GetTasksByPriority getTasksByPriority;

  TaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTaskCompletion,
    required this.searchTasks,
    required this.getTasksByPriority,
  }) : super(const TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<SearchTasks>(_onSearchTasks);
    on<GetTasksByPriority>(_onGetTasksByPriority);
  }

  /// Handle LoadTasks event
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    final result = await getTasks.call();

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  /// Handle CreateTask event
  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskOperationInProgress(currentState.tasks));
    }

    final result = await createTask.call(event.task);

    result.fold((failure) => emit(TaskError(failure.message)), (_) async {
      // Refresh the task list after successful creation
      final refreshResult = await getTasks.call();
      refreshResult.fold(
        (failure) => emit(TaskError(failure.message)),
        (tasks) => emit(TaskLoaded(tasks)),
      );
    });
  }

  /// Handle UpdateTask event
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskOperationInProgress(currentState.tasks));
    }

    final result = await updateTask.call(event.task);

    result.fold((failure) => emit(TaskError(failure.message)), (_) async {
      // Refresh the task list after successful update
      final refreshResult = await getTasks.call();
      refreshResult.fold(
        (failure) => emit(TaskError(failure.message)),
        (tasks) => emit(TaskLoaded(tasks)),
      );
    });
  }

  /// Handle DeleteTask event
  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskOperationInProgress(currentState.tasks));
    }

    final result = await deleteTask.call(event.taskId);

    result.fold((failure) => emit(TaskError(failure.message)), (_) async {
      // Refresh the task list after successful deletion
      final refreshResult = await getTasks.call();
      refreshResult.fold(
        (failure) => emit(TaskError(failure.message)),
        (tasks) => emit(TaskLoaded(tasks)),
      );
    });
  }

  /// Handle ToggleTaskCompletion event
  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskOperationInProgress(currentState.tasks));
    }

    final result = await toggleTaskCompletion.call(event.taskId);

    result.fold((failure) => emit(TaskError(failure.message)), (_) async {
      // Refresh the task list after successful toggle
      final refreshResult = await getTasks.call();
      refreshResult.fold(
        (failure) => emit(TaskError(failure.message)),
        (tasks) => emit(TaskLoaded(tasks)),
      );
    });
  }

  /// Handle SearchTasks event
  Future<void> _onSearchTasks(
    SearchTasks event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskSearching(currentState.tasks));
    }

    final result = await searchTasks.call(event.query);

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskSearchResults(tasks, event.query)),
    );
  }

  /// Handle GetTasksByPriority event
  Future<void> _onGetTasksByPriority(
    GetTasksByPriority event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskOperationInProgress(currentState.tasks));
    }

    final result = await getTasksByPriority.call(event.priority);

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskFilteredByPriority(tasks, event.priority)),
    );
  }
}

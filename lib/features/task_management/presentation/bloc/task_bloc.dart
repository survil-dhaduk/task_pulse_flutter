import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_service.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/task.dart';
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
  final NotificationService notificationService;

  TaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTaskCompletion,
    required this.searchTasks,
    required this.getTasksByPriority,
    required this.notificationService,
  }) : super(const TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<SearchTasks>(_onSearchTasks);
    on<GetTasksByPriority>(_onGetTasksByPriority);
    on<FilterTasksByStatus>(_onFilterTasksByStatus);
    on<SortTasks>(_onSortTasks);
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
      emit(
        TaskOperationInProgress(currentState.tasks, hint: 'Creating task...'),
      );
    }

    final result = await createTask.call(event.task);

    await result.fold((failure) async => emit(TaskError(failure.message)), (
      _,
    ) async {
      // Schedule notification after successful creation
      await notificationService.scheduleTaskNotification(event.task);

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
      emit(
        TaskOperationInProgress(currentState.tasks, hint: 'Updating task...'),
      );
    }

    final result = await updateTask.call(event.task);

    result.fold((failure) => emit(TaskError(failure.message)), (_) async {
      // Reschedule notification after successful update
      await notificationService.cancelTaskNotification(event.task.id);
      await notificationService.scheduleTaskNotification(event.task);

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
      emit(
        TaskOperationInProgress(currentState.tasks, hint: 'Deleting task...'),
      );
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
      emit(
        TaskOperationInProgress(
          currentState.tasks,
          hint: 'Toggling completion...',
        ),
      );
    }

    final result = await toggleTaskCompletion.call(event.taskId);

    await result.fold((failure) async => emit(TaskError(failure.message)), (
      _,
    ) async {
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
      emit(
        TaskOperationInProgress(
          currentState.tasks,
          hint: 'Filtering by priority...',
        ),
      );
    }

    final result = await getTasksByPriority.call(event.priority);

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskFilteredByPriority(tasks, event.priority)),
    );
  }

  /// Handle FilterTasksByStatus event
  Future<void> _onFilterTasksByStatus(
    FilterTasksByStatus event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskOperationInProgress(currentState.tasks, hint: 'Filtering...'));
    }

    // Fetch all tasks then filter in-memory (repository provides helpers too)
    final result = await getTasks.call();
    result.fold((failure) => emit(TaskError(failure.message)), (tasks) {
      List<Task> filtered;
      switch (event.filter) {
        case TaskStatusFilter.completed:
          filtered = tasks.where((t) => t.isCompleted).toList();
          break;
        case TaskStatusFilter.pending:
          filtered = tasks.where((t) => !t.isCompleted).toList();
          break;
        case TaskStatusFilter.all:
          filtered = tasks;
          break;
      }
      emit(TaskLoaded(filtered, hint: 'filter: ${event.filter.name}'));
    });
  }

  /// Handle SortTasks event
  Future<void> _onSortTasks(SortTasks event, Emitter<TaskState> emit) async {
    final currentState = state;
    List<Task> baseList = [];
    if (currentState is TaskLoaded) {
      baseList = List.of(currentState.tasks);
    } else {
      final result = await getTasks.call();
      final either = result.fold<List<Task>>((_) => [], (tasks) => tasks);
      baseList = List.of(either);
    }

    int priorityRank(Priority p) {
      switch (p) {
        case Priority.high:
          return 3;
        case Priority.medium:
          return 2;
        case Priority.low:
          return 1;
      }
    }

    switch (event.sortOption) {
      case TaskSortOption.dueDateAsc:
        baseList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        emit(TaskLoaded(baseList, hint: 'sorted: due date ↑'));
        break;
      case TaskSortOption.dueDateDesc:
        baseList.sort((a, b) => b.dueDate.compareTo(a.dueDate));
        emit(TaskLoaded(baseList, hint: 'sorted: due date ↓'));
        break;
      case TaskSortOption.priorityHighFirst:
        baseList.sort(
          (a, b) =>
              priorityRank(b.priority).compareTo(priorityRank(a.priority)),
        );
        emit(TaskLoaded(baseList, hint: 'sorted: priority high → low'));
        break;
      case TaskSortOption.priorityLowFirst:
        baseList.sort(
          (a, b) =>
              priorityRank(a.priority).compareTo(priorityRank(b.priority)),
        );
        emit(TaskLoaded(baseList, hint: 'sorted: priority low → high'));
        break;
    }
  }
}

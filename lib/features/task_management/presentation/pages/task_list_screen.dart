import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'task_form_screen.dart';

/// Screen for displaying the list of tasks
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is initialized
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskPulse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Filter menu
          _buildFilterMenu(),
          // Sort menu
          _buildSortMenu(),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTasks());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is TaskLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.hint != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Text(
                      state.hint!,
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                Expanded(child: _buildTaskList(state.tasks)),
              ],
            );
          } else if (state is TaskOperationInProgress) {
            return Stack(
              children: [
                _buildTaskList(state.tasks),
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No tasks available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final taskBloc = context.read<TaskBloc>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(value: taskBloc, child: TaskFormScreen()),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  PopupMenuButton<TaskStatusFilter> _buildFilterMenu() {
    return PopupMenuButton<TaskStatusFilter>(
      tooltip: 'Filter',
      icon: const Icon(Icons.filter_list),
      onSelected: (filter) {
        context.read<TaskBloc>().add(FilterTasksByStatus(filter));
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: TaskStatusFilter.all, child: Text('All')),
        PopupMenuItem(value: TaskStatusFilter.pending, child: Text('Pending')),
        PopupMenuItem(
          value: TaskStatusFilter.completed,
          child: Text('Completed'),
        ),
      ],
    );
  }

  PopupMenuButton<TaskSortOption> _buildSortMenu() {
    return PopupMenuButton<TaskSortOption>(
      tooltip: 'Sort',
      icon: const Icon(Icons.sort),
      onSelected: (option) {
        context.read<TaskBloc>().add(SortTasks(option));
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: TaskSortOption.dueDateAsc,
          child: Text('Due date ↑'),
        ),
        PopupMenuItem(
          value: TaskSortOption.dueDateDesc,
          child: Text('Due date ↓'),
        ),
        PopupMenuItem(
          value: TaskSortOption.priorityHighFirst,
          child: Text('Priority high → low'),
        ),
        PopupMenuItem(
          value: TaskSortOption.priorityLowFirst,
          child: Text('Priority low → high'),
        ),
      ],
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first task',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildTaskCard(task),
        );
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _onEditTask(task),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) => _onDeleteTask(task),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _onToggleTaskCompletion(task),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Checkbox
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => _onToggleTaskCompletion(task),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? Theme.of(context).colorScheme.outline
                                        : null,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildPriorityChip(task.priority),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: task.isCompleted
                                    ? Theme.of(context).colorScheme.outline
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: _getDueDateColor(task),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(task.dueDate),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: _getDueDateColor(task)),
                          ),
                          if (task.isOverdue) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'OVERDUE',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onError,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(Priority priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(priority.colorValue).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(priority.colorValue).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          color: Color(priority.colorValue),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getDueDateColor(Task task) {
    if (task.isCompleted) {
      return Theme.of(context).colorScheme.outline;
    }
    if (task.isOverdue) {
      return Theme.of(context).colorScheme.error;
    }
    if (task.isDueToday) {
      return Theme.of(context).colorScheme.primary;
    }
    if (task.isDueSoon) {
      return Theme.of(context).colorScheme.tertiary;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final tomorrow = today.add(const Duration(days: 1));

    if (dueDateOnly.isAtSameMomentAs(today)) {
      return 'Today at ${DateFormat('HH:mm').format(dueDate)}';
    } else if (dueDateOnly.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow at ${DateFormat('HH:mm').format(dueDate)}';
    } else {
      return DateFormat('MMM dd, yyyy HH:mm').format(dueDate);
    }
  }

  void _onToggleTaskCompletion(Task task) {
    context.read<TaskBloc>().add(ToggleTaskCompletion(task.id));
  }

  void _onEditTask(Task task) {
    final taskBloc = context.read<TaskBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: taskBloc,
          child: TaskFormScreen(task: task),
        ),
      ),
    );
  }

  void _onDeleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TaskBloc>().add(DeleteTask(task.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

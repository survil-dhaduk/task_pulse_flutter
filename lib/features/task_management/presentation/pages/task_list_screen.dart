import 'dart:async';

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
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is initialized
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Rebuild to update the clear icon visibility
    setState(() {});

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        context.read<TaskBloc>().add(const LoadTasks());
      } else {
        context.read<TaskBloc>().add(SearchTasks(trimmed));
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
    context.read<TaskBloc>().add(const LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine screen size breakpoints
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= 600;
        final isDesktop = screenWidth >= 1200;

        // Responsive padding and layout adjustments
        final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
        final searchBottomPadding = isTablet ? 16.0 : 12.0;

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
              SizedBox(width: isTablet ? 16 : 8),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(isTablet ? 72 : 56),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  searchBottomPadding,
                ),
                child: _buildResponsiveSearchField(isTablet),
              ),
            ),
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
                        size: isTablet ? 80 : 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
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
                    Expanded(
                      child: _buildTaskList(
                        state.tasks,
                        screenWidth,
                        isTablet,
                        isDesktop,
                      ),
                    ),
                  ],
                );
              } else if (state is TaskSearchResults) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 8,
                      ),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: Text(
                        "Search: '${state.query}' — ${state.tasks.length} result(s)",
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: _buildTaskList(
                        state.tasks,
                        screenWidth,
                        isTablet,
                        isDesktop,
                      ),
                    ),
                  ],
                );
              } else if (state is TaskSearching) {
                return Stack(
                  children: [
                    _buildTaskList(
                      state.tasks,
                      screenWidth,
                      isTablet,
                      isDesktop,
                    ),
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                );
              } else if (state is TaskOperationInProgress) {
                return Stack(
                  children: [
                    _buildTaskList(
                      state.tasks,
                      screenWidth,
                      isTablet,
                      isDesktop,
                    ),
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
                  builder: (context) => BlocProvider.value(
                    value: taskBloc,
                    child: TaskFormScreen(),
                  ),
                ),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveSearchField(bool isTablet) {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: isTablet ? 16 : 14),
      decoration: InputDecoration(
        hintText: 'Search tasks...',
        hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
        prefixIcon: Icon(Icons.search, size: isTablet ? 24 : 20),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear',
                icon: Icon(Icons.clear, size: isTablet ? 24 : 20),
                onPressed: _clearSearch,
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        ),
        isDense: !isTablet,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 16 : 12,
        ),
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

  Widget _buildTaskList(
    List<Task> tasks,
    double screenWidth,
    bool isTablet,
    bool isDesktop,
  ) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: isTablet ? 80 : 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontSize: isTablet ? 28 : null,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 24),
              child: Text(
                'Tap the + button to create your first task',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: isTablet ? 16 : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    // Determine responsive layout
    final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final itemSpacing = isTablet ? 12.0 : 8.0;

    // For desktop screens, use a grid layout with limited width
    if (isDesktop && screenWidth > 1200) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: GridView.builder(
            padding: EdgeInsets.all(horizontalPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: itemSpacing,
              childAspectRatio: 3.5,
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskCard(task, isTablet, isDesktop);
            },
          ),
        ),
      );
    }

    // For tablets and phones, use ListView
    return ListView.builder(
      padding: EdgeInsets.all(horizontalPadding),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: EdgeInsets.only(bottom: itemSpacing),
          child: _buildTaskCard(task, isTablet, isDesktop),
        );
      },
    );
  }

  Widget _buildTaskCard(Task task, bool isTablet, bool isDesktop) {
    final cardPadding = isTablet ? 20.0 : 16.0;
    final checkboxScale = isTablet ? 1.2 : 1.0;
    final spacingBetweenElements = isTablet ? 16.0 : 12.0;
    final iconSize = isTablet ? 20.0 : 16.0;

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
        elevation: isTablet ? 3 : 2,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _onToggleTaskCompletion(task),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                // Checkbox
                Transform.scale(
                  scale: checkboxScale,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _onToggleTaskCompletion(task),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: spacingBetweenElements),
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
                                    fontSize: isTablet ? 18 : null,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildPriorityChip(task.priority, isTablet),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        SizedBox(height: isTablet ? 6 : 4),
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
                                fontSize: isTablet ? 16 : null,
                              ),
                          maxLines: isTablet ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: isTablet ? 12 : 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: iconSize,
                            color: _getDueDateColor(task),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(task.dueDate),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getDueDateColor(task),
                                  fontSize: isTablet ? 14 : null,
                                ),
                          ),
                          if (task.isOverdue) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 8 : 6,
                                vertical: isTablet ? 3 : 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 6 : 4,
                                ),
                              ),
                              child: Text(
                                'OVERDUE',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onError,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isTablet ? 11 : null,
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

  Widget _buildPriorityChip(Priority priority, bool isTablet) {
    final chipPadding = isTablet ? 10.0 : 8.0;
    final chipVerticalPadding = isTablet ? 5.0 : 4.0;
    final fontSize = isTablet ? 12.0 : 10.0;
    final borderRadius = isTablet ? 14.0 : 12.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: chipPadding,
        vertical: chipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Color(priority.colorValue).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Color(priority.colorValue).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          color: Color(priority.colorValue),
          fontSize: fontSize,
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

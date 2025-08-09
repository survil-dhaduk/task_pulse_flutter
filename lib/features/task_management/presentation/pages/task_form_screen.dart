import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

/// Screen for creating and editing tasks
class TaskFormScreen extends StatefulWidget {
  final Task? task; // If null, create new task; if not null, edit existing task

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Priority _selectedPriority = Priority.medium;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.task != null) {
      // Editing existing task
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.dueDate);
      _selectedPriority = widget.task!.priority;
    } else {
      // Creating new task - set default date to tomorrow
      _selectedDate = DateTime.now().add(const Duration(days: 1));
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  DateTime _getCombinedDateTime() {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final dueDateTime = _getCombinedDateTime();

      if (widget.task != null) {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: dueDateTime,
          priority: _selectedPriority,
          updatedAt: DateTime.now(),
        );

        context.read<TaskBloc>().add(UpdateTask(updatedTask));
      } else {
        // Create new task
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: dueDateTime,
          priority: _selectedPriority,
          isCompleted: false,
          createdAt: DateTime.now(),
        );

        context.read<TaskBloc>().add(CreateTask(newTask));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine screen size breakpoints
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= 600;
        final isDesktop = screenWidth >= 1200;

        // Responsive layout adjustments
        final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
        final formMaxWidth = isDesktop ? 800.0 : double.infinity;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.task != null ? 'Edit Task' : 'Create Task',
              style: TextStyle(fontSize: isTablet ? 22 : null),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            elevation: 0,
          ),
          body: BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskLoaded) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.task != null
                          ? 'Task updated successfully!'
                          : 'Task created successfully!',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              } else if (state is TaskError) {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                Widget buildMainContent() {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: formMaxWidth),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(horizontalPadding),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Title Field
                              TextFormField(
                                controller: _titleController,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : null,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  labelStyle: TextStyle(
                                    fontSize: isTablet ? 16 : null,
                                  ),
                                  hintText: 'Enter task title',
                                  hintStyle: TextStyle(
                                    fontSize: isTablet ? 16 : null,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 16 : 12,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 20 : 16,
                                    vertical: isTablet ? 20 : 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: isTablet ? 24 : 16),

                              // Description Field
                              TextFormField(
                                controller: _descriptionController,
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : null,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                    fontSize: isTablet ? 16 : null,
                                  ),
                                  hintText: 'Enter task description',
                                  hintStyle: TextStyle(
                                    fontSize: isTablet ? 16 : null,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 16 : 12,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 20 : 16,
                                    vertical: isTablet ? 20 : 16,
                                  ),
                                ),
                                maxLines: isTablet ? 4 : 3,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: isTablet ? 32 : 24),

                              // Date and Time Selection
                              Card(
                                elevation: isTablet ? 3 : 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 20 : 16,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    isTablet ? 24.0 : 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Due Date & Time',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontSize: isTablet ? 20 : null,
                                            ),
                                      ),
                                      SizedBox(height: isTablet ? 20 : 16),
                                      isTablet
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: _buildDateTimeSelector(
                                                    Icons.calendar_today,
                                                    DateFormat(
                                                      'MMM dd, yyyy',
                                                    ).format(_selectedDate),
                                                    _selectDate,
                                                    isTablet,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: _buildDateTimeSelector(
                                                    Icons.access_time,
                                                    _selectedTime.format(
                                                      context,
                                                    ),
                                                    _selectTime,
                                                    isTablet,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                _buildDateTimeSelector(
                                                  Icons.calendar_today,
                                                  DateFormat(
                                                    'MMM dd, yyyy',
                                                  ).format(_selectedDate),
                                                  _selectDate,
                                                  isTablet,
                                                ),
                                                const SizedBox(height: 8),
                                                _buildDateTimeSelector(
                                                  Icons.access_time,
                                                  _selectedTime.format(context),
                                                  _selectTime,
                                                  isTablet,
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: isTablet ? 24 : 16),

                              // Priority Selection
                              Card(
                                elevation: isTablet ? 3 : 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 20 : 16,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    isTablet ? 24.0 : 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Priority',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontSize: isTablet ? 20 : null,
                                            ),
                                      ),
                                      SizedBox(height: isTablet ? 20 : 16),
                                      ...Priority.values.map(
                                        (priority) => RadioListTile<Priority>(
                                          title: Row(
                                            children: [
                                              Container(
                                                width: isTablet ? 20 : 16,
                                                height: isTablet ? 20 : 16,
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                    priority.colorValue,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(
                                                width: isTablet ? 12 : 8,
                                              ),
                                              Text(
                                                priority.displayName,
                                                style: TextStyle(
                                                  fontSize: isTablet
                                                      ? 16
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: priority,
                                          groupValue: _selectedPriority,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: isTablet ? 8 : 0,
                                            vertical: isTablet ? 4 : 0,
                                          ),
                                          onChanged: (Priority? value) {
                                            setState(() {
                                              _selectedPriority = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: isTablet ? 48 : 32),

                              // Submit Button
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 20 : 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 16 : 12,
                                    ),
                                  ),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        height: isTablet ? 24 : 20,
                                        width: isTablet ? 24 : 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: isTablet ? 3 : 2,
                                        ),
                                      )
                                    : Text(
                                        widget.task != null
                                            ? 'Update Task'
                                            : 'Create Task',
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 16,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Stack(
                  children: [
                    buildMainContent(),
                    if (_isLoading)
                      Container(
                        color: Colors.black54,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateTimeSelector(
    IconData icon,
    String text,
    VoidCallback onTap,
    bool isTablet,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 16 : 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: isTablet ? 24 : 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

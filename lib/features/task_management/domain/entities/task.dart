import 'package:equatable/equatable.dart';

import 'priority.dart';

/// Task entity representing a task in the application
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy of this task with updated properties
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create a task with completed status toggled
  Task toggleCompletion() {
    return copyWith(isCompleted: !isCompleted, updatedAt: DateTime.now());
  }

  /// Check if the task is overdue
  bool get isOverdue {
    return !isCompleted && DateTime.now().isAfter(dueDate);
  }

  /// Check if the task is due today
  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return dueDateOnly.isAtSameMomentAs(today);
  }

  /// Check if the task is due soon (within 3 days)
  bool get isDueSoon {
    final now = DateTime.now();
    final threeDaysFromNow = now.add(const Duration(days: 3));
    return !isCompleted &&
        dueDate.isAfter(now) &&
        dueDate.isBefore(threeDaysFromNow) &&
        !isOverdue;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    dueDate,
    priority,
    isCompleted,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dueDate: $dueDate, priority: $priority, isCompleted: $isCompleted)';
  }
}

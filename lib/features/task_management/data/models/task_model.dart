import 'package:hive/hive.dart';

import '../../domain/entities/task.dart';
import 'priority_model.dart';

part 'task_model.g.dart';

/// Task model for data layer with Hive serialization support
@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final PriorityModel priority;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert TaskModel to Task entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority.toEntity(),
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert Task entity to TaskModel
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: PriorityModel.fromEntity(task.priority),
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  /// Create a copy of this task model with updated properties
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    PriorityModel? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
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

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, dueDate: $dueDate, priority: $priority, isCompleted: $isCompleted)';
  }
}

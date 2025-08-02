import 'package:hive/hive.dart';
import '../../domain/entities/priority.dart';

part 'priority_model.g.dart';

/// Priority model for data layer with Hive serialization support
@HiveType(typeId: 1)
enum PriorityModel {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high;

  /// Convert PriorityModel to Priority entity
  Priority toEntity() {
    switch (this) {
      case PriorityModel.low:
        return Priority.low;
      case PriorityModel.medium:
        return Priority.medium;
      case PriorityModel.high:
        return Priority.high;
    }
  }

  /// Convert Priority entity to PriorityModel
  static PriorityModel fromEntity(Priority priority) {
    switch (priority) {
      case Priority.low:
        return PriorityModel.low;
      case Priority.medium:
        return PriorityModel.medium;
      case Priority.high:
        return PriorityModel.high;
    }
  }
} 
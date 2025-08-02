import 'package:flutter_test/flutter_test.dart';
import 'package:task_pulse/features/task_management/domain/entities/priority.dart';
import 'package:task_pulse/features/task_management/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    late Task task;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: now.add(const Duration(days: 1)),
        priority: Priority.medium,
        isCompleted: false,
        createdAt: now,
      );
    });

    test('should create a task with all required properties', () {
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.priority, Priority.medium);
      expect(task.isCompleted, false);
      expect(task.createdAt, now);
      expect(task.updatedAt, null);
    });

    test('should create a copy of task with updated properties', () {
      final updatedTask = task.copyWith(
        title: 'Updated Task',
        isCompleted: true,
        updatedAt: now.add(const Duration(hours: 1)),
      );

      expect(updatedTask.id, task.id);
      expect(updatedTask.title, 'Updated Task');
      expect(updatedTask.description, task.description);
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.updatedAt, now.add(const Duration(hours: 1)));
    });

    test('should toggle completion status', () {
      final toggledTask = task.toggleCompletion();

      expect(toggledTask.isCompleted, true);
      expect(toggledTask.updatedAt, isNotNull);

      final toggledBackTask = toggledTask.toggleCompletion();

      expect(toggledBackTask.isCompleted, false);
    });

    test('should identify overdue tasks', () {
      final overdueTask = task.copyWith(
        dueDate: now.subtract(const Duration(days: 1)),
      );

      expect(overdueTask.isOverdue, true);
      expect(task.isOverdue, false);
    });

    test('should identify tasks due today', () {
      final todayTask = task.copyWith(
        dueDate: DateTime(now.year, now.month, now.day),
      );

      expect(todayTask.isDueToday, true);
      expect(task.isDueToday, false);
    });

    test('should identify tasks due soon', () {
      final soonTask = task.copyWith(dueDate: now.add(const Duration(days: 2)));

      expect(soonTask.isDueSoon, true);
      // Original task is due in 1 day, which is within 3 days, so it should be "due soon"
      expect(task.isDueSoon, true);
    });

    test('should not be overdue if completed', () {
      final completedOverdueTask = task.copyWith(
        dueDate: now.subtract(const Duration(days: 1)),
        isCompleted: true,
      );

      expect(completedOverdueTask.isOverdue, false);
    });

    test('should not be due soon if overdue', () {
      final overdueTask = task.copyWith(
        dueDate: now.subtract(const Duration(days: 1)),
      );

      expect(overdueTask.isDueSoon, false);
    });

    test('should implement Equatable correctly', () {
      final task1 = Task(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        dueDate: now,
        priority: Priority.high,
        isCompleted: false,
        createdAt: now,
      );

      final task2 = Task(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        dueDate: now,
        priority: Priority.high,
        isCompleted: false,
        createdAt: now,
      );

      final task3 = Task(
        id: '2',
        title: 'Task 2',
        description: 'Description 2',
        dueDate: now,
        priority: Priority.low,
        isCompleted: true,
        createdAt: now,
      );

      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('should have correct toString representation', () {
      final expectedString =
          'Task(id: 1, title: Test Task, description: Test Description, dueDate: ${task.dueDate}, priority: Priority.medium, isCompleted: false)';
      expect(task.toString(), expectedString);
    });
  });
}

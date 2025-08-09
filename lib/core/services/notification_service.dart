import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/task_management/domain/entities/task.dart';

/// Notification service abstraction to decouple UI/BLoC from plugin specifics
abstract class NotificationService {
  /// Underlying plugin instance (exposed for advanced scenarios if needed)
  FlutterLocalNotificationsPlugin get plugin;

  /// Initialize notification plugin, channels, and timezone data
  Future<void> initialize();

  /// Request notification permissions where applicable (iOS, macOS)
  Future<bool> requestPermission();

  /// Schedule a notification for a task's due date
  Future<void> scheduleTaskNotification(Task task);

  /// Cancel a notification for a task (by id)
  Future<void> cancelTaskNotification(String taskId);
}

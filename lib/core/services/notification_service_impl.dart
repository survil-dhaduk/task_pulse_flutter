import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/task_management/domain/entities/task.dart';
import 'notification_service.dart';

/// Concrete implementation using flutter_local_notifications
class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  @override
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  @override
  Future<void> initialize() async {
    try {
      // Initialize timezone database
      try {
        tz.initializeTimeZones();
        final String localTimeZone =
            tz.local.name; // triggers tz initialization
        // ignore: avoid_print
        print('Timezone initialized: $localTimeZone');
      } catch (_) {
        // noop if already initialized
      }

      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings iosInit = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      final InitializationSettings initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
        macOS: iosInit,
      );

      await _plugin.initialize(initSettings);

      // Create Android notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'task_channel',
        'Task Notifications',
        description: 'Notifications for task reminders',
        importance: Importance.high,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    } catch (e) {
      // Swallow exceptions in test or unsupported environments
      // ignore: avoid_print
      print('NotificationService.initialize skipped: $e');
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        final result = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return result ?? false;
      }
      // Android 13+ runtime permission handled by the plugin via manifests;
      // if needed, permissions_handler can be integrated later.
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Notification permission request skipped: $e');
      return false;
    }
  }

  @override
  Future<void> scheduleTaskNotification(Task task) async {
    // Don't schedule past notifications
    final DateTime when = task.dueDate;
    if (when.isBefore(DateTime.now())) {
      return;
    }

    final int notificationId = task.id.hashCode;
    final tz.TZDateTime tzWhen = tz.TZDateTime.from(when, tz.local);

    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        channelDescription: 'Notifications for task reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      notificationId,
      task.title,
      task.description,
      tzWhen,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: task.id,
      matchDateTimeComponents: null,
    );
  }

  @override
  Future<void> cancelTaskNotification(String taskId) async {
    await _plugin.cancel(taskId.hashCode);
  }
}

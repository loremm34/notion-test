import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notion_test/data/repository/notification_repository.dart';
import 'package:timezone/timezone.dart' as tz;

// севрис интеграции уведомлений
class NotificationService implements NotificationRepository {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // запрос разрешения на отправку уведомлений
  @override
  Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User has granted permission for notifications');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User has granted provisional permission for notifications');
    } else {
      log('User has declined permission for notifications');
    }
  }

  // создание запланированного уведомления
  @override
  Future<void> scheduleNotification(
      DateTime targetDateTime, String noteTitle) async {
    final scheduledTime = targetDateTime.subtract(const Duration(hours: 1));

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledTime, tz.local);

    log('Notification scheduled for $noteTitle at ${scheduledDate.toLocal()}');

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        '1',
        'Notion',
        channelDescription: 'Notifications for notes',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Reminder for note',
      'Time for: $noteTitle',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // инициализация уведомлений
  @override
  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> deleteAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> deleteNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/muslim');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> setTestNotification(BuildContext context) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      10,
      "Test notification",
      "This is a test notification",
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          timeoutAfter: 155000,
          fullScreenIntent: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
          enableVibration: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> setNotification(int id, String title, String body, int hour,
      int minute, BuildContext context) async {
    //  Use zonedSchedule instead by passing a date in the future
    //with the same time and pass DateTimeComponents.matchTime as
    //the value of the matchDateTimeComponents parameter..
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      setTiming(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
          timeoutAfter: 155000,
          enableVibration: true,
          fullScreenIntent: true,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    print("Notification set daily at time $hour:$minute");
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime setTiming(int hour, int minute) {
    Duration offsetTime = DateTime.now().timeZoneOffset;
    print(offsetTime);
    tz.initializeTimeZones();
    var now = DateTime.now();
    tz.TZDateTime scheduledDate = (offsetTime.isNegative)
        ? tz.TZDateTime(tz.UTC, now.year, now.month, now.day, hour, minute)
            .add(offsetTime)
        : tz.TZDateTime(tz.UTC, now.year, now.month, now.day, hour, minute)
            .subtract(offsetTime);
    print(scheduledDate);
    return scheduledDate;
  }
}

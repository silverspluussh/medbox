// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:MedBox/constants/colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifConsole {
  int id = 0;
  double rand = Random().nextDouble() * 234;
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initnotifs() async {
    AndroidInitializationSettings initializationSettings =
        const AndroidInitializationSettings('ic_launcher');

    var initSettings = InitializationSettings(android: initializationSettings);
    await notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) async {});
  }

  notificationdetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(rand.toString(), '$rand medbox',
          fullScreenIntent: true,
          color: AppColors.primaryColor.withOpacity(0.3),
          priority: Priority.high,
          importance: Importance.max),
    );
  }

  tenamnotification() {
    return NotificationDetails(
      android: AndroidNotificationDetails('10', 'ten10am',
          fullScreenIntent: true,
          color: AppColors.primaryColor.withOpacity(0.3),
          priority: Priority.high,
          importance: Importance.max),
    );
  }

  Future<void> scheduleDailyTenAMNotification() async {
    await notificationsPlugin.zonedSchedule(
        id++,
        'Update Vitals ',
        'It\'s a new day, please update your vitals to keep Medbox updated with the latest health information',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true);
  }

  Future<void> instantnotif({String title, String body, String payload}) async {
    await notificationsPlugin.show(
      id++,
      title,
      body,
      await tenamnotification(),
      payload: payload,
    );
  }

  Future<void> setreminder(
      {String title, String body, String payload, int hour, int minute}) async {
    await notificationsPlugin
        .zonedSchedule(
            id++,
            title,
            body,
            instanceofsettime(hour: hour, minute: minute),
            await notificationdetails(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.time)
        // ignore: avoid_print
        .then((value) => print('alarm is set successfully'));
  }

  Future<void> cancelreminder({id}) async {
    await notificationsPlugin.cancel(id);
  }

  Future<List<PendingNotificationRequest>> pendingreminders() async {
    List<PendingNotificationRequest> pending;
    pending = await notificationsPlugin.pendingNotificationRequests();
    if (pending.isNotEmpty) {
      return pending;
    }
    return [];
  }

  Future<List<ActiveNotification>> activereminders() async {
    List<ActiveNotification> active;
    active = await notificationsPlugin.getActiveNotifications();
    if (active.isNotEmpty) {
      return active;
    }
    return [];
  }

  //
  //
  //

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime instanceofsettime({int hour, int minute}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifConsole {
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
    return const NotificationDetails(
      android: AndroidNotificationDetails('medboxid', 'medbox',
          importance: Importance.max),
    );
  }

  Future<void> medicationalerts(
      {required String? title,
      required String? body,
      String? payload,
      required int hour,
      required int minute}) async {
    await notificationsPlugin
        .zonedSchedule(
            Random().nextInt(2000),
            title,
            body,
            instanceofsettime(hour: hour, minute: minute, repeat: 7),
            await notificationdetails(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.time)
        .then((value) => print('alarm is set successfully'));
  }

  tz.TZDateTime instanceofsettime(
      {required int hour, required int minute, required int repeat}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: repeat));
    }
    return scheduledDate;
  }

  Future<void> cancelreminder({required id}) async {
    await notificationsPlugin.cancel(id);
  }

  Future<List<PendingNotificationRequest>> getreminders() async {
    List<PendingNotificationRequest> active;
    active = await notificationsPlugin.pendingNotificationRequests();
    if (active.isNotEmpty) {
      return active;
    }
    return [];
  }
}

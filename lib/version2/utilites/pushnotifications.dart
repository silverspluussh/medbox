// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:MedBox/version2/UI/render.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../constants/colors.dart';
import 'randomgen.dart';

class NotificationBundle {
  Future<void> scheduleAlarm(
    tz.TZDateTime? datetime, {
    DateTimeComponents? components,
    String? title,
    String? body,
    String? id,
  }) async {
    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(idg().toString(), 'me${idg()}',
          fullScreenIntent: true,
          color: kprimary.withOpacity(0.3),
          channelDescription: 'This is an alarm notification',
          priority: Priority.high,
          importance: Importance.max),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(id!),
      title,
      body,
      // tz.TZDateTime.from(datetime, tz.local),
      tz.TZDateTime(tz.local, datetime!.hour, datetime.minute),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: components,
    );
  }

  Future<void> onSaveAlarm({
    DateTimeComponents? components,
    tz.TZDateTime? alarmTime,
    String? title,
    String? body,
    String? id,
  }) async {
    tz.TZDateTime? scheduleAlarmDateTime;
    if (alarmTime!.isAfter(tz.TZDateTime.now(tz.local))) {
      scheduleAlarmDateTime = alarmTime;
    } else {
      scheduleAlarmDateTime = alarmTime.add(const Duration(days: 1));
    }

    await scheduleAlarm(scheduleAlarmDateTime,
            id: id, title: title, body: body, components: components)
        .then((value) => log('alarm added'));
  }

  //
  //
  Future<void> dateSchedule(
    tz.TZDateTime? datetime, {
    DateTimeComponents? components,
    String? title,
    String? body,
    String? id,
  }) async {
    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(idg().toString(), 'me${idg()}',
          fullScreenIntent: true,
          color: kprimary.withOpacity(0.3),
          channelDescription: 'This is an alarm notification',
          priority: Priority.high,
          importance: Importance.max),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(id!),
      title,
      body,
      datetime!,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: components,
    );
  }

  Future<void> dateAlarm({
    DateTimeComponents? components,
    tz.TZDateTime? alarmTime,
    String? title,
    String? body,
    String? id,
  }) async {
    tz.TZDateTime? scheduleAlarmDateTime;
    if (alarmTime!.isAfter(tz.TZDateTime.now(tz.local))) {
      scheduleAlarmDateTime = alarmTime;
    } else {
      scheduleAlarmDateTime = alarmTime.add(const Duration(days: 1));
    }

    await dateSchedule(scheduleAlarmDateTime,
            id: id, title: title, body: body, components: components)
        .then((value) => log('alarm added'));
  }

  //
  //

  int id = int.parse(idg().toString());
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //schedule periodic alarm
  Future periodicnotification(
      {String? title,
      String? body,
      String? payload,
      int? hour,
      int? minute}) async {
    await notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      NotificationDetails(
        android: AndroidNotificationDetails(idg().toString(), 'me${idg()}',
            fullScreenIntent: true,
            color: kprimary.withOpacity(0.3),
            channelDescription: 'This is an alarm notification',
            priority: Priority.high,
            importance: Importance.max),
      ),
      payload: payload,
      androidAllowWhileIdle: true,
    );
  }

  //custom Crud

  Future<void> deleteAlarm({id}) async => await notificationsPlugin.cancel(id);
  //
  Future<List<PendingNotificationRequest>> showReminders() async {
    List<PendingNotificationRequest> pending;
    pending = await notificationsPlugin.pendingNotificationRequests();
    if (pending.isNotEmpty) {
      log(pending[0].body.toString());
      return pending;
    }
    return [];
  }
}

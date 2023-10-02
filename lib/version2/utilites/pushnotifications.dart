// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../main.dart';
import 'randomgen.dart';

class NotificationBundle {
  Future<void> scheduleAlarm(
    DateTime datetime, {
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
      title.toString().capitalized,
      body.toString().capitalized,
      tz.TZDateTime.from(datetime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      payload: DateFormat('HH:mm').format(datetime),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: components,
    );
  }

  Future<void> onSaveAlarm({
    DateTimeComponents? components,
    DateTime? alarmTime,
    String? title,
    String? body,
    String? id,
  }) async {
    DateTime? scheduleAlarmDateTime;
    if (alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = alarmTime;
    } else {
      scheduleAlarmDateTime = alarmTime.add(const Duration(days: 1));
    }

    await scheduleAlarm(scheduleAlarmDateTime,
        id: id, title: title, body: body, components: components);
  }

  int id = int.parse(idg().toString());
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future adonMessage(String? medname, String? time) async {
    String user = FirebaseAuth.instance.currentUser!.displayName ?? "User";
    await notificationsPlugin.show(
        idg(),
        "${medname.toString().capitalized} added",
        "Dear $user, you just added $medname to your medications. A reminder has been set for $time. ",
        NotificationDetails(
          android: AndroidNotificationDetails(idg().toString(), 'me${idg()}',
              fullScreenIntent: true,
              color: kprimary.withOpacity(0.3),
              channelDescription: 'This is an instant notification',
              priority: Priority.high,
              importance: Importance.max),
        ));
  }

  //schedule periodic alarm
  Future periodicnotification(
      {String? title,
      String? body,
      String? payload,
      int? hour,
      int? minute}) async {
    await notificationsPlugin.periodicallyShow(
      id,
      title.toString().capitalized,
      body.toString().capitalized,
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
      return pending;
    }
    return [];
  }
}

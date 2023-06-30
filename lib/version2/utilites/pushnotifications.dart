// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../constants/colors.dart';
import 'randomgen.dart';

class NotificationBundle {
  int id = int.parse(idg().toString());
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings initializationSettings =
      const AndroidInitializationSettings('ic_launcher');

  AndroidNotificationDetails notifDetails = AndroidNotificationDetails(
      idg().toString(), 'medbox${idg()}',
      fullScreenIntent: true,
      color: kprimary.withOpacity(0.3),
      priority: Priority.high,
      importance: Importance.max);

  AndroidNotificationChannel notifChannel = AndroidNotificationChannel(
    idg().toString(),
    'medbox${idg()}',
    importance: Importance.max,
  );

  notificationDetails() {
    return NotificationDetails(android: notifDetails);
  }

//initialise
  Future initialzeNotification() async {
    var initSettings = InitializationSettings(android: initializationSettings);

    await notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) async {});
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notifChannel);

    FirebaseMessaging.onMessage.listen((event) async {
      BigTextStyleInformation bigtext = BigTextStyleInformation(
          event.notification!.body.toString(),
          htmlFormatBigText: true);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'fmedbox${idg()}',
        'firemedbox${idg()}',
        importance: Importance.max,
        styleInformation: bigtext,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails channelSpecifics =
          NotificationDetails(android: androidNotificationDetails);

      await notificationsPlugin.show(0, event.notification?.title,
          event.notification?.body, channelSpecifics,
          payload: event.data['title']);
    });
  }
  //

  tz.TZDateTime instanceof10() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime instanceScheduleTime({int? hour, int? minute}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      hour!,
      minute!,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime instantAps({int? month, int? day, int? hour, int? minute}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      month!,
      day!,
      hour!,
      minute!,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  //10 am schedule
  Future<void> scheduleDailyTenAMNotification() async {
    await notificationsPlugin.zonedSchedule(
        1,
        'Update Your Health Vitals ',
        'It\'s a new day, please update your vitals to keep Medbox updated with ypur latest health information',
        instanceof10(),
        NotificationDetails(
          android: notifDetails,
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true);
  }

//
  Future instancems(String body) async {
    await notificationsPlugin.show(0, 'sth', body, await notificationDetails());
  }

  //schedule custom time
  Future<void> setreminder(
      {String? title,
      String? body,
      String? payload,
      String? id,
      int? hour,
      int? minute}) async {
    await notificationsPlugin
        .zonedSchedule(
            int.parse(id!),
            title,
            body,
            instanceScheduleTime(hour: hour!, minute: minute!),
            await notificationDetails(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.time)
        .then((value) => log('alarm is set successfully'));
  }

  Future<void> scheduleaps(
      {String? title,
      String? body,
      String? payload,
      String? id,
      int? month,
      int? day,
      int? hour,
      int? minute}) async {
    await notificationsPlugin
        .zonedSchedule(
            int.parse(id!),
            title,
            body,
            instantAps(day: day, hour: hour, minute: minute, month: month),
            await notificationDetails(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.time)
        .then((value) => log('Schedule  is set successfully'));
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
      title,
      body,
      RepeatInterval.daily,
      await notificationDetails(),
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
      log(pending.toString());
      return pending;
    }
    return [];
  }
}

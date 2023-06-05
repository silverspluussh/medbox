// ignore_for_file: depend_on_referenced_packages
import 'dart:math';
import 'package:MedBox/constants/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifConsole {
  int id = 0;
  int rand = Random().nextInt(10039) * 234;
  int hash = Random().nextInt(10039) * 22;

  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  notificationdetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(rand.toString(), '$rand medbox',
          fullScreenIntent: true,
          color: kprimary.withOpacity(0.3),
          priority: Priority.high,
          importance: Importance.max),
    );
  }

  Future<void> initnotifs() async {
    AndroidInitializationSettings initializationSettings =
        const AndroidInitializationSettings('ic_launcher');

    var initSettings = InitializationSettings(android: initializationSettings);

    await notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) async {});

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(AndroidNotificationChannel(
          rand.toString(),
          '$rand medbox',
          importance: Importance.max,
        ));

    FirebaseMessaging.onMessage.listen((event) async {
      BigTextStyleInformation bigtext = BigTextStyleInformation(
          event.notification!.body.toString(),
          htmlFormatBigText: true);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'fmedbox',
        ' fmedbox',
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

  Future<void> scheduleDailyTenAMNotification() async {
    await notificationsPlugin.zonedSchedule(
        1,
        'Update Vitals ',
        'It\'s a new day, please update your vitals to keep Medbox updated with the latest health information',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('10am', 'daily 10am reminder',
              channelDescription: 'alerts user everyday at 10am GMT',
              importance: Importance.max),
        ),
        payload: hash.toString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true);
  }

  Future<void> setreminder(
      {String? title,
      String? body,
      String? payload,
      int? hour,
      int? minute}) async {
    await notificationsPlugin
        .zonedSchedule(
            rand,
            title,
            body,
            instanceofsettime(hour: hour!, minute: minute!),
            await notificationdetails(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.time)
        // ignore: avoid_print
        .then((value) => print('alarm is set successfully'));
  }

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
      await notificationdetails(),
      payload: payload,
      androidAllowWhileIdle: true,
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(seconds: 5));
    }
    return scheduledDate;
  }

  tz.TZDateTime instanceofsettime({int? hour, int? minute}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      hour!,
      minute!,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(seconds: 5));
    }
    return scheduledDate;
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
}

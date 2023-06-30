// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:MedBox/constants/theme.dart';
import 'package:MedBox/version2/firebase/tokenfire.dart';
import 'package:MedBox/version2/sqflite/reminderlocal.dart';
import 'package:MedBox/version2/utilites/sharedprefs.dart';
import 'package:MedBox/l10n/langprovider.dart';
import 'package:MedBox/l10n/l10n.dart';
import 'package:MedBox/version2/UI/authpage.dart';
import 'package:MedBox/version2/UI/render.dart';
import 'package:MedBox/version2/UI/tour.dart';
import 'package:MedBox/version2/utilites/pushnotifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'firebase_options.dart';

late SharedPreferences prefs;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();

  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      webRecaptchaSiteKey: 'AIzaSyC1ZR4jPKRohSDf633c78Yzj7WWj4u7g-I');
  await NotificationBundle().initialzeNotification();

  await FirebaseMessaging.instance.getInitialMessage();

  await configureLocalTimeZone();

  runApp(const ProviderScope(child: MedBox()));
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final timezone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezone));
}

class MedBox extends ConsumerStatefulWidget {
  const MedBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MedBoxState();
}

class _MedBoxState extends ConsumerState<MedBox> {
  bool notificationEnabled = false;
  String? devicetoken = prefs.getString('devicetoken');

  bool? tourbool;
  @override
  void initState() {
    super.initState();
    requestFirebasePermissions();
    isAndroidPermissionGranted();
    requestPermissions();
    getoken();

    RemindersDb().remindersInit();
    tourbool = SharedCli().tourbool();
  }

  void requestFirebasePermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log(' provisional permission granted');
    } else {
      log('permission denied');
    }
  }

  void getoken() async {
    try {
      if (devicetoken == null) {
        await FirebaseMessaging.instance.getToken().then((value) {
          setState(() {
            prefs.setString('devicetoken', value!);
            log('device token:$value');
          });
          TokenSave.savetoken(token: value!);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> isAndroidPermissionGranted() async {
    try {
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.areNotificationsEnabled() ??
            false;

        setState(() {
          notificationEnabled = true;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> requestPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      setState(() {
        notificationEnabled = granted ?? false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Med Box',
      locale: ref.watch(languageProvider).locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: mythemedata,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, user) {
            if (user.hasData) {
              return tourbool == true ? const MyRender() : const Apptour();
            }
            return const AuthPage();
          })),
    );
  }
}

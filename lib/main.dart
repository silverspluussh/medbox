// ignore_for_file: depend_on_referenced_packages
import 'package:MedBox/constants/theme.dart';
import 'package:MedBox/version2/sqflite/reminderlocal.dart';
import 'package:MedBox/version2/utilites/randomgen.dart';
import 'package:MedBox/version2/utilites/sharedprefs.dart';
import 'package:MedBox/l10n/langprovider.dart';
import 'package:MedBox/l10n/l10n.dart';
import 'package:MedBox/version2/UI/authpage.dart';
import 'package:MedBox/version2/UI/render.dart';
import 'package:MedBox/version2/UI/tour.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();

  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      webRecaptchaSiteKey: 'AIzaSyC1ZR4jPKRohSDf633c78Yzj7WWj4u7g-I');
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('mddlogo');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await FirebaseMessaging.instance.getInitialMessage();
  await firemessage();
  await configureLocalTimeZone();

  runApp(const ProviderScope(child: MedBox()));
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final timezone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezone));
}

firemessage() async {
  FirebaseMessaging.onMessage.listen((event) async {
    BigTextStyleInformation bigtext = BigTextStyleInformation(
        event.notification!.body.toString(),
        htmlFormatBigText: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'f${idg()}',
      'ch${idg()}',
      importance: Importance.max,
      icon: 'mddlogo',
      styleInformation: bigtext,
      priority: Priority.high,
      playSound: true,
    );

    NotificationDetails channelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(0, event.notification?.title,
        event.notification?.body, channelSpecifics,
        payload: event.data['title']);
  });
}

class MedBox extends ConsumerStatefulWidget {
  const MedBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MedBoxState();
}

class _MedBoxState extends ConsumerState<MedBox> {
  bool? tourbool;
  @override
  void initState() {
    super.initState();
    RemindersDb().remindersInit();
    tourbool = SharedCli().tourbool();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedBox',
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

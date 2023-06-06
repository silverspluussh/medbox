// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'dart:io';
import 'package:MedBox/constants/theme.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:MedBox/presentation/pages/onboarding.dart';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:MedBox/presentation/providers/vitalsprovider.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'presentation/pages/renderer.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late SharedPreferences prefs;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  await NotifConsole().initnotifs();
  await FirebaseMessaging.instance.getInitialMessage();

  prefs = await SharedPreferences.getInstance();

  await _configureLocalTimeZone();
  runApp(const MedBox());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final timezone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezone));
}

class MedBox extends StatefulWidget {
  const MedBox({super.key});

  @override
  State<MedBox> createState() => _MedBoxState();
}

class _MedBoxState extends State<MedBox> {
  bool notificationEnabled = false;
  String? devicetoken = prefs.getString('devicetoken');

  @override
  void initState() {
    super.initState();
    requestFirebasePermissions();
    isAndroidPermissionGranted();
    requestPermissions();
    getoken();
  }

  void getoken() async {
    if (devicetoken == null) {
      await FirebaseMessaging.instance.getToken().then((value) {
        setState(() {
          prefs.setString('devicetoken', value!);
          log(value);
        });
        savedtoken(value!);
      });
    }
    return null;
  }

  void savedtoken(String token) async {
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(SharedCli().getuserID()!)
        .collection('usertokens')
        .doc(SharedCli().getuserID()!)
        .set({'token': token});
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

  Future<void> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        notificationEnabled = granted;
      });
    }
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestPermission();
    setState(() {
      notificationEnabled = granted ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => VitalsProvider(Vv.pressure)),
          StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(),
            initialData: FirebaseAuth.instance.currentUser,
          ),
        ],
        builder: (context, child) {
          return MaterialApp(
            title: 'Med Box',
            debugShowCheckedModeBanner: false,
            theme: mythemedata,
            home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: ((context, user) {
                  if (user.hasData) {
                    return const Render();
                  }
                  return const GoogleOnbarding();
                })),
          );
        });
  }
}

import 'dart:io';

import 'package:MedBox/artifacts/Dbhelpers/remindDb.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:MedBox/artifacts/Dbhelpers/medicationdb.dart';
import 'package:MedBox/artifacts/Dbhelpers/profiledb.dart';
import 'package:MedBox/artifacts/Dbhelpers/vitalsdb.dart';
import 'package:MedBox/components/dashboard/vitalsprovider.dart';
import 'package:MedBox/components/landing/navigate.dart';
import 'package:MedBox/components/notifications/notification.dart';
import 'package:MedBox/components/patient/medications/medicalstate.dart';
import 'package:MedBox/components/start/intro.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/landing/landingpage.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late SharedPreferences prefs;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();

  await VitalsDB.initDatabase();
  await MedicationsDB.initDatabase();
  await ProfileDB.initDatabase();
  await ReminderDB.initDatabase();
  await _configureLocalTimeZone();
  await NotifConsole().initnotifs();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MedBox());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  DateTime dateTime = DateTime.now();
  tz.setLocalLocation(tz.getLocation(dateTime.timeZoneName));
}

class MedBox extends StatefulWidget {
  const MedBox({super.key});

  @override
  State<MedBox> createState() => _MedBoxState();
}

class _MedBoxState extends State<MedBox> {
  User? user;
  bool notificationEnabled = false;

  @override
  void initState() {
    super.initState();
    isAndroidPermissionGranted();
    requestPermissions();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserStatus(event));
  }

  updateUserStatus(event) {
    setState(() {
      user = event;
    });
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

  //
  //
  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestPermission();
    setState(() {
      notificationEnabled = granted ?? false;
    });
  }
//

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => MedicationState(
                drugtype: Drugtype.bottle, image: 'image', title: 'title')),
        ChangeNotifierProvider(
            create: (context) =>
                BottomNav(icon: 'icon', navEnum: NavEnum.home, title: '')),
        ChangeNotifierProvider(
            create: (context) => VitalsProvider(Vv.pressure)),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: 'MedBox',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 16, 27, 56),
          brightness: Brightness.light,
        ),
        home: user == null ? const Introduction() : const Render(),
      ),
    );
  }
}

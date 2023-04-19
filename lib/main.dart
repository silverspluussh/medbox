// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/data/repos/Dbhelpers/remindDb.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:MedBox/data/repos/Dbhelpers/medicationdb.dart';
import 'package:MedBox/data/repos/Dbhelpers/profiledb.dart';
import 'package:MedBox/data/repos/Dbhelpers/vitalsdb.dart';
import 'package:MedBox/presentation/providers/vitalsprovider.dart';
import 'package:MedBox/presentation/providers/navigation.dart';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:MedBox/presentation/providers/medications_provider.dart';
import 'package:MedBox/presentation/pages/intro_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'presentation/providers/localization_state.dart';
import 'presentation/pages/renderer.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'translation/l10n/l10n.dart';

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
  //
  //

  runApp(const MedBox());

  //
  //
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
  late BuildContext ctx;
  @override
  void initState() {
    super.initState();
    isAndroidPermissionGranted();
    requestPermissions();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserStatus(event));

    Future.delayed(
        24.hours,
        () => VxToast.show(
              ctx,
              msg:
                  'It\'s been 24 hours already, please update your vitals to keep Medbox updated with your latest health information',
              position: VxToastPosition.center,
              bgColor: AppColors.primaryColor,
            ));
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
          ChangeNotifierProvider(create: (context) => LanguageProvider()),
          ChangeNotifierProvider(
              create: (context) => VitalsProvider(Vv.pressure)),
          StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(),
            initialData: FirebaseAuth.instance.currentUser,
          ),
        ],
        builder: (context, child) {
          final langprovider = Provider.of<LanguageProvider>(context);

          return MaterialApp(
            title: 'Med Box',
            debugShowCheckedModeBanner: false,
            locale: langprovider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: const Color.fromARGB(255, 16, 27, 56),
              brightness: Brightness.light,
            ),
            home: user == null ? const Introduction() : const Render(),
          );
        });
  }
}

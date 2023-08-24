import 'dart:developer';
import 'dart:io';

import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/home.dart';
import 'package:MedBox/version2/UI/meds/medication.dart';
import 'package:MedBox/version2/UI/menu.dart';
import 'package:MedBox/version2/UI/pharmacies.dart';
import 'package:MedBox/version2/UI/profile/profile.dart';
import 'package:MedBox/version2/UI/reminders.dart';
import 'package:MedBox/version2/UI/rtest/rapidtest.dart';
import 'package:MedBox/version2/UI/vitals/vitals.dart';
import 'package:MedBox/version2/providers.dart/navprovider.dart';
import 'package:MedBox/version2/utilites/navigation.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../l10n/l10n.dart';
import '../../l10n/langprovider.dart';
import '../../main.dart';
import '../firebase/tokenfire.dart';
import '../providers.dart/authprovider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyRender extends ConsumerStatefulWidget {
  const MyRender({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRenderState();
}

class _MyRenderState extends ConsumerState<MyRender> {
  List<Widget>? pages;
  bool notificationEnabled = false;
  String? devicetoken = prefs.getString('devicetoken');

  void onItemTapped(int index) {
    ref.watch(navIndexProvider.notifier).state = index;
  }

  @override
  void initState() {
    super.initState();
    requestFirebasePermissions();
    isAndroidPermissionGranted();
    requestPermissions();
    getoken();
    pages = [
      const Home(),
      const MyVitals(),
      const Rapidtest(),
      const Medications(),
      const Menu()
    ];
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
    if (devicetoken == null) {
      await FirebaseMessaging.instance.getToken().then((value) {
        setState(() {
          prefs.setString('devicetoken', value!);
          log('device token:$value');
        });
        TokenSave.savetoken(token: value!);
      });
    }
    return null;
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

  Container imageContainer(ImageProvider<Object> imageProvider) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }

  Dialog _dialogue(Size size, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.green,
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.75,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.outconf,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.sure,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              width: size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      context.pop();
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                      style: const TextStyle(
                          color: Colors.red, fontSize: 13, fontFamily: 'Pop'),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.no,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 13, fontFamily: 'Pop'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    int index = ref.watch(navIndexProvider);
    final locale = ref.read(languageProvider).locale ?? const Locale('en');
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: kprimary),
              accountName: Text(user!.displayName!),
              accountEmail: Text(user.email!),
              currentAccountPicture: CachedNetworkImage(
                imageUrl: user.photoURL!,
                errorWidget: (context, url, error) =>
                    imageContainer(const AssetImage('assets/icons/Home.png')),
                imageBuilder: (context, imageProvider) =>
                    imageContainer(imageProvider),
                placeholder: (context, url) =>
                    imageContainer(const AssetImage('assets/icons/Home.png')),
                cacheManager:
                    CacheManager(Config('pfpcache', stalePeriod: 5.days)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Profile()));
              },
              leading: const Icon(Icons.person, color: kprimary),
              title: Ltxt(text: AppLocalizations.of(context)!.mprof).centered(),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Reminders()));
              },
              leading: const ImageIcon(
                  AssetImage('assets/icons/reminders-15-64.png'),
                  color: kprimary),
              title: Ltxt(text: AppLocalizations.of(context)!.mrem).centered(),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Pharmacy()));
              },
              leading: const Icon(Icons.local_pharmacy, color: kprimary),
              title: Ltxt(text: AppLocalizations.of(context)!.pharm).centered(),
            ),
            const Spacer(),
            ListTile(
              onTap: () => showDialog(
                  context: context, builder: (_) => _dialogue(size, context)),
              leading: Image.asset('assets/icons/log-out-54-512.png',
                  width: 30, height: 30, color: kred),
              title: Ltxt(text: AppLocalizations.of(context)!.lout).centered(),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: 500.milliseconds,
                showCloseIcon: true,
                backgroundColor: Colors.green[300],
                content: SizedBox(
                  height: 50,
                  width: 200,
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red[300]!)),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Ltxt(text: AppLocalizations.of(context)!.ext)),
                ).px12(),
              )),
              leading: Image.asset('assets/icons/sign-out-243-512.png',
                  width: 30, height: 30, color: kred),
              title: Ltxt(text: AppLocalizations.of(context)!.ext).centered(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Ltxt(
            text: index == 0
                ? 'Home'
                : index == 1
                    ? AppLocalizations.of(context)!.bvitals
                    : index == 2
                        ? AppLocalizations.of(context)!.itest
                        : index == 3
                            ? 'Medications'
                            : AppLocalizations.of(context)!.menu),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Profile())),
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          ),
          const SizedBox(width: 20),
          DropdownButtonHideUnderline(
              child: DropdownButton(
            value: locale,
            icon: Container(width: 25),
            items: L10n.all.map((e) {
              var langflag = L10n.getflag(e.languageCode);
              return DropdownMenuItem(
                value: e,
                child: Center(
                  child: Text(
                    langflag,
                    style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                  ),
                ),
                onTap: () {
                  ref.watch(languageProvider).setlocalizations(e);
                },
              );
            }).toList(),
            onChanged: (_) {},
          )),
        ],
      ),
      body: SafeArea(
          child: IndexedStack(
              index: ref.watch(navIndexProvider), children: pages!)),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: kwhite,
          type: BottomNavigationBarType.shifting,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: kblack,
          selectedIconTheme: const IconThemeData(size: 23),
          unselectedIconTheme: const IconThemeData(size: 20),
          backgroundColor: kprimary,
          currentIndex: ref.watch(navIndexProvider),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: onItemTapped,
          items: [
            ...navitems.map((e) => BottomNavigationBarItem(
                backgroundColor: kprimary,
                icon: ImageIcon(AssetImage(e.icon!)),
                label: e.title))
          ]),
    );
  }
}

import 'dart:io';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/main.dart';
import 'package:MedBox/version2/UI/tests/medtest.dart';
import 'package:MedBox/version2/UI/home.dart';
import 'package:MedBox/version2/UI/meds/medication.dart';
import 'package:MedBox/version2/providers.dart/navprovider.dart';
import 'package:MedBox/version2/wiis/custom_appbar.dart';
import 'package:MedBox/version2/wiis/mydrawer.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import '../firebase/tokenfire.dart';
import '../utilites/navigation.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Myrender extends ConsumerStatefulWidget {
  const Myrender({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyrenderState();
}

class _MyrenderState extends ConsumerState<Myrender> {
  List<Widget>? pages;
  bool notificationEnabled = false;
  String? devicetoken = prefs.getString('devicetoken');

  void onItemTapped(int index) {
    ref.watch(navIndexProvider.notifier).state = index;
  }

  bool showAppbar = true; //this is to show app bar
  ScrollController scrollBottomBarController =
      ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool show = true;
  double bottomBarHeight = 70; // set bottom bar height
  double bottomBarOffset = 0;

  void getoken() async {
    if (devicetoken == null) {
      await FirebaseMessaging.instance.getToken().then((value) async {
        setState(() {
          prefs.setString('devicetoken', value!);
        });
        await TokenSave.savetoken(token: value!);
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
    } catch (e) {}
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
    } catch (e) {}
  }

  void requestFirebasePermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
  }

  void showBottomBar() {
    setState(() {
      show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      show = false;
    });
  }

  void myScroll() async {
    scrollBottomBarController.addListener(() {
      if (scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          showAppbar = false;
          hideBottomBar();
        }
      }
      if (scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showAppbar = true;
          showBottomBar();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myScroll();
    requestFirebasePermissions();
    isAndroidPermissionGranted();
    requestPermissions();
    getoken();
    pages = [
      Homex(scrollBottomBarController),
      const Medicate(),
      const Medicaltests()
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      drawer: const Mydrawer(),
      body: IndexedStack(index: ref.watch(navIndexProvider), children: pages!),
      bottomNavigationBar: SizedBox(
        height: bottomBarHeight,
        width: size.width,
        child: show
            ? BottomNavigationBar(
                elevation: 0,
                selectedItemColor: kblack,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                currentIndex: ref.watch(navIndexProvider),
                selectedFontSize: 12,
                backgroundColor: kwhite,
                unselectedFontSize: 12,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w700),
                onTap: onItemTapped,
                items: [
                    ...navitems.map((e) => BottomNavigationBarItem(
                        backgroundColor: kwhite,
                        icon: Image.asset(e.icon!, height: 23, width: 40).py4(),
                        label: e.title))
                  ]).animate().slideY(end: 0, begin: 1, duration: 200.ms)
            : const SizedBox(width: 0, height: 0),
      ),
    );
  }
}

class Scroolpage extends ConsumerWidget {
  const Scroolpage(this.controller, {super.key});
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        const CustomAppbar(),
        SliverList.builder(
          itemBuilder: ((context, index) => ListTile(
                title: Ttxt(text: index.toString()),
              )),
          itemCount: 10,
        ),
        SliverList.builder(
          itemBuilder: ((context, index) => const ListTile(
                title: Ttxt(text: "index.toString()"),
              )),
          itemCount: 10,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class BottomNav with ChangeNotifier {
  String icon;
  String title;
  NavEnum navEnum;
  BottomNav({required this.icon, required this.navEnum, required this.title});

  updatenav(BottomNav bottomNav) {
    navEnum = bottomNav.navEnum;
    icon = bottomNav.icon;
    notifyListeners();
  }
}

enum NavEnum { home, medications, vitals, profile, settings }

List<BottomNav> navitems = [
  BottomNav(
      icon: 'assets/icons/homepage-221-512.png',
      navEnum: NavEnum.home,
      title: 'Home'),
  BottomNav(
      icon: 'assets/icons/heart-beat.png',
      navEnum: NavEnum.vitals,
      title: 'Vitals'),
  BottomNav(
      icon: 'assets/icons/capsules.png',
      navEnum: NavEnum.medications,
      title: 'Meds'),
  BottomNav(
      icon: 'assets/icons/profile-35-64.png',
      navEnum: NavEnum.profile,
      title: 'Profile'),
  BottomNav(
      icon: 'assets/icons/set-up-950-512.png',
      navEnum: NavEnum.settings,
      title: 'Setup'),
];

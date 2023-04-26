import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/pages/myprofile/rapidtest.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'myvitals.dart';
import 'personalinfo.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: const TabBarView(
          children: [
            PersonalProfile(),
            MyVitals(),
            RapidTests(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
        scrolledUnderElevation: 5,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(45.0),
            child: Card(
                elevation: 5,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: TabBar(tabs: [
                  ...tabs.map((e) => Text(
                        e,
                        style:
                            const TextStyle(fontSize: 12, fontFamily: 'Popb'),
                      ))
                ]).py12())),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))));
  }
}

List tabs = ['Personal', 'Vitals', 'Rapid tests'];

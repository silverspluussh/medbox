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
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(68.0),
            child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: TabBar(tabs: [
                  ...tabs.map((e) => Text(
                        e,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Popb'),
                      ))
                ]).px8().py12())),
        actions: [
          VxBadge(
              size: 10,
              color: Colors.green,
              position: VxBadgePosition.leftTop,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    size: 30,
                    color: AppColors.primaryColor.withOpacity(0.5),
                  ))).p16()
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))));
  }
}

List tabs = ['Personal Info', 'Vitals', 'Rapid tests'];

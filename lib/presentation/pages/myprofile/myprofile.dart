import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/pages/myprofile/rapidtest.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'myvitals.dart';
import 'personalinfo.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  List tabs = ['Personal', 'Vitals', 'Rapid tests'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(55),
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
        ),
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
}

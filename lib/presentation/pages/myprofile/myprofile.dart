import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/presentation/pages/rapidtests/rapidtest.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../bodyvitals/vitalsdashboard.dart';
import 'personalinfo.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tabs = ['Personal', 'Vitals', 'Rapid tests'];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: TabBar(
                          tabs: [...tabs.map((e) => Text(e, style: popblack))])
                      .py12())),
        ),
        body: const TabBarView(
          children: [
            PersonalProfile(),
            VitalsDashboard(),
            RapidTests(),
          ],
        ),
      ),
    );
  }
}

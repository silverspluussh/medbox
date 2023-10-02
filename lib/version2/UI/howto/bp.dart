import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

class Bp extends StatelessWidget {
  const Bp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              floating: true,
              toolbarHeight: 40,
              title: Ltxt(text: 'How to measure blood pressure'.capitalized),
              centerTitle: true),
          SliverList(
              delegate: SliverChildListDelegate([
            40.heightBox,
            Card(
              color: kprimary.withOpacity(0.1),
              elevation: 5,
              child: const Btxt(
                      text:
                          "Measuring your blood pressure at home is an essential aspect of monitoring your cardiovascular health. Here's a step-by-step procedure for taking your blood pressure at home using a digital blood pressure monitor:")
                  .p16(),
            ).px16(),
            10.heightBox,
            const Ltxt(text: 'Materials needed:').px16(),
            10.heightBox,
            const Btxt(
                    text:
                        "Digital blood pressure monitor (also known as a sphygmomanometer)\nAppropriate-sized blood pressure cuff\nA quiet and comfortable place to sit")
                .px16(),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Prepare the Blood Pressure Monitor"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Check the manufacturer's instructions for your specific blood pressure monitor to ensure proper setup and usage.\nEnsure the monitor is charged or has fresh batteries if required.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Prepare Your Arm"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Roll up your sleeve to expose your upper arm.\nPlace the blood pressure cuff on your bare upper arm, approximately one inch above your elbow joint. The cuff should be snug but not too tight.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Position Yourself"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Sit up straight with your arm resting on a table or your lap so that it is at heart level.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Rest for a Few Minutes"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Sit quietly for a few minutes before taking your blood pressure. This helps to relax and stabilize your blood pressure.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Take the Measurement"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Press the start button on the blood pressure monitor to begin the measurement.\nThe cuff will inflate automatically. You will feel mild pressure on your arm.\nThe monitor will then slowly release the pressure and start measuring your blood pressure.\nRemain still, do not talk, and keep your arm relaxed during the measurement.\nThe monitor will display your systolic (top number) and diastolic (bottom number) blood pressure readings once the measurement is complete.")
                ]),
            10.heightBox,
          ]))
        ],
      ),
    ).animate().slideX();
  }
}

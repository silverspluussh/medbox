import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';

class Hr extends StatelessWidget {
  const Hr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              floating: true,
              toolbarHeight: 40,
              title: Ltxt(text: 'How to Measure Heart Rate'.capitalized),
              centerTitle: true),
          SliverList(
              delegate: SliverChildListDelegate([
            40.heightBox,
            Card(
              color: kprimary.withOpacity(0.1),
              elevation: 5,
              child: const Btxt(
                      text:
                          "Measuring your heart rate (pulse) is a straightforward way to assess your heart's activity. Here's a step-by-step procedure for measuring your heart rate at home:")
                  .p16(),
            ).px16(),
            10.heightBox,
            const Ltxt(text: 'Procedure:').px16(),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Find a Quiet and Comfortable Place"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Sit down in a quiet and relaxed environment, or lie down if you prefer. Ensure you are comfortable and not feeling anxious, as this can affect your heart rate.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Locate Your Pulse"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "You can find your pulse at various locations, but the most common and easily accessible are on your wrist (radial pulse) and on the side of your neck (carotid pulse).\nTo find your radial pulse, place the tips of your index and middle fingers on the inside of your wrist, just below the base of your thumb.\nTo find your carotid pulse, place your index and middle fingers on the side of your neck, just below your jawline.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Use a Timer"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "You can use a watch, clock with a second hand, or a timer on your phone to measure the time.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Start Counting"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Begin counting the number of heartbeats (pulses) you feel in one minute. Alternatively, you can count the beats for 15 seconds and then multiply by 4 to get the beats per minute (bpm) measurement.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Record Your Heart Rate"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "After one minute (or after counting for 15 seconds and multiplying by 4), note the number of heartbeats you counted. This is your heart rate in beats per minute (bpm).")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Repeat for Accuracy"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "For a more accurate measurement, you can repeat the process two more times and calculate the average heart rate from the three measurements.")
                ]),
            10.heightBox,
          ]))
        ],
      ),
    ).animate().slideX();
  }
}

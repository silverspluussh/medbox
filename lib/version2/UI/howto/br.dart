import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';

class Br extends StatelessWidget {
  const Br({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              floating: true,
              toolbarHeight: 40,
              title: Ltxt(text: 'How to Measure Breathe Rate'.capitalized),
              centerTitle: true),
          SliverList(
              delegate: SliverChildListDelegate([
            40.heightBox,
            Card(
              color: kprimary.withOpacity(0.1),
              elevation: 5,
              child: const Btxt(
                      text:
                          "Measuring your respiratory (breathing) rate is a simple way to assess your breathing pattern. Here's a step-by-step procedure for measuring your breathing rate at home:")
                  .p16(),
            ).px16(),
            10.heightBox,
            const Ltxt(text: 'Procedure:').px16(),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Find a Comfortable Position"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Sit down in a quiet and relaxed environment, or lie down if you prefer. Make sure you're comfortable and not feeling anxious, as this can affect your breathing rate.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Set a timer"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "You can use a watch or a clock with a second hand, or you can use a timer on your phone. Alternatively, you can use a stopwatch app.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Start Breathing normally"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(text: "Begin by taking a few normal breaths to relax.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Count Your Breaths"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Start the timer and count the number of breaths you take in one minute. Each inhale and exhale counts as one breath.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Record Your Breathing Rate"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "After one minute, stop the timer and note the number of breaths you counted. This is your respiratory rate, typically measured in breaths per minute (bpm)..")
                ]),
            10.heightBox,
          ]))
        ],
      ),
    ).animate().slideX();
  }
}

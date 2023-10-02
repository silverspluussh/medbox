import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';

class Bmi extends StatelessWidget {
  const Bmi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              floating: true,
              toolbarHeight: 40,
              title: Ltxt(text: 'How to calculate Body Mass Index'.capitalized),
              centerTitle: true),
          SliverList(
              delegate: SliverChildListDelegate([
            40.heightBox,
            Card(
              color: kprimary.withOpacity(0.1),
              elevation: 5,
              child: const Btxt(
                      text:
                          "Calculating your Body Mass Index (BMI) is a simple way to estimate your body fat based on your weight and height. Here's a step-by-step procedure for calculating your BMI:")
                  .p16(),
            ).px16(),
            10.heightBox,
            const Ltxt(text: 'Materials needed:').px16(),
            10.heightBox,
            const Btxt(
                    text:
                        "Your weight in kilograms (kg).\nYour height in meters (m) or centimeters (cm).")
                .px16(),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Measure Your Weight"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Use a bathroom scale to measure your weight in kilograms (kg). If the scale measures in pounds (lb), you can convert it to kilograms by dividing your weight in pounds by 2.205 (1 kg = 2.205 lb).")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Measure Your height"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Measure your height in meters (m) or centimeters (cm). If your height is in feet and inches, you can convert it to meters by multiplying the number of feet by 0.3048 and adding the remaining inches converted to meters by dividing by 39.37 (1 meter = 39.37 inches).")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Calculate BMI"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Use the following formula to calculate your BMI:\nBMI = weight (kg) / (height (m))^2\nSquare your height in meters by multiplying it by itself (height (m) x height (m)).")
                ]),
            10.heightBox,
          ]))
        ],
      ),
    ).animate().slideX();
  }
}

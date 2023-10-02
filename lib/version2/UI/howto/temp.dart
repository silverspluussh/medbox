import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              floating: true,
              toolbarHeight: 40,
              title:
                  Ltxt(text: 'How to calculate Body Temperature'.capitalized),
              centerTitle: true),
          SliverList(
              delegate: SliverChildListDelegate([
            40.heightBox,
            Card(
              color: kprimary.withOpacity(0.1),
              elevation: 5,
              child: const Btxt(
                      text:
                          "Taking your body temperature at home with a thermometer is a straightforward process. Here's a step-by-step procedure:")
                  .p16(),
            ).px16(),
            10.heightBox,
            const Ltxt(text: 'Materials needed:').px16(),
            10.heightBox,
            const Btxt(
                    text:
                        "1. Digital thermometer (oral, ear, or forehead thermometer).\n2. Alcohol swabs or rubbing alcohol.\n3.Tissue or cotton ball.\n4. Timer or watch (optional)")
                .px16(),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Prepare the Thermometer:"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "If you're using a digital thermometer for the first time or if it hasn't been used recently, clean the tip with a tissue or cotton ball moistened with alcohol. This helps ensure accuracy and hygiene.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Wash Your Hands"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Thoroughly wash your hands with soap and water for at least 20 seconds. This is important to prevent the thermometer from being contaminated.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Choose the Measurement Site"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          "Decide where you'll measure your temperature. Common sites are the mouth (oral), ear (tympanic), or forehead. Different thermometers have specific instructions for each site.")
                ]),
            10.heightBox,
            const ExpansionTile(
                title: Btxt(text: "Oral Measurement"),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Btxt(
                      text:
                          '''Place the thermometer probe tip under your tongue.
Close your mouth, ensuring the thermometer is held in place by your lips.
Keep your mouth closed and breathe through your nose.
Wait until the thermometer signals it's done (usually with a beep or display).
Note the temperature reading.''')
                ]),
            10.heightBox,
          ]))
        ],
      ),
    ).animate().slideX();
  }
}

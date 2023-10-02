import 'package:MedBox/constants/pdata.dart';
import 'package:MedBox/version2/UI/pharmacies.dart';
import 'package:MedBox/version2/UI/tests/mtest.dart';
import 'package:MedBox/version2/UI/tests/records.dart';
import 'package:MedBox/version2/wiis/custom_appbar.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

class Medicaltests extends ConsumerWidget {
  const Medicaltests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        const CustomAppbar(),
        20.heightBox.sliverToBoxAdapter(),
        SliverGrid.count(
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 1.88,
          children: [
            GestureDetector(
              onTap: () => context.nextPage(const Mrecords()),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.red[200]),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: VStack(
                  [
                    Image.asset(
                        "assets/icons/medical-examination-report-48.png",
                        height: 40,
                        width: 40),
                    8.heightBox,
                    const Itxt(text: "Medical Records")
                  ],
                  crossAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.nextPage(const Mtests()),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue[200]),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: VStack(
                  [
                    Image.asset("assets/icons/blood-analysis.png",
                        height: 40, width: 40),
                    8.heightBox,
                    const Itxt(text: "Medical Tests")
                  ],
                  crossAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.teal[200]),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: VStack(
                  [
                    Image.asset("assets/icons/prescription-5-64.png",
                        height: 40, width: 40),
                    8.heightBox,
                    const Itxt(text: "Prescriptions")
                  ],
                  crossAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.nextPage(const Pharmacy()),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.indigo[200]),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: VStack(
                  [
                    Image.asset("assets/icons/first-aid-kit.png",
                        height: 40, width: 40),
                    8.heightBox,
                    const Itxt(text: "View Pharmcies")
                  ],
                  crossAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
          ],
        ),
        50.heightBox.sliverToBoxAdapter(),
        SliverList(
            delegate: SliverChildListDelegate([
          const Ltxt(text: "How does medical tests work 🪄:").px12(),
          Card(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green[50],
                backgroundImage:
                    const AssetImage("assets/icons/blood-test.png"),
              ).centered(),
              5.heightBox,
              const Btxt(text: medtests),
              10.heightBox,
              const Ltxt(
                  text:
                      "These are the various Rapid Tests available on Med Box:"),
              10.heightBox,
              ...rtest.map((e) => HStack(
                  alignment: MainAxisAlignment.start,
                  [const Ltxt(text: "⚛"), 5.widthBox, Ltxt(text: e)]).py12())
            ],
          ).p12())
              .px12(),
          20.heightBox,
          const Ltxt(text: "How does medical records work 🪄:").px12(),
          Card(
                  color: Colors.yellow[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.yellow[50],
                        backgroundImage: const AssetImage(
                            "assets/icons/medical-appointment.png"),
                      ).centered(),
                      5.heightBox,
                      const Btxt(text: rcords),
                      10.heightBox,
                      const Ltxt(text: "Medical records available on Med Box:"),
                      10.heightBox,
                      ...[
                        "X-ray Records",
                        "General Examination Records",
                        "General Blood Analysis",
                        "Neurograms",
                        "Kidney Chart"
                      ].map((e) => HStack(alignment: MainAxisAlignment.start, [
                            const Ltxt(text: "⚛"),
                            5.widthBox,
                            Ltxt(text: e)
                          ]).py12())
                    ],
                  ).p12())
              .px12(),
          100.heightBox,
        ])),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

const rcords =
    'Gain effortless access to your complete medical records through our "Effortless Medical Records Access" feature. Whether you prefer receiving updates via SMS or accessing them directly within your Medbox app, managing your health information has never been this convenient. Stay connected with your health center and keep your medical history at your fingertips for a healthier, more informed you.';

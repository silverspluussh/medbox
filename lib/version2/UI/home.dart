import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/howto/bmi.dart';
import 'package:MedBox/version2/UI/howto/bp.dart';
import 'package:MedBox/version2/UI/howto/br.dart';
import 'package:MedBox/version2/UI/howto/hr.dart';
import 'package:MedBox/version2/UI/howto/temp.dart';
import 'package:MedBox/version2/firebase/vitalsfirebase.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:MedBox/version2/providers.dart/emoticon.dart';
import 'package:MedBox/version2/wiis/custom_appbar.dart';
import 'package:MedBox/version2/wiis/shimmer.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../models/emotions.dart';
import '../wiis/vitalscard.dart';
import 'vitals/addvitals.dart';

void modelPop(context) {
  showModalBottomSheet(
      barrierColor: kprimary.withOpacity(0.3),
      context: context,
      builder: ((BuildContext context) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: 120,
          child: Center(
            child: Consumer(
              builder: (context, WidgetRef ref, child) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: HStack(crossAlignment: CrossAxisAlignment.center, [
                    ...emoticons.map((e) => Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  ref.read(emojiProvider.notifier).state =
                                      e.image;
                                  context.pop();
                                },
                                child: Image.asset(e.image)),
                            Btxt(text: e.emojiname)
                          ],
                        ).px8())
                  ]).px4()),
            ),
          ))));
}

class Homex extends ConsumerStatefulWidget {
  const Homex(this.controller, {super.key});
  final ScrollController controller;

  @override
  ConsumerState<Homex> createState() => _HomexState();
}

class _HomexState extends ConsumerState<Homex> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final vital = ref.watch(vitalsStreamProvider);
    Size size = MediaQuery.sizeOf(context);

    return CustomScrollView(
      controller: widget.controller,
      slivers: [
        const CustomAppbar(),
        SliverList(
            delegate: SliverChildListDelegate([
          40.heightBox,
          HStack([
            Text(
              AppLocalizations.of(context)!.hi,
              style: const TextStyle(
                  fontSize: 17, color: kprimary, fontWeight: FontWeight.bold),
            ),
            const Text(
              ',',
              style: TextStyle(
                  fontSize: 17, color: kprimary, fontWeight: FontWeight.bold),
            ),
            15.widthBox,
            Text(
              user!.displayName ?? "",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ]).px16(),
          10.heightBox,
          const Btxt(text: "We'd like to know how you feel...").px16(),
          10.heightBox,
          HStack([
            Image.asset(ref.watch(emojiProvider), width: 60, height: 60),
            10.widthBox,
            InkWell(
              onTap: () => modelPop(context),
              child: Text(
                AppLocalizations.of(context)!.mood,
                style: const TextStyle(
                    fontFamily: 'Go',
                    color: kprimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            )
          ]).px16()
        ])),
        vital.when(
            data: (v) => v.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          VStack([
                            VCard(
                              color: kgreen,
                              label: AppLocalizations.of(context)!.temp,
                              unit: ' °C',
                              value: v.first.temp ?? '0',
                            ),
                            VCard(
                                color: Colors.purple,
                                label: AppLocalizations.of(context)!.bp,
                                unit: ' mmhg',
                                value: v.first.bp ?? '0'),
                          ]),
                          const Spacer(),
                          VCardL(hr: v.first.hr ?? "0")
                        ],
                      ).px4().scale95(),
                      HStack([
                        VCard(
                            color: Colors.yellow,
                            label: AppLocalizations.of(context)!.br,
                            unit: ' bpm',
                            value: v.first.br ?? '0'),
                        const Spacer(),
                        VCard(
                            color: Colors.pink,
                            label: 'BMI',
                            unit: '',
                            value: v.first.bmi ?? '0'),
                      ]).px8().scale95(),
                    ],
                  ).sliverToBoxAdapter()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          VStack([
                            VCard(
                              color: kgreen,
                              label: AppLocalizations.of(context)!.temp,
                              unit: ' °C',
                              value: '0',
                            ),
                            VCard(
                                color: Colors.purple,
                                label: AppLocalizations.of(context)!.bp,
                                unit: ' mmhg',
                                value: '0'),
                          ]),
                          const Spacer(),
                          const VCardL(hr: "0")
                        ],
                      ).px4().scale95(),
                      HStack([
                        VCard(
                            color: Colors.yellow,
                            label: AppLocalizations.of(context)!.br,
                            unit: ' bpm',
                            value: '0'),
                        const Spacer(),
                        const VCard(
                            color: Colors.pink,
                            label: 'BMI',
                            unit: '',
                            value: '0'),
                      ]).px8().scale95(),
                    ],
                  ).sliverToBoxAdapter(),
            error: (error, st) =>
                Center(child: Text(error.toString())).sliverToBoxAdapter(),
            loading: () => SliverList(
                    delegate: SliverChildListDelegate([
                  HStack(
                    [
                      ShimmerWidget.rectangular(
                          height: 90, width: size.width * 0.43),
                      10.widthBox,
                      ShimmerWidget.rectangular(
                          height: 90, width: size.width * 0.43),
                    ],
                    alignment: MainAxisAlignment.center,
                  ),
                  10.heightBox,
                  SizedBox(
                    width: size.width,
                    child: HStack(
                      [
                        ShimmerWidget.rectangular(
                            height: 90, width: size.width * 0.43),
                        15.widthBox,
                        ShimmerWidget.rectangular(
                            height: 90, width: size.width * 0.43),
                      ],
                      alignment: MainAxisAlignment.center,
                    ),
                  ),
                  15.heightBox,
                  SizedBox(
                    width: size.width,
                    child: HStack(
                      [
                        ShimmerWidget.rectangular(
                            height: 90, width: size.width * 0.43),
                        10.widthBox,
                        ShimmerWidget.rectangular(
                            height: 90, width: size.width * 0.43),
                      ],
                      alignment: MainAxisAlignment.center,
                    ),
                  ),
                  15.heightBox,
                ]))),
        SliverToBoxAdapter(
          child: ElevatedButton(
            onPressed: () {
              context.nextPage(const AddVitals());
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(2),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: MaterialStateProperty.all(kprimary),
                backgroundColor: MaterialStateProperty.all(kprimary)),
            child: Text(
              "Record New Vitals".toUpperCase(),
              style: const TextStyle(
                  fontSize: 14, color: kwhite, fontWeight: FontWeight.w400),
            ),
          ).py12().px16(),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const Text(
            "How to ✨:",
            style: TextStyle(
                fontSize: 14,
                color: Colors.purple,
                fontWeight: FontWeight.w600),
          ).px16(),
          10.heightBox,
          ListTile(
            onTap: () => context.nextPage(const Temp()),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            tileColor: Colors.orange.withOpacity(0.3),
            leading: Image.asset("assets/icons/temperature.png"),
            title: const Ltxt(text: 'Take body temperature properly at home.'),
          ).scale90(),
          10.heightBox,
          ListTile(
            onTap: () => context.nextPage(const Bmi()),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            tileColor: Colors.purple.withOpacity(0.3),
            leading: Image.asset("assets/icons/bmi.png"),
            title: const Ltxt(text: 'Calculate body mass index correctly.'),
          ).scale90(),
          10.heightBox,
          ListTile(
            onTap: () => context.nextPage(const Hr()),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            tileColor: Colors.green.withOpacity(0.3),
            leading: Image.asset("assets/icons/heart-attack.png"),
            title: const Ltxt(text: 'Measure heart rate at home.'),
          ).scale90(),
          10.heightBox,
          ListTile(
            onTap: () => context.nextPage(const Br()),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            tileColor: Colors.cyan.withOpacity(0.3),
            leading: Image.asset("assets/icons/lungs.png"),
            title: const Ltxt(text: 'Measure breathe rate correctly.'),
          ).scale90(),
          10.heightBox,
          ListTile(
            onTap: () => context.nextPage(const Bp()),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            tileColor: Colors.cyan.withOpacity(0.3),
            leading: Image.asset("assets/icons/blood-pressure.png"),
            title: const Ltxt(
                text: 'Measure blood pressure with an insrument properly.'),
          ).scale90(),
          10.heightBox
        ]))
      ],
    );
  }
}

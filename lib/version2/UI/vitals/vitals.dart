import 'package:MedBox/version2/UI/vitals/addvitals.dart';
import 'package:MedBox/version2/firebase/vitalsfirebase.dart';
import 'package:MedBox/version2/wiis/async_value_widget.dart';
import 'package:MedBox/version2/wiis/vitalscard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../constants/colors.dart';
import '../../wiis/shimmer.dart';
import '../../wiis/vitalschart.dart';

class MyVitals extends ConsumerStatefulWidget {
  const MyVitals({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyVitalsState();
}

class _MyVitalsState extends ConsumerState<MyVitals> {
  @override
  Widget build(BuildContext context) {
    final vital = ref.watch(vitalsStreamProvider);

    return AsyncValueWidget(
        loading: ListView.builder(
            itemCount: 8,
            itemBuilder: (con, index) =>
                const ShimmerWidget.rectangular(height: 60)),
        value: vital,
        data: (v) {
          return v.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: VitalsLineChart(vitals: v),
                    ),
                    SliverToBoxAdapter(
                      child: HStack([
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddVitals())),
                          icon: const Icon(Icons.add, color: kwhite),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kprimary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.advitals,
                            style: const TextStyle(
                                fontFamily: 'Go',
                                fontSize: 12,
                                color: kwhite,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]).px12().py12(),
                    ),
                    SliverToBoxAdapter(
                        child: Row(
                      children: [
                        VStack([
                          VCard(
                            color: kgreen,
                            label: AppLocalizations.of(context)!.temp,
                            unit: ' °C',
                            value: v.first.temp!,
                          ),
                          VCard(
                              color: Colors.purple,
                              label: AppLocalizations.of(context)!.bp,
                              unit: ' mmhg',
                              value: v.first.bp!),
                        ]),
                        const Spacer(),
                        VCardL(hr: v.first.hr!)
                      ],
                    ).px8()),
                    SliverToBoxAdapter(
                      child: HStack([
                        VCard(
                            color: Colors.yellow,
                            label: AppLocalizations.of(context)!.br,
                            unit: ' bpm',
                            value: v.first.br!),
                        const Spacer(),
                        VCard(
                            color: Colors.pink,
                            label: 'BMI',
                            unit: '',
                            value: v.first.bmi!)
                      ]).px8(),
                    )
                  ],
                )
              : CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    SliverToBoxAdapter(
                      child: HStack([
                        const SizedBox(),
                        const Spacer(),
                        TextButton.icon(
                          icon: const Icon(Icons.add, color: kwhite),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kprimary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddVitals())),
                          label: Text(
                            AppLocalizations.of(context)!.rnewvitals,
                            style: const TextStyle(
                                fontFamily: 'Go',
                                color: kwhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]).px12().py12(),
                    ),
                    SliverToBoxAdapter(
                        child: Row(
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
                        const VCardL(hr: '0')
                      ],
                    )),
                    SliverToBoxAdapter(
                      child: HStack([
                        VCard(
                            color: Colors.yellow,
                            label: AppLocalizations.of(context)!.br,
                            unit: ' bpm',
                            value: '0'),
                        const Spacer(),
                        const VCard(
                            color: Colors.pink,
                            label: 'Body Mass Index',
                            unit: '',
                            value: '0')
                      ]),
                    )
                  ],
                );
        });
  }
}

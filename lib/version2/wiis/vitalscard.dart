import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/utilites/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:velocity_x/velocity_x.dart';

class VCard extends ConsumerWidget {
  const VCard(
      {super.key,
      required this.color,
      required this.label,
      required this.unit,
      required this.value});
  final Color color;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      width: size.width * 0.45,
      height: size.height * 0.16,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: kwhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: kprimary.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 2)
          ]),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        Text(
          label,
          style: const TextStyle(
              fontFamily: 'Pop',
              color: kblack,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: color),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                  fontFamily: 'Pop',
                  color: kblack,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              unit,
              style: const TextStyle(
                  fontFamily: 'Pop',
                  color: kblack,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Spacer(),
      ]).px8(),
    );
  }
}

class VCardL extends ConsumerWidget {
  const VCardL({required this.hr, super.key});
  final String hr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      width: size.width * 0.45,
      height: size.height * 0.33,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 8, 18, 47),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: kprimary.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 2)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.hr,
            style: const TextStyle(
                fontFamily: 'Pop',
                color: Colors.white60,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hr,
                style: const TextStyle(
                    fontFamily: 'Pop',
                    color: kwhite,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                ' bpm ',
                style: TextStyle(
                    fontFamily: 'Go',
                    color: kwhite,
                    fontSize: 11,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const Spacer(),
          SleekCircularSlider(
            appearance: CircularSliderAppearance(
              size: 110,
              startAngle: 180,
              angleRange: 180,
              infoProperties: InfoProperties(
                  mainLabelStyle: const TextStyle(color: kwhite)),
              customWidths: CustomSliderWidths(
                progressBarWidth: 15,
                trackWidth: 15,
                shadowWidth: 10,
                handlerSize: 10,
              ),
            ),
            initialValue: double.parse(hr.toString()).heartpercent(),
          ),
        ],
      ),
    );
  }
}

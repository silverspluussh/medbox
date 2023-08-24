import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/rtest/rtestresult.dart';
import 'package:MedBox/version2/UI/rtest/rtestschedule.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Rapidtest extends ConsumerWidget {
  const Rapidtest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        child: VStack([
          ...rtests.map((e) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: Text(
                  e,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                subtitle: Btxt(text: '$e  is available '),
                trailing: PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: const Icon(
                    Icons.menu_open,
                    color: kprimary,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: InkWell(
                      onTap: () {
                        context.pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RtestResult(e)));
                      },
                      child: Card(
                          color: kgreen.withOpacity(0.7),
                          child:
                              Itxt(text: AppLocalizations.of(context)!.vtests)
                                  .p8()),
                    )),
                    PopupMenuItem(
                        child: InkWell(
                      onTap: () {
                        context.pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RtestSchedule(e)));
                      },
                      child: Card(
                              color: kprimary.withOpacity(0.7),
                              child: Itxt(
                                      text: AppLocalizations.of(context)!.stest)
                                  .p8())
                          .p8(),
                    )),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(width: 1.2, color: kprimary)),
              ).py8())
        ]).p16(),
      ),
    );
  }
}

List<String> rtests = [
  'Malaria test',
  'Cholestrol level test',
  'Blood pressure test',
  'Hepatitis B test',
  'Typhoid test',
  'Anaemia test',
  'Sickle Cell test',
  'Pregnancy test'
];

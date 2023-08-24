import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/rtest/rtestschedule.dart';
import 'package:MedBox/version2/firebase/rtestfirebase.dart';
import 'package:MedBox/version2/wiis/async_value_widget.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../wiis/shimmer.dart';

class RtestResult extends ConsumerWidget {
  const RtestResult(this.e, {super.key});
  final String e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(streamTestsProvider);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: AsyncValueWidget(
          loading: ListView.builder(
              itemCount: 6,
              itemBuilder: (con, index) =>
                  const ShimmerWidget.rectangular(height: 80)).centered(),
          value: results,
          data: (r) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: kprimary,
                        )),
                    const Spacer(),
                    Ttxt(text: '$e  results'),
                    const Spacer()
                  ],
                ),
              ),
              SliverList.builder(
                itemCount: r.isNotEmpty ? r.length : 1,
                itemBuilder: (context, index) => r.isNotEmpty
                    ? ExpansionTile(
                        trailing: Btxt(text: r[index].testdate!),
                        controlAffinity: ListTileControlAffinity.leading,
                        subtitle: HStack([
                          Btxt(text: AppLocalizations.of(context)!.from),
                          Card(
                            color: Colors.purple[100],
                            child: Btxt(text: r[index].pharmacy!).p4(),
                          )
                        ]),
                        collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                width: 1, color: kprimary.withOpacity(0.5))),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                width: 1, color: kprimary.withOpacity(0.5))),
                        title: Text(
                          '${r[index].testtype!} results',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        childrenPadding: const EdgeInsets.all(10),
                        children: [
                            Row(
                              children: [
                                const Text(
                                  'Results:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10),
                                Card(
                                    color: r[index].testresult! == true
                                        ? kred
                                        : kgreen,
                                    child: Text(
                                            r[index].testresult! == true
                                                ? 'Positive'
                                                : 'Negative',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: kwhite,
                                                fontWeight: FontWeight.w300))
                                        .p4()
                                        .centered()),
                              ],
                            ).py16(),
                            Row(
                              children: [
                                const Text(
                                  'Results descripton:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10),
                                Btxt(text: r[index].results!),
                              ],
                            ),
                          ])
                    : SizedBox(
                        height: 500,
                        width: 500,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Lottie.asset('assets/lottie/empty.json')
                                  .centered(),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RtestSchedule(e))),
                                child: Card(
                                  color: kprimary.withOpacity(0.6),
                                  child: const Itxt(
                                          text: 'Schedule rapid test now!')
                                      .p8(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ).p32(),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class Rtestresultcard extends StatelessWidget {
  const Rtestresultcard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        trailing: const Column(
          children: [
            Btxt(text: 'Pending'),
            SizedBox(height: 5),
            Btxt(text: '2:30')
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        subtitle: HStack([
          Btxt(text: AppLocalizations.of(context)!.from),
          Card(
            color: Colors.purple[100],
            child: const Btxt(text: 'Hale Pharmacy').p4(),
          )
        ]),
        collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: kprimary.withOpacity(0.5))),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: kprimary.withOpacity(0.5))),
        title: const Text(
          'malaria test results',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ));
  }
}

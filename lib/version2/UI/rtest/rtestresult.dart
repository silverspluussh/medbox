import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/firebase/rtestfirebase.dart';
import 'package:MedBox/version2/wiis/async_value_widget.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class RtestResult extends ConsumerWidget {
  const RtestResult(this.e, {super.key});
  final String e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(streamTestsProvider);
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
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
                Ltxt(text: '$e  results'),
                const Spacer()
              ],
            ),
          ),
          SliverList.builder(
            itemCount: results.value!.isNotEmpty ? results.value!.length : 1,
            itemBuilder: ((context, index) => AsyncValueWidget(
                  value: results,
                  data: (r) => r.isNotEmpty
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
                      : const SizedBox(
                          child: Center(
                            child:
                                Ltxt(text: 'No test results received so far'),
                          ),
                        ).p32(),
                )),
          )
        ],
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

import 'package:MedBox/version2/UI/rtest/rtestschedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../constants/colors.dart';
import '../wiis/txt.dart';

class Pharmacy extends ConsumerWidget {
  const Pharmacy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
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
                Ltxt(
                  text: AppLocalizations.of(context)!.avaipharmacies,
                ),
                const Spacer()
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            PharmacyCard(size: size),
            PharmacyCard(size: size),
            PharmacyCard(size: size),
            PharmacyCard(size: size),
            PharmacyCard(size: size),
          ]))
        ],
      )),
    );
  }
}

class PharmacyCard extends StatelessWidget {
  const PharmacyCard({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: kprimary.withOpacity(0.2), blurRadius: 3, spreadRadius: 2)
      ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: size.height * 0.29,
      width: size.width * 0.9,
      child: VStack([
        HStack([
          Image.asset('assets/images/banner.png',
              width: size.width * 0.3, height: size.height * 0.1),
          const Spacer(),
          VStack([
            const Ltxt(text: 'Hale Pharmacy'),
            Card(
              child: InkWell(
                onTap: () {
                  launchUrl(
                      Uri.parse(
                          'https://www.google.com/maps/dir//Hale+Pharmacy,+Achimota/@5.6309121,-0.289137,12z/data=!3m1!4b1!4m8!4m7!1m0!1m5!1m1!1s0xfdf9b35b2944d79:0xe18bf68f56439b36!2m2!1d-0.2190964!2d5.6309163?hl=en&entry=ttu'),
                      mode: LaunchMode.inAppWebView,
                      webViewConfiguration: const WebViewConfiguration(
                          headers: <String, String>{'key': 'value'}));
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: kwhite,
                    ),
                    SizedBox(width: 5),
                    Stxt(text: 'Pokuase'),
                  ],
                ).px8().py4(),
              ),
            )
          ]).px4()
        ]),
        HStack([
          Stxt(text: AppLocalizations.of(context)!.itest),
          const SizedBox(width: 20),
          Card(
            color: Colors.green,
            child:
                Stxt(text: AppLocalizations.of(context)!.available).px4().py4(),
          )
        ]),
        HStack([
          Stxt(text: AppLocalizations.of(context)!.whours),
          const SizedBox(width: 10),
          Card(
            color: Colors.yellow,
            child: const Stxt(text: '6:00- 12:00 am').p4(),
          )
        ]),
        const Spacer(),
        HStack([
          TextButton.icon(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo[300]!)),
              onPressed: () {
                launchUrl(Uri(scheme: 'tel', path: '0570590714'));
              },
              icon: const Icon(Icons.call, color: kwhite, size: 20),
              label: const Stxt(text: 'Call now')),
          const Spacer(),
          TextButton.icon(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all<Color>(kprimary)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RtestSchedule('test')));
              },
              icon: const Icon(Icons.book, color: kwhite, size: 20),
              label: Stxt(text: AppLocalizations.of(context)!.btest)),
        ])
      ]),
    );
  }
}

import 'package:MedBox/constants/pdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../constants/colors.dart';
import '../wiis/txt.dart';
import 'rtest/pharmacyschedule.dart';

class Pharmacy extends ConsumerWidget {
  const Pharmacy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: kprimary,
            )),
        centerTitle: true,
        title: Ltxt(text: AppLocalizations.of(context)!.avaipharmacies),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                  itemCount: pharmacies.length,
                  itemBuilder: (context, index) =>
                      PharmacyCard(size: size, index: index, pharm: pharmacies))
            ],
          ),
        ),
      ),
    );
  }
}

class PharmacyCard extends StatelessWidget {
  const PharmacyCard({
    super.key,
    required this.size,
    required this.pharm,
    required this.index,
  });

  final Size size;

  final List<Pharm> pharm;
  final int index;

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
              width: size.width * 0.2, height: size.height * 0.1),
          const Spacer(),
          VStack([
            Ltxt(text: pharm[index].name),
            Card(
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse(pharm[index].urllocation),
                      mode: LaunchMode.inAppWebView,
                      webViewConfiguration: const WebViewConfiguration(
                          headers: <String, String>{'key': 'value'}));
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                      color: kwhite,
                    ),
                    const SizedBox(width: 5),
                    Stxt(text: pharm[index].location),
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
            child: const Stxt(text: '8:00- 10:00 pm').p4(),
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
                launchUrl(Uri(scheme: 'tel', path: pharm[index].servicenumber));
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
                        builder: (context) => PSchedule(pharm[index].name)));
              },
              icon: const Icon(Icons.book, color: kwhite, size: 20),
              label: Stxt(text: AppLocalizations.of(context)!.btest)),
        ])
      ]),
    );
  }
}

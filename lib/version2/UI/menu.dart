import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/pharmacies.dart';
import 'package:MedBox/version2/UI/profile/profile.dart';
import 'package:MedBox/version2/UI/reminders.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              // height: size.height * 0.3,
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: kprimary.withOpacity(0.2),
                    blurRadius: 2,
                    spreadRadius: 2)
              ], borderRadius: BorderRadius.circular(20), color: kwhite),
              child: VStack([
                ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Profile())),
                  leading: const Icon(Icons.person, color: kprimary),
                  title: Ltxt(text: AppLocalizations.of(context)!.mprof)
                      .centered(),
                ),
                const Divider(),
                ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Reminders())),
                  leading: const ImageIcon(
                      AssetImage('assets/icons/reminders-15-64.png'),
                      color: kprimary),
                  title:
                      Ltxt(text: AppLocalizations.of(context)!.mrem).centered(),
                ),
                const Divider(),
                ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Pharmacy())),
                  leading: const Icon(Icons.local_pharmacy, color: kprimary),
                  title: Ltxt(text: AppLocalizations.of(context)!.pharm)
                      .centered(),
                ),
              ]),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 30),
            ListTile(
              onTap: () => launchUrl(Uri.parse('https://www.medboxdata.com')),
              leading: const ImageIcon(AssetImage('assets/icons/manual.png'),
                  color: kprimary),
              title: Ltxt(text: AppLocalizations.of(context)!.help).centered(),
              tileColor: kwhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(width: 0.4, color: kprimary)),
            ).px16().py2(),
            ListTile(
              onTap: () => Share.share(
                  'https://play.google.com/store/apps/details?id=com.datasus.medbox Hi there,can I share this amazing application called medbox with you?',
                  subject: 'Medbox for easy health management'),
              leading: const ImageIcon(
                  AssetImage(
                      'assets/icons/sharing-wireless-bluetooth-sharing-4-512.png'),
                  color: kprimary),
              title: Ltxt(text: AppLocalizations.of(context)!.share).centered(),
              tileColor: kwhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(width: 0.4, color: kprimary)),
            ).px16().py8(),
            SwitchListTile(
              onChanged: (e) {},
              value: true,

              // leading: const Icon(Icons.local_pharmacy, color: kprimary),
              title: const Ltxt(text: 'Theme').centered(),
              tileColor: kwhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(width: 0.4, color: kprimary)),
            ).px16(),
            const SizedBox(height: 20),
            ListTile(
              onTap: () => showDialog(
                  context: context, builder: (_) => _dialogue(size, context)),
              leading: Image.asset('assets/icons/log-out-54-512.png',
                  width: 30, height: 30, color: kred),
              title: Ltxt(text: AppLocalizations.of(context)!.lout).centered(),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: 500.milliseconds,
                showCloseIcon: true,
                backgroundColor: Colors.green[300],
                content: SizedBox(
                  height: 50,
                  width: 200,
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red[300]!)),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Ltxt(text: AppLocalizations.of(context)!.ext)),
                ).px12(),
              )),
              leading: Image.asset('assets/icons/sign-out-243-512.png',
                  width: 30, height: 30, color: kred),
              title: Ltxt(text: AppLocalizations.of(context)!.ext).centered(),
            ),
          ]))
        ],
      ).centered(),
    );
  }

  Dialog _dialogue(Size size, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.green,
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.75,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.outconf,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.sure,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              width: size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontFamily: 'Pop',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.no,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Pop',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

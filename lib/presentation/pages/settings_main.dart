import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/presentation/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/data/datasource/fbasehelper.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            _tileelement(
              size,
              title: 'Help and Support',
              lead: 'assets/icons/help-85-512.png',
              callback: () =>
                  launchUrl(Uri.parse('https://www.datasustl.com/#contact')),
            ),
            _tileelement(
              size,
              title: 'Share with a friend',
              lead: 'assets/icons/sharing-wireless-bluetooth-sharing-4-512.png',
              callback: () async {
                await Share.share('text',
                    subject:
                        'https://play.google.com/store/apps/details?id=com.datasus.medbox Hi there, kindly download Medbox for easy health management.');
              },
            ),
            _tileelement(size,
                title: 'Connect to Medbox device',
                lead:
                    'assets/icons/sharing-wireless-bluetooth-sharing-9-512.png',
                callback: () {
              VxToast.show(context,
                  pdHorizontal: 20,
                  pdVertical: 20,
                  bgColor: Colors.red[400],
                  textColor: Colors.white,
                  position: VxToastPosition.top,
                  msg:
                      'Feature is not enabled at the moment.Check out the lastest update.');
            }),
            _tileelement(size,
                title: 'Log out',
                lead: 'assets/icons/sign-out-243-512.png', callback: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _dialogue(size, context);
                  });
            }),
            _tileelement(size,
                title: 'Exit MedBox Application',
                lead: 'assets/icons/log-out-54-512.png',
                callback: () => SystemNavigator.pop()),
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/medboxicon.png',
              width: size.width * 0.4,
              height: size.height * 0.2,
            ).centered(),
            const SizedBox(height: 20),
          ]))
        ],
      ),
    );
  }

  Dialog _dialogue(Size size, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.green,
      child: Container(
        height: 150,
        width: size.width * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign out confirmation',
              style: popheaderB,
            ),
            const SizedBox(height: 15),
            const Text('Are you sure you want to log out?',
                textAlign: TextAlign.justify, style: popblack),
            const SizedBox(height: 15),
            SizedBox(
              height: 30,
              width: size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      FireBaseCLi().signOut().then((value) async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GoogleOnbarding()),
                            (route) => false);
                      });
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.red, fontSize: 11, fontFamily: 'Popb'),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Popb'),
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

  _tileelement(Size size, {title, lead, VoidCallback callback}) {
    return Container(
      width: size.width,
      height: 60,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: ListTile(
        onTap: callback,
        leading: Image.asset(
          lead,
          width: 25,
          height: 25,
        ),
        title: Text(title, style: popblack),
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 15,
        ),
      ),
    );
  }
}

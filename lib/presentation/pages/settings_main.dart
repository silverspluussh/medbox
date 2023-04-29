import 'package:MedBox/main.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/presentation/pages/intro_page.dart';
import 'package:MedBox/data/datasource/fbasehelper.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

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
              title: 'Support',
              lead: 'assets/icons/set-up-950-512.png',
              callback: () {},
            ),
            _tileelement(
              size,
              title: 'Share with a friend',
              lead: 'assets/icons/sharing-wireless-bluetooth-sharing-4-512.png',
              callback: () {},
            ),
            _tileelement(size,
                title: 'Connect to Medbox device',
                lead:
                    'assets/icons/sharing-wireless-bluetooth-sharing-9-512.png',
                callback: () {}),
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
              'assets/images/ic_launcher_adaptive_fore.png',
              width: size.width * 0.45,
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
              style: TextStyle(
                  color: Colors.black, fontSize: 12, fontFamily: 'Popb'),
            ),
            const SizedBox(height: 15),
            const Text(
              'Are you sure you want to log out?',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: Colors.black, fontSize: 12, fontFamily: 'Pop'),
            ),
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
                        prefs.remove('googlename');
                        prefs.remove('googleloggedin');
                        prefs.remove('googleimage');
                        prefs.remove('googleemail');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Introduction()),
                            (route) => false);
                      });
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.red, fontSize: 13, fontFamily: 'Popb'),
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
                          fontSize: 13,
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

  _tileelement(Size size,
      {required title, required lead, required VoidCallback callback}) {
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
        title: Text(
          title,
          style: const TextStyle(
              fontFamily: 'Pop', fontSize: 12, color: Colors.black),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 15,
        ),
      ),
    );
  }
}

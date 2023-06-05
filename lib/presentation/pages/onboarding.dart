import 'package:MedBox/constants/datas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../domain/sharedpreferences/sharedprefs.dart';

class GoogleOnbarding extends StatefulWidget {
  const GoogleOnbarding({super.key});

  @override
  State<GoogleOnbarding> createState() => _GoogleOnbardingState();
}

class _GoogleOnbardingState extends State<GoogleOnbarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        child: Center(
            child: VStack(
          [
            Text(medboxdesc, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 150),
            ListTile(
              contentPadding: const EdgeInsets.all(10),
              onTap: () async {
                try {
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();

                  final GoogleSignInAuthentication? googleAuth =
                      await googleUser?.authentication;

                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );

                  await FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) async {
                    if (value.user != null) {
                      await preferences(value: value).then((value) {
                        VxToast.show(context,
                            msg: 'Sign in successful',
                            bgColor: Colors.green,
                            textColor: Colors.white,
                            pdHorizontal: 30,
                            pdVertical: 20);
                      });
                    } else {
                      VxToast.show(context,
                          msg: 'Acount could not be verified',
                          bgColor: const Color.fromARGB(255, 245, 36, 29),
                          textColor: Colors.white,
                          pdHorizontal: 30,
                          pdVertical: 20);
                    }
                  }).catchError((e) {});
                } catch (e) {
                  return VxToast.show(context,
                      msg:
                          'Sorry an error occurred with your sign in request $e',
                      bgColor: const Color.fromARGB(255, 245, 36, 29),
                      textColor: Colors.white,
                      pdHorizontal: 30,
                      pdVertical: 20);
                }
              },
              leading: Image.asset('assets/icons/google-95-128.png',
                  width: 50, height: 50),
              title: Text('Sign in with Google ',
                  style: Theme.of(context).textTheme.titleSmall),
            )
          ],
          crossAlignment: CrossAxisAlignment.start,
        ).p32()),
      ).animate().slideX(duration: 300.milliseconds, delay: 100.milliseconds),
    );
  }

  Future preferences({value}) async {
    await SharedCli().setgpfp(value: value.user.photoURL);
    await SharedCli().setgmailstatus(value: true);
    await SharedCli().setuserID(value: value.user.uid);
    await SharedCli().username(value: value.user.displayName);
    await SharedCli().email(value: value.user.email);
  }
}

import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/wiis/cricles.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../utilites/sharedprefs.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
              top: 500,
              right: 200,
              child: Row(
                children: [
                  Circles(width: 20, height: 20, color: Colors.red),
                  SizedBox(width: 40),
                  Circles(width: 10, height: 10, color: Colors.green),
                ],
              )),
          const Positioned(
              bottom: 130,
              right: 100,
              child: Row(
                children: [
                  Circles(
                      width: 10,
                      height: 10,
                      color: Color.fromARGB(255, 219, 91, 242)),
                  SizedBox(width: 40),
                  Circles(
                      width: 50,
                      height: 40,
                      color: Color.fromARGB(255, 171, 188, 45)),
                ],
              )),
          const Positioned(
              top: 300,
              right: 35,
              child: Row(
                children: [
                  Circles(
                      width: 10,
                      height: 10,
                      color: Color.fromARGB(255, 187, 84, 206)),
                  SizedBox(width: 40),
                  Circles(
                      width: 15,
                      height: 10,
                      color: Color.fromARGB(255, 30, 128, 176)),
                ],
              )),
          const Positioned(
              top: 50,
              right: 50,
              child: Row(
                children: [
                  Circles(width: 40, height: 20, color: Colors.purple),
                  SizedBox(width: 40),
                  Circles(width: 5, height: 10, color: Colors.blueGrey),
                ],
              )),
          const Positioned(
              top: 100,
              left: 30,
              child: Row(
                children: [
                  Circles(width: 30, height: 25, color: Colors.yellow),
                  SizedBox(width: 40),
                  Circles(width: 10, height: 5, color: Colors.indigo),
                ],
              )),
          Positioned(
              top: 200,
              left: 70,
              child: Row(
                children: [
                  Image.asset('assets/images/Star 7.png'),
                  const SizedBox(width: 50),
                  Image.asset('assets/images/Star 4.png').py8(),
                ],
              )),
          Positioned(
              bottom: 300,
              right: 70,
              child: Row(
                children: [
                  Image.asset('assets/images/Star 7.png'),
                  const SizedBox(width: 50),
                  Image.asset('assets/images/Star 4.png').py8(),
                ],
              )),
          VxGlassmorphic(
              blur: 0, opacity: 0.5, height: size.height, width: size.width),
          SizedBox(
            height: size.height,
            width: size.width,
            child: VStack(
                alignment: MainAxisAlignment.center,
                crossAlignment: CrossAxisAlignment.center,
                [
                  const Spacer(),
                  Ttxt(text: AppLocalizations.of(context)!.signin),
                  const Spacer(),
                  Image.asset(
                    'assets/images/mddlogo.png',
                  ),
                  const Spacer(),
                  Semantics(
                    button: true,
                    child: InkWell(
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
                              await preferences(value: value).whenComplete(() {
                                return VxToast.show(context,
                                    msg:
                                        'Signed in as ${value.user!.displayName}',
                                    bgColor: Colors.green,
                                    textColor: Colors.white,
                                    textSize: 12,
                                    pdHorizontal: 30,
                                    pdVertical: 20);
                              });
                            } else {
                              return VxToast.show(context,
                                  msg: 'Acount could not be verified',
                                  textSize: 12,
                                  bgColor:
                                      const Color.fromARGB(255, 245, 36, 29),
                                  textColor: Colors.white,
                                  pdHorizontal: 30,
                                  pdVertical: 20);
                            }
                          }).catchError((e) {
                            return VxToast.show(context,
                                msg: e.toString(),
                                bgColor: const Color.fromARGB(255, 245, 36, 29),
                                textColor: Colors.white,
                                pdHorizontal: 30,
                                pdVertical: 20);
                          });
                        } catch (e) {
                          return VxToast.show(context,
                              msg: AppLocalizations.of(context)!.errorq,
                              bgColor: const Color.fromARGB(255, 245, 36, 29),
                              textColor: Colors.white,
                              pdHorizontal: 30,
                              pdVertical: 20);
                        }
                      },
                      child: _googlebtn(size, context),
                    ),
                  ),
                  const Spacer(),
                  Btxt(text: AppLocalizations.of(context)!.agreement).py8(),
                ]),
          ).animate().fadeIn(duration: 500.milliseconds)
        ],
      ),
    );
  }

  Future preferences({value}) async {
    await SharedCli().setuserID(value: value.user.uid);
  }

  Container _googlebtn(Size size, BuildContext context) {
    return Container(
      height: 50,
      width: size.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1.5, color: kprimary)),
      child: HStack([
        const Spacer(),
        const Text(
          'G',
          style: TextStyle(
              fontFamily: 'Pop',
              fontWeight: FontWeight.w600,
              color: kprimary,
              fontSize: 20),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.connect,
          style: const TextStyle(
              fontFamily: 'Pop', fontWeight: FontWeight.w600, color: kprimary),
        ),
        const Spacer(),
      ]).px4(),
    );
  }
}

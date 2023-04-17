// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:MedBox/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:MedBox/data/datasource/fbasehelper.dart';
import 'package:MedBox/main.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/fonts.dart';
import 'renderer.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController semail = TextEditingController();
  final TextEditingController spassword = TextEditingController();
  final TextEditingController username = TextEditingController();

  bool isShowloading = false;
  bool isShowload = false;

  bool notviewable = true;
  bool notvisible = true;
  bool startvisibility = false;
  bool done = false;

  PageController pagecontroller = PageController();
  int currentpage = 0;

  @override
  void initState() {
    pagecontroller.addListener(() {
      setState(() {
        currentpage = pagecontroller.page?.toInt() ?? 0;
      });
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKy = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: size.height,
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            height: size.height * 0.7,
                            width: size.width,
                            child: PageView(
                              controller: pagecontroller,
                              children: [
                                slideritem(
                                  image: 'assets/icons/heartbeat.png',
                                  title: 'Manage your\nbody vitals.',
                                  body:
                                      'easily add and track your daily body vitals with medbox app and enjoy remote healthcare.',
                                ),
                                slideritem(
                                    image: 'assets/icons/reminder.png',
                                    title:
                                        'Set reminders\nfor your medications.',
                                    body:
                                        'add your medications easily and get alerts on when to take them as well as dosage tracking.'),
                                slideritem(
                                    image: 'assets/icons/health-12-512.png',
                                    title:
                                        'share your\nhealth information\nwith your doctor.',
                                    body:
                                        'easily transfer and share your health information with your doctor or health professional.'),
                              ],
                            )),
                        visiblestart(size),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.25,
                    bottom: size.height * 0.2,
                    right: size.width * 0.2,
                    left: size.width * 0.2,
                    child: SizedBox(
                        height: size.height * 0.45,
                        width: size.width * 0.4,
                        child: Visibility(
                          replacement: const SizedBox(),
                          visible: isShowload,
                          child: Column(
                            children: [
                              Center(
                                child: Lottie.asset(
                                    'assets/lottie/99318-hms-loading.json',
                                    height: size.height * 0.2,
                                    width: size.width * 0.3),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Authenticating...',
                                style: TextStyle(
                                    fontFamily: "Pop",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ))
        .animate()
        .fadeIn(duration: 100.milliseconds, delay: 100.milliseconds);
  }

  Container buttoncards(Size size, BuildContext context) {
    return Container(
      height: 52,
      width: size.width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                showGeneralDialog(
                    barrierDismissible: true,
                    barrierLabel: 'Register',
                    context: context,
                    transitionDuration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      Tween<Offset> tween;

                      tween =
                          Tween(begin: const Offset(0, -1), end: Offset.zero);

                      return SlideTransition(
                        position: tween.animate(
                          CurvedAnimation(
                              parent: animation, curve: Curves.easeInOut),
                        ),
                        child: child,
                      );
                    },
                    pageBuilder: (context, _, __) {
                      return Center(
                        child: register(size),
                      );
                    });
              });
            },
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 50,
              width: size.width * 0.35,
              child: const Center(
                  child: Text(
                'Register',
                style: TextStyle(
                    fontFamily: "Pop",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                showGeneralDialog(
                    barrierDismissible: true,
                    barrierLabel: 'Sign in',
                    context: context,
                    transitionDuration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      Tween<Offset> tween;

                      tween =
                          Tween(begin: const Offset(0, -1), end: Offset.zero);

                      return SlideTransition(
                        position: tween.animate(
                          CurvedAnimation(
                              parent: animation, curve: Curves.easeInOut),
                        ),
                        child: child,
                      );
                    },
                    pageBuilder: (context, _, __) {
                      return Center(
                        child: signin(size, context),
                      );
                    });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              height: 50,
              width: size.width * 0.4,
              child: const Center(
                  child: Text(
                'Sign In',
                style: TextStyle(
                    fontFamily: "Pop",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }

  visiblestart(Size size) => Visibility(
        visible: startvisibility,
        replacement: SizedBox(
          width: size.width,
          height: 60,
          child: HStack(alignment: MainAxisAlignment.center, [
            MaterialButton(
              onPressed: () {
                setState(() {
                  startvisibility = true;
                });
              },
              elevation: 0,
              minWidth: size.width * 0.45,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(
                    width: 1.5,
                    color: AppColors.primaryColor,
                  )),
              child: const Text(
                'Get Started',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Pop',
                    fontSize: 14,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () {
                setState(() {
                  currentpage != 2
                      ? pagecontroller.nextPage(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeIn)
                      : pagecontroller.previousPage(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeIn);
                  currentpage == pagecontroller.page?.floor();
                });
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Icon(
                    currentpage != 2 ? Icons.arrow_forward : Icons.arrow_back,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            )
          ]),
        ),
        child: buttoncards(size, context),
      );

  slideritem({required image, required title, required body}) {
    return VStack([
      const SizedBox(height: 20),
      Image.asset(
        image,
        width: 50,
        height: 60,
        color: AppColors.primaryColor.withOpacity(0.7),
      ),
      const SizedBox(height: 20),
      Text(
        title,
        textAlign: TextAlign.justify,
        style: const TextStyle(
            fontFamily: 'Popb',
            fontSize: 20,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 50),
      Text(
        body,
        textAlign: TextAlign.justify,
        style: const TextStyle(
            fontFamily: 'Pop',
            fontSize: 13,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500),
      ),
    ]);
  }

  register(Size size) {
    return Container(
      width: size.width - 50,
      height: size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width - 50,
            height: size.height * 0.7,
            child: Animate(
              child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome to Med Box,\nGlad to have you here!',
                        style: TextStyle(
                            fontFamily: "Pop",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sign up to start...',
                        style: TextStyle(
                            fontFamily: "Pop",
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Field  cannot be left empty';
                          }

                          return null;
                        },
                        style: const TextStyle(
                            fontFamily: "Pop",
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                        controller: username,
                        decoration: InputDecoration(
                          suffix: Image.asset('assets/icons/profile-35-64.png',
                              width: 25, height: 25),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 3,
                                  color: Color.fromARGB(255, 94, 93, 93))),
                          hintText: 'user name',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontFamily: "Pop",
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                        validator: (val) {
                          if (!val!.contains('@') && !val.contains('.com')) {
                            return 'Email format wrong';
                          }
                          if (val.isEmpty) {
                            return 'Field  cannot be left empty';
                          }

                          return null;
                        },
                        controller: semail,
                        decoration: InputDecoration(
                          suffix: Image.asset('assets/icons/email-111-128.png',
                              width: 25, height: 25),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 3,
                                  color: Color.fromARGB(255, 94, 93, 93))),
                          hintText: 'email',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Field  cannot be left empty';
                          } else if (val.length < 6) {
                            return 'password should be 6 characters or more';
                          }

                          return null;
                        },
                        style: const TextStyle(
                            fontFamily: "Pop",
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                        obscureText: notvisible,
                        controller: spassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 3,
                                  color: Color.fromARGB(255, 94, 93, 93))),
                          hintText: 'password',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: size.width * 0.6,
                          child: MaterialButton(
                            minWidth: size.width * 0.6,
                            onPressed: () async {
                              bool svalidated =
                                  formkey.currentState!.validate();
                              setState(() {
                                isShowloading = true;
                              });

                              if (svalidated == true) {
                                Navigator.pop(_scaffoldKy.currentContext!);

                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: semail.text,
                                          password: spassword.text)
                                      .then((value) async {
                                    await FirestoreAuth()
                                        .sharedpredusername(username.text);
                                    log('username set');
                                    prefs.setString('email', email.text);
                                  }).then((value) {
                                    password.clear();
                                    email.clear();
                                  }).then((value) {
                                    setState(() {
                                      isShowload = false;
                                    });
                                    Navigator.pushReplacement(
                                        _scaffoldKy.currentContext!,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Render()));

                                    return VxToast.show(
                                        _scaffoldKy.currentContext!,
                                        msg: 'Sign up successful',
                                        bgColor: const Color.fromARGB(
                                            255, 44, 112, 48),
                                        textColor: Colors.white,
                                        pdHorizontal: 30,
                                        pdVertical: 20,
                                        showTime: 1000);
                                  });
                                } catch (e) {
                                  return VxToast.show(
                                      _scaffoldKy.currentContext!,
                                      msg:
                                          'An error occured, check your email and password and try again',
                                      bgColor: const Color.fromARGB(
                                          255, 245, 36, 29),
                                      textColor: Colors.white,
                                      pdHorizontal: 30,
                                      pdVertical: 20);
                                } finally {
                                  Future.delayed(
                                      const Duration(microseconds: 100), () {
                                    setState(() {
                                      isShowload = false;
                                    });
                                  });
                                }
                              } else {
                                Future.delayed(
                                    const Duration(microseconds: 100), () {
                                  setState(() {
                                    isShowloading = false;
                                  });
                                });
                              }
                            },
                            height: 50,
                            elevation: 10,
                            color: const Color.fromARGB(255, 91, 163, 235),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Text(
                              isShowloading == false
                                  ? 'Register now'
                                  : 'Signing up',
                              style: pop,
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30)
                    ],
                  )),
            ).animate().fadeIn(duration: const Duration(milliseconds: 320)),
          ),
        ),
      ),
    );
  }

  signin(Size size, BuildContext context) {
    return Container(
      width: size.width - 50,
      height: size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.white),
      child: Scaffold(
        key: _scaffoldKy,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: size.width - 50,
            height: size.height * 0.7,
            child: Animate(
              child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back,\nYou have been missed!',
                        style: TextStyle(
                            fontFamily: "Pop",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sign in to continue...',
                        style: TextStyle(
                            fontFamily: "Pop",
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: (val) {
                          if (!val!.contains('@') && !val.contains('.com')) {
                            return 'Email format wrong';
                          }
                          if (val.isEmpty) {
                            return 'Field  cannot be left empty';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontFamily: "Pop",
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                        controller: email,
                        readOnly: false,
                        decoration: InputDecoration(
                          suffix: Image.asset('assets/icons/email-111-128.png',
                              width: 25, height: 25),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 3,
                                  color: Color.fromARGB(255, 94, 93, 93))),
                          hintText: 'Email',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontFamily: "Pop",
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                        obscureText: notviewable,
                        controller: password,
                        validator: (va) {
                          if (va!.isEmpty) {
                            return 'Field  cannot be left empty';
                          }
                          if (va.length < 6) {
                            return 'password should be 6 characters or more';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 3,
                                  color: Color.fromARGB(255, 94, 93, 93))),
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: size.width * 0.6,
                          child: MaterialButton(
                            onPressed: () async {
                              bool valid = formkey.currentState!.validate();
                              setState(() {
                                isShowload = true;
                              });
                              if (valid == true) {
                                if (isShowload == true) {
                                  Navigator.pop(_scaffoldKey.currentContext!);
                                }

                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email.text,
                                          password: password.text)
                                      .then((value) {
                                    prefs.setString('email', email.text);
                                  }).then((value) {
                                    setState(() {
                                      isShowload = false;
                                    });

                                    VxToast.show(_scaffoldKey.currentContext!,
                                        msg: 'Sign in succesful',
                                        bgColor: const Color.fromARGB(
                                            255, 43, 107, 57),
                                        textColor: Colors.white,
                                        pdHorizontal: 30,
                                        pdVertical: 20);
                                    setState(() {
                                      isShowload = false;
                                    });

                                    Navigator.pushAndRemoveUntil(
                                        _scaffoldKey.currentContext!,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Render()),
                                        (route) => false);
                                  });
                                } catch (e) {
                                  VxToast.show(_scaffoldKey.currentContext!,
                                      msg:
                                          'An error occurred:${e.toString().split(' ').withoutFirst()}',
                                      bgColor: Color.fromARGB(255, 250, 46, 46),
                                      textColor: Colors.white,
                                      pdHorizontal: 30,
                                      pdVertical: 20);
                                } finally {
                                  setState(() {
                                    isShowload = false;
                                  });
                                }
                              } else {
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  setState(() {
                                    isShowload = false;
                                  });
                                });
                              }
                            },
                            height: 50,
                            elevation: 10,
                            color: const Color.fromARGB(255, 91, 163, 235),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Text(
                              isShowload == false ? 'Log in' : 'Logging in',
                              style: pop,
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          '------ or sign in with -------',
                          style: TextStyle(
                              fontFamily: "Pop",
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  try {
                                    final GoogleSignInAccount? googleUser =
                                        await GoogleSignIn().signIn();

                                    final GoogleSignInAuthentication?
                                        googleAuth =
                                        await googleUser?.authentication;

                                    final credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: googleAuth?.accessToken,
                                      idToken: googleAuth?.idToken,
                                    );

                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential)
                                        .then((value) async {
                                      await prefs.setString('googlename',
                                          value.user!.displayName!);
                                      await prefs.setBool(
                                          'googleloggedin', true);
                                      await prefs.setString(
                                          'googleimage', value.user!.photoURL!);
                                      await prefs.setString(
                                          'googleid', value.user!.email!);
                                      value.user != null
                                          ? Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Render()))
                                          : VxToast.show(context,
                                              msg:
                                                  'Acount could not be verified',
                                              bgColor: const Color.fromARGB(
                                                  255, 245, 36, 29),
                                              textColor: Colors.white,
                                              pdHorizontal: 30,
                                              pdVertical: 20);
                                    }).catchError((e) {});
                                  } catch (e) {
                                    return VxToast.show(context,
                                        msg:
                                            'Sorry an error occurred with your sign in request',
                                        bgColor: const Color.fromARGB(
                                            255, 245, 36, 29),
                                        textColor: Colors.white,
                                        pdHorizontal: 30,
                                        pdVertical: 20);
                                  }
                                },
                                icon: const ImageIcon(
                                  AssetImage('assets/icons/google-95-128.png'),
                                  color: Colors.red,
                                  size: 50,
                                )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'Forgot your password ?',
                            style: TextStyle(
                                fontFamily: "Pop",
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.red[400]),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
          ),
        ),
      ),
    );
  }
}

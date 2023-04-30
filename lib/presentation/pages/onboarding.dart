import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/pages/renderer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/fonts.dart';
import '../../domain/sharedpreferences/sharedprefs.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController semail = TextEditingController();
  final TextEditingController spassword = TextEditingController();
  final TextEditingController username = TextEditingController();

  bool isShowloading = false;
  bool isShowload = false;

  bool notvisible = true;
  bool startvisibility = false;
  bool done = false;

  PageController pagecontroller = PageController();
  final formkey = GlobalKey<FormState>();
  final formkey9 = GlobalKey<FormState>();

  int currentpage = 0;

  bool passwordvisibility = true;

  @override
  void initState() {
    pagecontroller.addListener(() {
      setState(() {
        currentpage = pagecontroller.page?.toInt() ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Positioned(
                top: 40, left: 0, right: 0, child: _onboardbuttons(size)),
            Positioned(
              top: 150,
              child: SizedBox(
                height: size.height - 100,
                width: size.width - 50,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pagecontroller,
                  children: [
                    SizedBox(
                      height: size.height - 70,
                      width: size.width - 50,
                      child: Form(
                          key: formkey9,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    if (!val!.contains('@') &&
                                        !val.contains('.com')) {
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
                                    suffix: Image.asset(
                                        'assets/icons/email-111-128.png',
                                        width: 25,
                                        height: 25),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 3,
                                            color: Color.fromARGB(
                                                255, 94, 93, 93))),
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
                                  obscureText: passwordvisibility,
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
                                    suffix: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordvisibility =
                                                !passwordvisibility;
                                          });
                                        },
                                        icon: Icon(passwordvisibility == false
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 3,
                                            color: Color.fromARGB(
                                                255, 94, 93, 93))),
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
                                        bool valid =
                                            formkey9.currentState!.validate();
                                        setState(() {
                                          isShowload = true;
                                        });
                                        if (valid == true) {
                                          try {
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: email.text,
                                                    password: password.text)
                                                .then((value) async {
                                              await SharedCli()
                                                  .email(value: email.text);
                                              await SharedCli().setuserID(
                                                  value: value.user!.uid);
                                            }).then((value) {
                                              setState(() {
                                                isShowload = false;
                                              });

                                              VxToast.show(context,
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
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Render()),
                                                  (route) => false);
                                            });
                                          } catch (e) {
                                            VxToast.show(context,
                                                msg:
                                                    'An error occurred:${e.toString().split(' ').withoutFirst()}',
                                                bgColor: const Color.fromARGB(
                                                    255, 250, 46, 46),
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
                                              const Duration(milliseconds: 100),
                                              () {
                                            setState(() {
                                              isShowload = false;
                                            });
                                          });
                                        }
                                      },
                                      height: 50,
                                      elevation: 10,
                                      color: const Color.fromARGB(
                                          255, 91, 163, 235),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                          child: Text(
                                        isShowload == false
                                            ? 'Log in'
                                            : 'Logging in',
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
                                              final GoogleSignInAccount?
                                                  googleUser =
                                                  await GoogleSignIn().signIn();

                                              final GoogleSignInAuthentication?
                                                  googleAuth = await googleUser
                                                      ?.authentication;

                                              final credential =
                                                  GoogleAuthProvider.credential(
                                                accessToken:
                                                    googleAuth?.accessToken,
                                                idToken: googleAuth?.idToken,
                                              );

                                              await FirebaseAuth.instance
                                                  .signInWithCredential(
                                                      credential)
                                                  .then((value) async {
                                                value.user != null
                                                    ? Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Render()))
                                                    : VxToast.show(context,
                                                        msg:
                                                            'Acount could not be verified',
                                                        bgColor: const Color
                                                                .fromARGB(
                                                            255, 245, 36, 29),
                                                        textColor: Colors.white,
                                                        pdHorizontal: 30,
                                                        pdVertical: 20);

                                                await SharedCli().setuserID(
                                                    value: value.user!.uid);
                                                await SharedCli().username(
                                                    value: value
                                                        .user!.displayName!);

                                                await SharedCli().email(
                                                    value: value.user!.email!);

                                                await SharedCli()
                                                    .setgmailstatus(
                                                        value: true);

                                                await SharedCli().setgpfp(
                                                    value:
                                                        value.user!.photoURL!);
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
                                            AssetImage(
                                                'assets/icons/google-95-128.png'),
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
                              ])).animate().slideX(duration: 100.milliseconds),
                    ),
                    SizedBox(
                      height: size.height - 70,
                      width: size.width - 50,
                      child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  suffix: Image.asset(
                                      'assets/icons/profile-35-64.png',
                                      width: 25,
                                      height: 25),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 94, 93, 93))),
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
                                  if (!val!.contains('@') &&
                                      !val.contains('.com')) {
                                    return 'Email format wrong';
                                  }
                                  if (val.isEmpty) {
                                    return 'Field  cannot be left empty';
                                  }

                                  return null;
                                },
                                controller: semail,
                                decoration: InputDecoration(
                                  suffix: Image.asset(
                                      'assets/icons/email-111-128.png',
                                      width: 25,
                                      height: 25),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 94, 93, 93))),
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
                                  suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          notvisible = !notvisible;
                                        });
                                      },
                                      icon: Icon(notvisible == false
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 94, 93, 93))),
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
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email: semail.text,
                                                  password: spassword.text)
                                              .then((value) async {
                                            await SharedCli()
                                                .username(value: username.text);

                                            await SharedCli()
                                                .email(value: email.text);
                                          }).then((value) {
                                            password.clear();
                                            email.clear();
                                          }).then((value) {
                                            setState(() {
                                              isShowload = false;
                                            });
                                            VxToast.show(context,
                                                msg: 'Sign up successful',
                                                bgColor: const Color.fromARGB(
                                                    255, 44, 112, 48),
                                                textColor: Colors.white,
                                                pdHorizontal: 30,
                                                pdVertical: 20,
                                                showTime: 1000);

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Render()));
                                          });
                                        } catch (e) {
                                          return VxToast.show(context,
                                              msg:
                                                  'An error occured, check your email and password and try again',
                                              bgColor: const Color.fromARGB(
                                                  255, 245, 36, 29),
                                              textColor: Colors.white,
                                              pdHorizontal: 30,
                                              pdVertical: 20);
                                        } finally {
                                          Future.delayed(
                                              const Duration(microseconds: 100),
                                              () {
                                            setState(() {
                                              isShowload = false;
                                            });
                                          });
                                        }
                                      } else {
                                        Future.delayed(
                                            const Duration(microseconds: 100),
                                            () {
                                          setState(() {
                                            isShowloading = false;
                                          });
                                        });
                                      }
                                    },
                                    height: 50,
                                    elevation: 10,
                                    color:
                                        const Color.fromARGB(255, 91, 163, 235),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
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
                            ],
                          )).animate().slideX(duration: 200.milliseconds),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _onboardbuttons(Size size) {
    return SizedBox(
      height: 70,
      width: size.width,
      child: HStack(
        [
          InkWell(
            onTap: () {
              setState(() {
                pagecontroller.jumpToPage(0);
              });
            },
            child: Card(
                color: currentpage == 0 ? AppColors.primaryColor : Colors.white,
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontFamily: 'Pop',
                    fontSize: 13,
                    color: currentpage == 0 ? Colors.white : Colors.black,
                  ),
                ).px16().py8()),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  pagecontroller.jumpToPage(1);
                });
              },
              child: Card(
                  color:
                      currentpage == 1 ? AppColors.primaryColor : Colors.white,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Pop',
                      fontSize: 13,
                      color: currentpage == 1 ? Colors.white : Colors.black,
                    ),
                  ).px16().py8()))
        ],
        alignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}

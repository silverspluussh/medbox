import 'dart:developer';
import 'package:MedBox/version2/utilites/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../firebase/vitalsfirebase.dart';
import '../../models/vitalsmodel.dart';
import '../../wiis/formfieldwidget.dart';
import '../../wiis/txt.dart';

class AddVitals extends ConsumerStatefulWidget {
  const AddVitals({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddVitalsState();
}

class _AddVitalsState extends ConsumerState<AddVitals> {
  final formkey = GlobalKey<FormState>();

  TextEditingController temp = TextEditingController();
  TextEditingController bps = TextEditingController();
  TextEditingController bpd = TextEditingController();

  TextEditingController hr = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController br = TextEditingController();
  TextEditingController weight = TextEditingController();

  bool loader = false;

  @override
  void dispose() {
    temp.dispose();
    bps.dispose();
    bpd.dispose();
    hr.dispose();
    height.dispose();
    br.dispose();
    weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
            key: formkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width,
                    child: HStack([
                      Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 0.5)),
                          child: IconButton(
                              onPressed: () => context.pop(context),
                              icon: const Icon(Icons.close,
                                  size: 30, color: Colors.red))),
                      const Spacer(),
                      const Ltxt(text: 'Add Vitals'),
                    ]).px12(),
                  ),
                  const SizedBox(height: 20),
                  const Ttxt(text: 'Body Temperature'),
                  5.heightBox,
                  Customfield(
                    readonly: false,
                    controller: temp,
                    hinttext: 'eg. 34 °C',
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'field cannot be empty';
                      } else if (double.parse(value.toString()) > 38.0 &&
                          double.parse(value.toString()) < 10) {
                        return 'Readings must be between 10 and 38.0 °C';
                      } else if (double.parse(value) == 0) {
                        return "value entered is invalid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  const Ttxt(text: 'Blood pressure'),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.45,
                        child: Customfield(
                          readonly: false,
                          controller: bps,
                          hinttext: 'Systolic',
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'field cannot be empty';
                            } else if (double.parse(value.toString()) > 370.0 &&
                                double.parse(value.toString()) < 30) {
                              return 'Readings must be between 30 and 370.0 mmHg';
                            } else if (double.parse(value) == 0) {
                              return "value entered is invalid";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.45,
                        child: Customfield(
                          hinttext: 'Diastolic',
                          readonly: false,
                          controller: bpd,
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'field cannot be empty';
                            } else if (double.parse(value.toString()) > 360.0 &&
                                double.parse(value.toString()) < 30) {
                              return 'Readings must be between 30 and 360.0 mmHg';
                            } else if (double.parse(bps.text) ==
                                double.parse(value)) {
                              return 'Diastolic cannot be same as Systolic';
                            } else if (double.parse(value) == 0) {
                              return "value entered is invalid";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Ttxt(text: 'Heart Rate'),
                  5.heightBox,
                  Customfield(
                    readonly: false,
                    controller: hr,
                    hinttext: 'eg. 100 bpm',
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'field cannot be empty';
                      } else if (double.parse(value) == 0) {
                        return "value entered is invalid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  const Ttxt(text: 'Breathe Rate'),
                  5.heightBox,
                  Customfield(
                    readonly: false,
                    hinttext: 'eg. 50 bpm',
                    controller: br,
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'field cannot be empty';
                      } else if (double.parse(value) == 0) {
                        return "value entered is invalid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  const Ttxt(text: 'Body Mass Index'),
                  5.heightBox,
                  HStack([
                    SizedBox(
                      width: size.width * 0.45,
                      child: Customfield(
                        readonly: false,
                        controller: weight,
                        hinttext: 'weight (kg)',
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'field cannot be empty';
                          } else if (double.parse(value) == 0) {
                            return "value entered is invalid";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.45,
                      child: Customfield(
                        controller: height,
                        readonly: false,
                        hinttext: 'Height (m)',
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'field cannot be empty';
                          } else if (double.parse(value) > 3.0) {
                            return 'height is out of range (1.0 - 3.0)';
                          } else if (double.parse(value) == 0) {
                            return "value entered is invalid";
                          }
                          return null;
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      final provider = ref.watch(vitalsFirebaseProvider);

                      final validate = formkey.currentState!.validate();
                      if (validate == true) {
                        setState(() {
                          loader = true;
                        });
                        try {
                          final vmodel = VModel(
                              bp: '${bps.text}/${bpd.text}',
                              br: br.text,
                              date: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              hr: hr.text,
                              temp: temp.text,
                              vid: FirebaseAuth.instance.currentUser!.uid,
                              weight: weight.text,
                              bmi: 0.0
                                  .solveBmi(
                                      height: double.parse(height.text),
                                      weight: double.parse(weight.text))
                                  .toStringAsFixed(3));

                          provider
                              .addVital(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  test: vmodel)
                              .whenComplete(() {
                            setState(() {
                              loader = false;
                            });
                            clearControllers().then((b) => VxToast.show(context,
                                msg: 'vitals added successfully',
                                bgColor: const Color.fromARGB(255, 21, 164, 43),
                                textColor: Colors.white,
                                pdHorizontal: 20,
                                pdVertical: 10));
                          }).then((value) => context.pop());
                        } catch (e) {
                          setState(() {
                            loader = false;
                          });
                          log(e.toString());
                        }
                      }
                    },
                    child: Container(
                      width: size.width * 0.9,
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15)),
                      child: loader == false
                          ? const Text(
                              'Add Vitals',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ).centered()
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ).centered(),
                    ),
                  ),
                ],
              ),
            )),
      )),
    );
  }

  Future<void> clearControllers() async {
    br.clear();
    height.clear();
    weight.clear();
    bps.clear();
    bpd.clear();

    temp.clear();
    hr.clear();
  }
}

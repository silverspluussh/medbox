import 'dart:developer';
import 'package:MedBox/version2/utilites/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../constants/colors.dart';
import '../../firebase/vitalsfirebase.dart';
import '../../models/vitalsmodel.dart';
import '../../utilites/randomgen.dart';
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
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
            key: formkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: kprimary,
                          )),
                      const Spacer(),
                      Ttxt(text: AppLocalizations.of(context)!.rnewvitals)
                          .centered(),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      FormfieldX(
                        label: AppLocalizations.of(context)!.temp,
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
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Ttxt(text: 'Blood pressure'),
                  Row(
                    children: [
                      FormfieldX(
                        label: 'Systolic pressure',
                        readonly: false,
                        controller: bps,
                        hinttext: 'eg. 95 mmHg',
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
                      FormfieldX(
                        label: 'Diastolic pressure',
                        readonly: false,
                        controller: bpd,
                        hinttext: 'eg. 95 mmHg',
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
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      FormfieldX(
                        label: AppLocalizations.of(context)!.hr,
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
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      FormfieldX(
                        label: AppLocalizations.of(context)!.br,
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
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Ttxt(text: 'BMI'),
                  HStack([
                    FormfieldX(
                      label: ' weight',
                      readonly: false,
                      controller: weight,
                      hinttext: 'eg. enter weight in kg',
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
                    FormfieldX(
                      label: 'Height',
                      controller: height,
                      readonly: false,
                      hinttext: 'enter height in meters',
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
                  ]),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
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
                                vid: idg().toString(),
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
                              clearControllers().then((b) => VxToast.show(
                                  context,
                                  msg: 'vitals added successfully',
                                  bgColor:
                                      const Color.fromARGB(255, 21, 164, 43),
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
                      child: loader == false
                          ? const Text('Add vitals').px12().py4()
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ))
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

import 'dart:developer';

import 'package:MedBox/version2/firebase/vitalsfirebase.dart';
import 'package:MedBox/version2/models/vitalsmodel.dart';
import 'package:MedBox/version2/utilites/extensions.dart';
import 'package:MedBox/version2/utilites/randomgen.dart';
import 'package:MedBox/version2/utilites/sharedprefs.dart';
import 'package:MedBox/version2/wiis/async_value_widget.dart';
import 'package:MedBox/version2/wiis/formfieldwidget.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:MedBox/version2/wiis/vitalscard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../constants/colors.dart';
import '../wiis/vitalschart.dart';

class MyVitals extends ConsumerStatefulWidget {
  const MyVitals({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyVitalsState();
}

class _MyVitalsState extends ConsumerState<MyVitals> {
  final formkey = GlobalKey<FormState>();

  TextEditingController temp = TextEditingController();
  TextEditingController bp = TextEditingController();
  TextEditingController hr = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController br = TextEditingController();
  TextEditingController weight = TextEditingController();

  @override
  void dispose() {
    temp.dispose();
    bp.dispose();
    hr.dispose();
    height.dispose();
    br.dispose();
    weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vital = ref.watch(vitalsStreamProvider);

    return AsyncValueWidget(
        value: vital,
        data: (v) {
          log(v.toString());
          return v.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: VitalsLineChart(vitals: v),
                    ),
                    SliverToBoxAdapter(
                      child: HStack([
                        //const SizedBox(),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => bottomPop(context),
                          icon: const Icon(Icons.add, color: kwhite),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kprimary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.advitals,
                            style: const TextStyle(
                                fontFamily: 'Go',
                                fontSize: 12,
                                color: kwhite,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]).px4().py12(),
                    ),
                    SliverToBoxAdapter(
                        child: Row(
                      children: [
                        VStack([
                          VCard(
                            color: kgreen,
                            label: AppLocalizations.of(context)!.temp,
                            unit: ' °C',
                            value: v.last.temp!,
                          ),
                          VCard(
                              color: Colors.purple,
                              label: AppLocalizations.of(context)!.bp,
                              unit: ' mmhg',
                              value: v.first.bp!),
                        ]),
                        const Spacer(),
                        VCardL(hr: v.last.hr!)
                      ],
                    )),
                    SliverToBoxAdapter(
                      child: HStack([
                        VCard(
                            color: Colors.yellow,
                            label: AppLocalizations.of(context)!.br,
                            unit: ' bpm',
                            value: v.first.br!),
                        const Spacer(),
                        VCard(
                            color: Colors.pink,
                            label: 'BMI',
                            unit: '',
                            value: v.first.bmi!)
                      ]),
                    )
                  ],
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: HStack([
                        const SizedBox(),
                        const Spacer(),
                        TextButton.icon(
                          icon: const Icon(Icons.add, color: kwhite),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kprimary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          onPressed: () => bottomPop(context),
                          label: Text(
                            AppLocalizations.of(context)!.rnewvitals,
                            style: const TextStyle(
                                fontFamily: 'Go',
                                color: kwhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]).px12().py12(),
                    ),
                    SliverToBoxAdapter(
                        child: Row(
                      children: [
                        VStack([
                          VCard(
                            color: kgreen,
                            label: AppLocalizations.of(context)!.temp,
                            unit: ' °C',
                            value: '0',
                          ),
                          VCard(
                              color: Colors.purple,
                              label: AppLocalizations.of(context)!.bp,
                              unit: ' mmhg',
                              value: '0'),
                        ]),
                        const Spacer(),
                        const VCardL(hr: '0')
                      ],
                    )),
                    SliverToBoxAdapter(
                      child: HStack([
                        VCard(
                            color: Colors.yellow,
                            label: AppLocalizations.of(context)!.br,
                            unit: ' bpm',
                            value: '0'),
                        const Spacer(),
                        const VCard(
                            color: Colors.pink,
                            label: 'Body Mass Index',
                            unit: '',
                            value: '0')
                      ]),
                    )
                  ],
                );
        });
  }

  void bottomPop(context) => showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            width: MediaQuery.sizeOf(context).width,
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: VStack(
                    alignment: MainAxisAlignment.center,
                    crossAlignment: CrossAxisAlignment.center,
                    [
                      const SizedBox(height: 10),
                      Ttxt(text: AppLocalizations.of(context)!.rnewvitals)
                          .centered(),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FormfieldX(
                          label: AppLocalizations.of(context)!.temp,
                          readonly: false,
                          controller: temp,
                          hinttext: 'eg. 34.c',
                          inputType: TextInputType.number,
                          validator: (value) {
                            return;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FormfieldX(
                          label: AppLocalizations.of(context)!.bp,
                          readonly: false,
                          controller: bp,
                          hinttext: 'eg. 95 mmHg',
                          inputType: TextInputType.number,
                          validator: (value) {
                            return;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FormfieldX(
                          label: AppLocalizations.of(context)!.hr,
                          readonly: false,
                          controller: hr,
                          hinttext: 'eg. 100 bpm',
                          inputType: TextInputType.number,
                          validator: (value) {
                            return;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FormfieldX(
                          label: AppLocalizations.of(context)!.br,
                          readonly: false,
                          hinttext: 'eg. 50 bpm',
                          controller: br,
                          inputType: TextInputType.number,
                          validator: (value) {
                            return;
                          },
                        ),
                      ),
                      const Ttxt(text: 'BMI'),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: HStack([
                          FormfieldX(
                            label: ' weight',
                            readonly: false,
                            controller: weight,
                            hinttext: 'eg. 60kg',
                            inputType: TextInputType.number,
                            validator: (value) {
                              return;
                            },
                          ),
                          FormfieldX(
                            label: 'Height',
                            controller: height,
                            readonly: false,
                            hinttext: 'eg. 1.80 m',
                            inputType: TextInputType.number,
                            validator: (value) {
                              return;
                            },
                          ),
                        ]),
                      ),
                      ElevatedButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .advitals,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall),
                                          const SizedBox(height: 10),
                                          Text(
                                              'Do you want to proceed with the action?',
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    context.pop();
                                                    final provider = ref.watch(
                                                        vitalsFirebaseProvider);

                                                    final validate = formkey
                                                        .currentState!
                                                        .validate();

                                                    if (validate == true) {
                                                      try {
                                                        final vmodel = VModel(
                                                            bp: bp.text,
                                                            br: br.text,
                                                            date: DateTime.now()
                                                                .toString()
                                                                .split(' ')
                                                                .first,
                                                            hr: hr.text,
                                                            temp: temp.text,
                                                            vid: idgen(),
                                                            weight: weight.text,
                                                            bmi: 0.0
                                                                .solveBmi(
                                                                    height: double
                                                                        .parse(height
                                                                            .text),
                                                                    weight: double
                                                                        .parse(weight
                                                                            .text))
                                                                .toStringAsFixed(
                                                                    3));

                                                        provider
                                                            .addVital(
                                                                uid: SharedCli()
                                                                    .getuserID()!,
                                                                test: vmodel)
                                                            .whenComplete(() {
                                                          log('vitals added  successfully');

                                                          clearControllers().then(
                                                              (b) => VxToast.show(
                                                                  context,
                                                                  msg:
                                                                      'vitals added successfully',
                                                                  bgColor: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      21,
                                                                      164,
                                                                      43),
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  pdHorizontal:
                                                                      20,
                                                                  pdVertical:
                                                                      10));
                                                        }).then((value) =>
                                                                context.pop());
                                                      } catch (e) {
                                                        log(e.toString());
                                                      }
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 13,
                                                        fontFamily: 'Popb'),
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
                                  )),
                          child: const Text('Add vitals'))
                    ]).py8(),
              ),
            ),
          ));

  Future<void> clearControllers() async {
    br.clear();
    height.clear();
    weight.clear();
    bp.clear();
    temp.clear();
    hr.clear();
  }
}

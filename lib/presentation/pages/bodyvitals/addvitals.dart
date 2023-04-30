import 'dart:math';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/pages/renderer.dart';
import 'package:MedBox/utils/extensions/vitalscontroller.dart';
import 'package:MedBox/domain/models/vitalsmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../data/repos/Dbhelpers/vitalsdb.dart';

class AddVitals extends StatefulWidget {
  const AddVitals({super.key});

  @override
  State<AddVitals> createState() => _AddVitalsState();
}

class _AddVitalsState extends State<AddVitals> {
  final formkey = GlobalKey<FormState>();
  var date = DateTime.now();
  TextEditingController temp = TextEditingController();
  TextEditingController pressure = TextEditingController();
  TextEditingController heartrate = TextEditingController();
  TextEditingController oxygen = TextEditingController();
  TextEditingController bmi = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController respiration = TextEditingController();
  TextEditingController weight = TextEditingController();

  VController vController = VController();
  late List<Map<String, dynamic>> vitals = [];

  void referesh() async {
    final data1 = await VitalsDB().queryvital();
    setState(() {
      vitals = data1;
    });
  }

  @override
  void initState() {
    referesh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Add vitals',
          style:
              TextStyle(fontSize: 13, fontFamily: 'Pop', color: Colors.black),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  inputformfield(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        if (int.parse(value) > 200) {
                          return 'Field cannot exceed 200';
                        }
                        return null;
                      },
                      controller: temp,
                      title: 'Temperature',
                      hinttext: 'eg. 25 degree celsius',
                      width: size.width - 20,
                      height: 50),
                  const SizedBox(height: 15),
                  inputformfield(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        if (int.parse(value) > 200) {
                          return 'Field cannot exceed 200';
                        }
                        return null;
                      },
                      controller: pressure,
                      title: 'Blood pressure',
                      hinttext: 'Blood pressure',
                      width: size.width - 20,
                      height: 50),
                  const SizedBox(height: 15),
                  inputformfield(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        if (int.parse(value) > 200) {
                          return 'Field cannot exceed 200';
                        }
                        return null;
                      },
                      controller: heartrate,
                      title: 'Heart rate',
                      hinttext: 'Heart rate',
                      width: size.width - 20,
                      height: 50),
                  const SizedBox(height: 15),
                  inputformfield(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        if (int.parse(value) > 200) {
                          return 'Field cannot exceed 200';
                        }
                        return null;
                      },
                      controller: oxygen,
                      title: 'Oxygen level',
                      hinttext: 'level of oxygen',
                      width: size.width - 20,
                      height: 50),
                  const SizedBox(height: 15),
                  inputformfield(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        if (int.parse(value) > 200) {
                          return 'Field cannot exceed 200';
                        }
                        return null;
                      },
                      controller: respiration,
                      title: 'Respiratory rate',
                      hinttext: 'Rate of respiration',
                      width: size.width - 20,
                      height: 50),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      inputformfield(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            if (int.parse(value) > 500) {
                              return 'Field cannot exceed 200';
                            }
                            return null;
                          },
                          controller: weight,
                          title: 'Weight',
                          hinttext: 'input weight in kilograms(kg)',
                          width: size.width * 0.36,
                          height: 50),
                      const Spacer(),
                      inputformfield(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            if (int.parse(value) > 250) {
                              return 'Field cannot exceed 250cm';
                            }
                            return null;
                          },
                          controller: height,
                          title: 'Height',
                          hinttext: 'input height in centimeters(cm)',
                          width: size.width * 0.36,
                          height: 50),
                    ],
                  ).px8(),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      bool validate = formkey.currentState!.validate();
                      if (validate == true) {
                        await bmical();

                        final vvmodel = VModel(
                          bloodpressure: pressure.text,
                          heartrate: heartrate.text,
                          oxygenlevel: oxygen.text,
                          temperature: temp.text,
                          datetime: DateFormat('EEEE').format(date),
                          weight: weight.text,
                          bmi: bmi.text,
                          id: Random().nextInt(150),
                          respiration: respiration.text,
                          height: height.text,
                        );

                        try {
                          await vController.addvital(vModel: vvmodel).then(
                              (value) => VxToast.show(context,
                                  msg: 'Vitals added successfully.',
                                  bgColor:
                                      const Color.fromARGB(255, 38, 99, 40),
                                  textColor: Colors.white,
                                  pdHorizontal: 30,
                                  pdVertical: 20));
                        } catch (e) {
                          rethrow;
                        } finally {
                          await bpp(double.parse(pressure.text.trim()));

                          bmi.clear();
                          respiration.clear();
                          height.clear();
                          temp.clear();
                          pressure.clear();
                          heartrate.clear();
                          oxygen.clear();
                          weight.clear();
                          Future.delayed(const Duration(milliseconds: 700), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Render()));
                          });
                        }
                      }
                    },
                    child: Container(
                        height: 50,
                        width: size.width - 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor),
                        child: const Center(
                          child: Text(
                            'Add vitals',
                            style: TextStyle(
                                fontFamily: 'Popb',
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ).animate().fadeIn(duration: 100.milliseconds, delay: 100.milliseconds),
    );
  }

  Future bpp(var bp) async {
    if (bp == 120) {
      NotifConsole().instantnotif(
          title: 'Blood Pressure', body: 'Your blood pressure is okay.');
    } else if (bp > 120 && bp <= 129) {
      NotifConsole().instantnotif(
          title: 'Blood Pressure',
          body: 'Take a moment to relax, your bp seem a bit abnormal');
    } else if (bp > 129 && bp <= 139) {
      NotifConsole().instantnotif(
          title: 'Blood Pressure',
          body: 'Take a short break and take deep breathes');
    } else if (bp > 139) {
      NotifConsole().instantnotif(
          title: 'Blood Pressure',
          body: 'Please contact your doctor on your blood pressure levels');
    }
  }

  Future bmical() async {
    if (weight.text.isNotEmpty && height.text.isNotEmpty) {
      var result = (double.parse(weight.text.trim()) /
          (double.parse(height.text.trim()).meterxs *
              double.parse(height.text.trim()).meterxs));

      setState(() {
        bmi.text = result.toStringAsFixed(1);
      });
    } else {
      setState(() {
        bmi.text = '0.0';
      });
    }
  }

  inputformfield({
    required String title,
    TextEditingController? controller,
    required String hinttext,
    FormFieldValidator? validator,
    double? width,
    double? height,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontFamily: 'Popb', fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black38,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width! - 30,
                  height: height,
                  child: TextFormField(
                    validator: validator,
                    autofocus: false,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                    keyboardType: TextInputType.number,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hinttext,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

extension on num {
  num get meterxs => this * 0.1;
}

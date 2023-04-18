import 'dart:math';

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
    final data1 = await VitalsDB.queryvital();
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const ImageIcon(
                    AssetImage('assets/icons/return-431-512.png'),
                    size: 25,
                    color: AppColors.primaryColor,
                  )),
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    width: size.width * 0.4,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        )),
                    child: const Center(
                      child: Text(
                        'Input manually',
                        style: TextStyle(
                            fontFamily: 'Pop',
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.42,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 240, 235, 214),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: const Center(
                      child: Text(
                        'Get from medbox',
                        style: TextStyle(fontFamily: 'Pop', fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    inputformfield(
                        controller: temp,
                        title: 'Temperature',
                        hinttext: 'Temperature',
                        width: size.width - 20,
                        height: 50),
                    const SizedBox(height: 15),
                    inputformfield(
                        controller: pressure,
                        title: 'Blood pressure',
                        hinttext: 'Blood pressure',
                        width: size.width - 20,
                        height: 50),
                    const SizedBox(height: 15),
                    inputformfield(
                        controller: heartrate,
                        title: 'Heart rate',
                        hinttext: 'Heart rate',
                        width: size.width - 20,
                        height: 50),
                    const SizedBox(height: 15),
                    inputformfield(
                        controller: oxygen,
                        title: 'Oxygen level',
                        hinttext: 'level of oxygen',
                        width: size.width - 20,
                        height: 50),
                    const SizedBox(height: 15),
                    inputformfield(
                        controller: respiration,
                        title: 'Respiratory rate',
                        hinttext: 'Rate of respiration',
                        width: size.width - 20,
                        height: 50),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        inputformfield(
                            controller: weight,
                            title: 'Weight',
                            hinttext: 'weight',
                            width: size.width * 0.36,
                            height: 50),
                        const Spacer(),
                        inputformfield(
                            controller: height,
                            title: 'Height',
                            hinttext: 'Height',
                            width: size.width * 0.36,
                            height: 50),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        await bmical();

                        bool validate = formkey.currentState!.validate();
                        if (validate == true) {
                          print(DateFormat('EEEE').format(date));
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
                            bmi.clear();
                            respiration.clear();
                            height.clear();
                            temp.clear();
                            pressure.clear();
                            heartrate.clear();
                            oxygen.clear();
                            weight.clear();

                            Future.delayed(const Duration(milliseconds: 700),
                                () {
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
              )
            ],
          ),
        ),
      ).animate().fadeIn(duration: 100.milliseconds, delay: 100.milliseconds),
    );
  }

  Future bmical() async {
    if (weight.text.isNotEmpty && height.text.isNotEmpty) {
      var result = (double.parse(weight.text) /
          (double.parse(height.text) * double.parse(height.text)));

      setState(() {
        bmi.text = result.toStringAsFixed(2);
      });
    } else {
      setState(() {
        bmi.text = '0.00';
      });
    }
  }

  inputformfield(
      {required String title,
      TextEditingController? controller,
      required String hinttext,
      double? width,
      double? height,
      Widget? widget}) {
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
                  width: width! - 67,
                  height: height,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
                    autofocus: false,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                    keyboardType: TextInputType.number,
                    controller: controller,
                    readOnly: widget == null ? false : true,
                    decoration: InputDecoration(
                      hintText: hinttext,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget ?? const SizedBox(),
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

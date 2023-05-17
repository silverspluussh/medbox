import 'dart:math';
import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
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
import '../../widgets/formfieldwidget.dart';

class AddVitals extends StatefulWidget {
  const AddVitals({Key key}) : super(key: key);

  @override
  State<AddVitals> createState() => _AddVitalsState();
}

class _AddVitalsState extends State<AddVitals> {
  var date = DateTime.now();
  TextEditingController temp = TextEditingController();
  TextEditingController pressure = TextEditingController();
  TextEditingController heartrate = TextEditingController();
  TextEditingController oxygen = TextEditingController();
  TextEditingController respiration = TextEditingController();

  VController vController = VController();
  List<Map<String, dynamic>> vitals = [];

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
        title: const Text('Add vitals', style: popheaderB),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Form(
                child: SizedBox(
                  width: size.width,
                  height: size.height * 0.7,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          if (int.parse(value) > 90) {
                            return 'Temperature cannot exceed 90';
                          }
                          return null;
                        },
                        controller: temp,
                        label: 'Temperature',
                        hinttext: 'eg. 35 degree celsius',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          if (int.parse(value) > 200) {
                            return 'Field cannot exceed 200';
                          }
                          return null;
                        },
                        controller: pressure,
                        label: 'Blood pressure',
                        hinttext: 'Blood pressure',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          if (int.parse(value) > 200) {
                            return 'Field cannot exceed 200';
                          }
                          return null;
                        },
                        controller: heartrate,
                        label: 'Heart rate',
                        hinttext: 'Heart rate',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          if (int.parse(value) > 200) {
                            return 'Field cannot exceed 200';
                          }
                          return null;
                        },
                        controller: oxygen,
                        label: 'Oxygen level',
                        hinttext: 'level of oxygen',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          if (int.parse(value) > 200) {
                            return 'Field cannot exceed 200';
                          }
                          return null;
                        },
                        controller: respiration,
                        label: 'Respiratory rate',
                        hinttext: 'Rate of respiration',
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          final vvmodel = VModel(
                            bloodpressure: pressure.text,
                            heartrate: heartrate.text,
                            oxygenlevel: oxygen.text,
                            temperature: temp.text,
                            datetime: DateFormat('EEEE').format(date),
                            id: Random().nextInt(150),
                            respiration: respiration.text,
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
                            respiration.clear();
                            temp.clear();
                            pressure.clear();
                            heartrate.clear();
                            oxygen.clear();
                            Future.delayed(const Duration(milliseconds: 700),
                                () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Render()));
                            });
                          }
                        },
                        child: Container(
                            height: 50,
                            width: size.width - 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryColor),
                            child: const Center(
                              child: Text('Add vitals', style: popwhite),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ).animate().fadeIn(duration: 100.milliseconds, delay: 100.milliseconds),
      ),
    );
  }
}

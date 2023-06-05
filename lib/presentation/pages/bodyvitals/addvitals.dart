import 'dart:math';
import 'package:flutter/material.dart';
import 'package:MedBox/presentation/pages/renderer.dart';
import 'package:MedBox/utils/extensions/vitalscontroller.dart';
import 'package:MedBox/domain/models/vitalsmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../widgets/formfieldwidget.dart';

class AddVitals extends StatefulWidget {
  const AddVitals({super.key});

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
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor: Colors.white,
        title:
            Text('Add vitals', style: Theme.of(context).textTheme.titleSmall),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Form(
                child: SizedBox(
                  height: size.height * 0.8,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        controller: temp,
                        label: 'Temperature',
                        hinttext: 'eg. 35 degree celsius',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        controller: pressure,
                        label: 'Blood pressure',
                        hinttext: 'Blood pressure',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        controller: heartrate,
                        label: 'Heart rate',
                        hinttext: 'Heart rate',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        controller: oxygen,
                        label: 'Oxygen level',
                        hinttext: 'level of oxygen',
                      ),
                      FormfieldX(
                        inputType: TextInputType.number,
                        readonly: false,
                        controller: respiration,
                        label: 'Respiratory rate',
                        hinttext: 'Rate of respiration',
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.6,
                        child: ElevatedButton(
                          onPressed: () async {
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
                          child: Text('Add vitals',
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ).animate().slideX(duration: 300.milliseconds, delay: 100.milliseconds),
    );
  }
}

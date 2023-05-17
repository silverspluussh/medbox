import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:MedBox/presentation/pages/bodyvitals/history_analysis.dart';
import 'package:MedBox/presentation/pages/bodyvitals/vscreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../../domain/models/vitalsmodel.dart';
import '../../widgets/formfieldwidget.dart';
import '../../widgets/radialbarchart.dart';
import 'addvitals.dart';

class VitalsDashboard extends StatefulWidget {
  const VitalsDashboard({Key key}) : super(key: key);

  @override
  State<VitalsDashboard> createState() => _VitalsDashboardState();
}

extension on num {
  num get meterxs => this * 0.1;
}

class _VitalsDashboardState extends State<VitalsDashboard> {
  String height;
  String weight;
  String bmi;
  String age;
  Color bpcolor = Colors.green;

  TextEditingController weightt = TextEditingController();
  TextEditingController heightt = TextEditingController();

  TextEditingController bp = TextEditingController();
  TextEditingController oxy = TextEditingController();
  TextEditingController respr = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController hr = TextEditingController();

  @override
  void initState() {
    age = SharedCli().getage() ?? '_';
    bmi = SharedCli().getbmi();
    weight = SharedCli().getweight();
    height = SharedCli().getheight();
    heightt.text = SharedCli().getheight();

    weightt.text = SharedCli().getweight();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
          future: VitalsDB().getvitals(),
          builder: (context, snap) {
            if (snap.hasData) {
              List<VModel> vitals = snap.data;

              return vitals.isNotEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Card(
                                      color: Colors.green,
                                      child: Semantics(
                                        button: true,
                                        child: InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Vitalshistory())),
                                          child: const Text('View stats',
                                                  style: popwhite)
                                              .p12(),
                                        ),
                                      )),
                                  Card(
                                      color: Colors.green,
                                      child: Semantics(
                                        button: true,
                                        child: InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddVitals())),
                                          child: const Text('Add new entry',
                                                  style: popwhite)
                                              .p12(),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            width: size.width,
                            height: size.height * 0.4,
                            child: VxSwiper(
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                items: [
                                  SizedBox(
                                    width: size.width,
                                    height: size.height * 0.4,
                                    child: Card(
                                        elevation: 0,
                                        color: Colors.white,
                                        child: RadialBarAngle(
                                          model: vitals,
                                        ).p16()),
                                  ),
                                  SizedBox(
                                    width: size.width,
                                    height: size.height * 0.4,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      child: SizedBox(
                                        width: size.width,
                                        height: size.height * 0.4,
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Image.asset(
                                              'assets/images/NicePng_human-figure-png_677858.png',
                                              height: size.height * 0.35,
                                              width: 100,
                                            ),
                                            SizedBox(
                                              height: size.height * 0.3,
                                              width: size.width * 0.42,
                                              child: Flex(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                direction: Axis.vertical,
                                                children: [
                                                  Text(
                                                    'AGE: $age years',
                                                    style: popheaderB,
                                                  ),
                                                  Text(
                                                    'BMI: $bmi m/kg2',
                                                    style: popheaderB,
                                                  ),
                                                  Text(
                                                    'Height: $height m',
                                                    style: popheaderB,
                                                  ),
                                                  Text(
                                                    'Weight: $weight kg',
                                                    style: popheaderB,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ).p8(),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              VitalBox(
                                suffix: const Text('Systolic',
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 13,
                                            fontFamily: 'Pop'))
                                    .px8(),
                                action: () => editdialog(context, size,
                                    controller: bp,
                                    label: 'Blood Pressure',
                                    action: () async => await VitalsDB()
                                        .updatepressure(bloodpressure: bp.text)
                                        .then((value) => context.pop())),
                                unit: 'mmHg',
                                title: 'Blood Pressure',
                                subtitle: vitals.isNotEmpty
                                    ? vitals.first.bloodpressure
                                    : '0.0',
                                leading: 'assets/icons/blood-pressure.png',
                              ),
                              VitalBox(
                                action: () => editdialog(context, size,
                                    controller: temp,
                                    label: 'Temperature',
                                    action: () => VitalsDB()
                                        .updatetemperature(temp: temp.text)
                                        .then((value) => context.pop())),
                                title: 'Temperature',
                                unit: 'degree celsius',
                                subtitle: vitals.isNotEmpty
                                    ? vitals.first.temperature
                                    : '25',
                                leading: 'assets/icons/temperature.png',
                              ),
                              VitalBox(
                                action: () => editdialog(context, size,
                                    controller: hr,
                                    label: 'Heart rate',
                                    action: () => VitalsDB()
                                        .updateheartrate(heartrate: hr.text)
                                        .then((value) => context.pop())),
                                title: 'Heart Rate',
                                leading: 'assets/icons/heartbeat.png',
                                unit: 'Bpm',
                                subtitle: vitals.isNotEmpty
                                    ? vitals.first.heartrate
                                    : '0.0',
                              ),
                              VitalBox(
                                action: () => editdialog(context, size,
                                    controller: oxy,
                                    label: 'Oxygen Level',
                                    action: () => VitalsDB()
                                        .updateolevel(oxygenlevel: oxy.text)
                                        .then((value) => context.pop())),
                                unit: '%',
                                subtitle: vitals.isNotEmpty
                                    ? vitals.first.oxygenlevel
                                    : '0.0',
                                leading:
                                    'assets/icons/6-medical-blood-oxygen.png',
                                title: 'Oxygen level',
                              ),
                              VitalBox(
                                action: () => editdialog(context, size,
                                    controller: respr,
                                    label: 'Respiration rate',
                                    action: () => VitalsDB()
                                        .updaterespiration(
                                            respiration: respr.text)
                                        .then((value) => context.pop())),
                                unit: 'bpm',
                                title: 'Respiration rate',
                                leading: 'assets/icons/health-12-512.png',
                                subtitle: vitals.isNotEmpty
                                    ? vitals.first.respiration
                                    : '0.0',
                              ),
                              VitalBox(
                                action: () => showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    alignment: Alignment.center,
                                    elevation: 5,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    insetPadding: const EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        width: size.width * 0.7,
                                        height: size.height * 0.35,
                                        child: Flex(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          direction: Axis.vertical,
                                          children: [
                                            const Text(
                                              'Add/Update Body Mass Index',
                                              style: popheaderB,
                                            ),
                                            FormfieldX(
                                              readonly: false,
                                              controller: heightt,
                                              hinttext:
                                                  SharedCli().getheight() ??
                                                      'weight in meters(m)',
                                              inputType: TextInputType.number,
                                              label: 'Height',
                                              validator: (e) {
                                                if (e.isEmpty) {
                                                  return 'Field cannot be empty';
                                                }
                                                return null;
                                              },
                                              prefixicon: const Icon(Icons
                                                  .monitor_weight_outlined),
                                            ),
                                            FormfieldX(
                                              validator: (e) {
                                                if (e.isEmpty) {
                                                  return 'Field cannot be empty';
                                                }
                                                return null;
                                              },
                                              readonly: false,
                                              controller: weightt,
                                              hinttext:
                                                  SharedCli().getweight() ??
                                                      '0.0',
                                              inputType: TextInputType.number,
                                              label: 'Weight',
                                              prefixicon: const Icon(
                                                  Icons.height_outlined),
                                            ),
                                            SizedBox(
                                              child: InkWell(
                                                onTap: () {
                                                  bmical().then((value) {
                                                    save().then((value) {
                                                      setState(() {
                                                        context.pop();
                                                      });
                                                    });
                                                  });
                                                },
                                                child: Card(
                                                  color: AppColors.primaryColor,
                                                  child: const Text(
                                                          'Update bmi',
                                                          style: popwhite)
                                                      .p16(),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                unit: 'kg/m2',
                                subtitle: SharedCli().getbmi() ?? '0.0',
                                leading: 'assets/icons/health-12-512.png',
                                title: 'Body Mass Index',
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : nodata(size, context);
            }
            return const SizedBox();
          }),
    );
  }

  Future<dynamic> editdialog(
    BuildContext context,
    Size size, {
    label,
    controller,
    VoidCallback action,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        alignment: Alignment.center,
        elevation: 5,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: size.width * 0.7,
            height: size.height * 0.2,
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              direction: Axis.vertical,
              children: [
                FormfieldX(
                  readonly: false,
                  controller: controller,
                  hinttext: controller.text,
                  inputType: TextInputType.number,
                  label: label,
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    return null;
                  },
                  prefixicon: const Icon(Icons.monitor_weight_outlined),
                ),
                SizedBox(
                  child: InkWell(
                    onTap: action,
                    child: Card(
                      color: AppColors.primaryColor,
                      child: const Text('Update', style: popwhite).p16(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future save() async {
    await SharedCli().setheights(value: heightt.text);
    await SharedCli().setweight(value: weightt.text);
    await SharedCli().setbmi(value: bmi);
  }

  Future bmical() async {
    if (weightt.text.isNotEmpty && heightt.text.isNotEmpty) {
      var result = (double.parse(weightt.text.trim()) /
          (double.parse(heightt.text.trim()).meterxs *
              double.parse(heightt.text.trim()).meterxs));

      setState(() {
        bmi = result.toStringAsFixed(1);
      });
    } else {
      setState(() {
        bmi = '0.0';
      });
    }
  }
}

nodata(Size size, BuildContext context) {
  return Center(
    child: Column(
      children: [
        Lottie.asset(
          'assets/lottie/empty.json',
          height: size.height * 0.35,
          width: size.width * 0.3,
        ),
        const SizedBox(height: 20),
        const Text(
          "No health data added at the moment.\nYou can change that tapping on the edit button.",
          textAlign: TextAlign.center,
          style: popblack,
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: size.width * 0.6,
          height: 50,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddVitals())),
              child: Card(
                color: AppColors.primaryColor,
                elevation: 5,
                child:
                    const Text('ADD VITALS', style: popwhite).centered().px16(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

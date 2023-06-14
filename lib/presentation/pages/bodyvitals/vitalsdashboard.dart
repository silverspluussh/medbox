import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:MedBox/presentation/pages/bodyvitals/vscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../../domain/models/vitalsmodel.dart';
import '../../widgets/formfieldwidget.dart';
import '../../widgets/radialbarchart.dart';
import 'addvitals.dart';

class VitalsDashboard extends StatefulWidget {
  const VitalsDashboard({super.key});

  @override
  State<VitalsDashboard> createState() => _VitalsDashboardState();
}

extension on num {
  num get meterxs => this * 0.1;
}

class _VitalsDashboardState extends State<VitalsDashboard> {
  String? height;
  String? weight;
  String? bmi;
  String? age;
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
    age = SharedCli().getage() ?? '0';
    bmi = SharedCli().getbmi() ?? '0';
    weight = SharedCli().getweight() ?? '0';
    height = SharedCli().getheight() ?? '0';
    heightt.text = SharedCli().getheight() ?? '0.0';

    weightt.text = SharedCli().getweight() ?? '0.0';

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
              List<VModel> vitals = snap.data!;

              return vitals.isNotEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: 50,
                              child: Card(
                                  color: Colors.green,
                                  child: Semantics(
                                    button: true,
                                    child: InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddVitals())),
                                      child: Text('Add new entry',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall)
                                          .p12(),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: VxSwiper(
                              autoPlay: false,
                              enableInfiniteScroll: false,
                              items: [
                                Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    child: RadialBarAngle(
                                      model: vitals,
                                    ).p16()),
                                Card(
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
                                            width: size.width * 0.4,
                                            child: Flex(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              direction: Axis.vertical,
                                              children: [
                                                Text(
                                                  'AGE: $age years',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  'BMI: $bmi m/kg2',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  'Height: $height m',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  'Weight: $weight kg',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                              ]),
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
                                    ? vitals.first.bloodpressure!
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
                                    ? vitals.first.temperature!
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
                                    ? vitals.first.heartrate!
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
                                    ? vitals.first.oxygenlevel!
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
                                    ? vitals.first.respiration!
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
                                            Text(
                                              'Add/Update Body Mass Index',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            FormfieldX(
                                              readonly: false,
                                              controller: heightt,
                                              hinttext: SharedCli().getheight(),
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
                                              hinttext: SharedCli().getweight(),
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
                                                  color: kprimary,
                                                  child: Text('Update bmi',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall)
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
                                subtitle: SharedCli().getbmi(),
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
    ).animate().slideX(duration: 300.milliseconds, delay: 100.milliseconds);
  }

  Future<dynamic> editdialog(
    BuildContext context,
    Size size, {
    label,
    controller,
    VoidCallback? action,
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
                  height: 50,
                  child: TextButton(
                    onPressed: action,
                    child: Text('Update',
                        style: Theme.of(context).textTheme.titleSmall),
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
          height: size.height * 0.32,
          width: size.width * 0.3,
        ),
        const SizedBox(height: 20),
        Text(
          "No health data added at the moment.\nYou can change that tapping on the edit button.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: size.width * 0.6,
          child: ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddVitals())),
            child: Text('ADD VITALS',
                    style: Theme.of(context).textTheme.titleSmall)
                .centered()
                .px16(),
          ),
        ),
      ],
    ),
  );
}

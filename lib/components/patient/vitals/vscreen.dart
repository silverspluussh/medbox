import 'package:MedBox/components/patient/vitals/vitalsmodel.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/artifacts/Dbhelpers/vitalsdb.dart';
import 'package:MedBox/artifacts/colors.dart';
import 'package:MedBox/components/patient/vitals/addvitals.dart';
import 'package:MedBox/main.dart';
import 'package:lottie/lottie.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  String username = '';

  bool loading = true;
  void referesh() async {
    username = prefs.getString('username') ??
        prefs.getString('googlename') ??
        'No username set';
  }

  @override
  void initState() {
    referesh();
    super.initState();
  }

//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          Container(
            height: size.height * 0.24,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/6009667.jpg',
                    ),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Good day, ',
                  style: TextStyle(
                      fontFamily: 'Popb',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white30),
                ),
                const SizedBox(height: 5),
                Text(
                  username,
                  style: const TextStyle(
                      fontFamily: 'Popb',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
              top: size.height * 0.18,
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: FutureBuilder(
                    future: VitalsDB().getvitals(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        List<VModel>? vitals = snapshot.data;
                        return vitals!.isNotEmpty
                            ? ListView(
                                physics: const BouncingScrollPhysics(),
                                // padding: const EdgeInsets.symmetric(horizontal: 25),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 220.0,
                                              color: Colors.white,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Blood Pressure',
                                                      size: 12.0,
                                                      color: Colors.black),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text: vitals
                                                                  .isNotEmpty
                                                              ? vitals[0]
                                                                  .bloodpressure
                                                              : '0.0',
                                                          color: Colors.black,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: 'mmHg',
                                                          color: Colors.black12,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                  Image.asset(
                                                      'assets/images/bldpre.png',
                                                      color: Colors.green)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 125.0,
                                              color: Colors.white,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Body temperature',
                                                      size: 12.0,
                                                      color: Colors.black),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text: vitals
                                                                  .isNotEmpty
                                                              ? vitals[0]
                                                                  .temperature
                                                              : '25',
                                                          color: Colors.black,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: 'deg-celsius',
                                                          color: Colors.black12,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 120.0,
                                              color: Colors.white,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Oxygen level',
                                                      size: 12.0,
                                                      color: Colors.black),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text: vitals
                                                                  .isNotEmpty
                                                              ? vitals[0]
                                                                  .oxygenlevel
                                                              : '0.0',
                                                          color: Colors.black,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: '%',
                                                          color: Colors.black12,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 110.0,
                                              color: Colors.white,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Respiration rate',
                                                      size: 12.0,
                                                      color: Colors.black),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text: vitals
                                                                  .isNotEmpty
                                                              ? vitals[0]
                                                                  .respiration
                                                              : '0.0',
                                                          color: Colors.black,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: 'bpm',
                                                          color: Colors.black12,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 200.0,
                                              color: AppColors.primaryColor,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Heart Rate',
                                                      size: 12.0,
                                                      color: Colors.white),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text:
                                                              vitals.isNotEmpty
                                                                  ? vitals[0]
                                                                      .heartrate
                                                                  : '0.0',
                                                          color: Colors.white,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: 'bpm',
                                                          color: Colors.white,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                  Image.asset(
                                                      'assets/images/bldpre.png',
                                                      color: Colors.green)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 140.0,
                                              color: Colors.white,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Weight',
                                                      size: 12.0,
                                                      color: Colors.black),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text: vitals
                                                                  .isNotEmpty
                                                              ? vitals[0].weight
                                                              : '0.0',
                                                          color: Colors.black,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: 'kg',
                                                          color: Colors.black12,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 130.0,
                                              color: Colors.white,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Body Mass Index',
                                                      size: 12.0,
                                                      color: Colors.black),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text: vitals
                                                                  .isNotEmpty
                                                              ? vitals[0].bmi
                                                              : '0.0',
                                                          color: Colors.black,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: 'kg/m2',
                                                          color: Colors.black12,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            VitalBox(
                                              width: size.width * 0.4,
                                              height: 120.0,
                                              color: Colors.white,
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _cardtext(
                                                      text: 'Height',
                                                      size: 12.0,
                                                      color: Colors.black),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      _cardtext(
                                                          text: vitals
                                                                  .isNotEmpty
                                                              ? vitals[0].height
                                                              : '0.0',
                                                          color: Colors.black,
                                                          size: 15.0),
                                                      const SizedBox(width: 5),
                                                      _cardtext(
                                                          text: 'm',
                                                          color: Colors.black12,
                                                          size: 11.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 150)
                                ],
                              )
                            : SizedBox(
                                width: size.width - 90,
                                height: size.height * 0.5,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Lottie.asset('assets/lottie/empty.json',
                                          height: size.height * 0.35,
                                          width: size.width * 0.3,
                                          animate: true,
                                          reverse: true),
                                      const SizedBox(height: 20),
                                      const Text(
                                        "No health data added at the moment.\nYou can change that tapping on the edit button.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Pop',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ));
                        ;
                      }
                      if (!snapshot.hasData) {}
                      return SizedBox(
                        width: size.width,
                        height: size.height * 0.8,
                        child: const Text(
                          'Vitals not set at the moment',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      );
                    })),
              )),
          Positioned(
              bottom: 100,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddVitals()));
                },
                onLongPress: () {},
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withOpacity(0.6)),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future<Object?> vitaldialog(BuildContext context, {required Widget widget}) =>
      showGeneralDialog(
          barrierDismissible: true,
          barrierLabel: 'sd',
          context: context,
          pageBuilder: (context, _, __) {
            return widget;
          });

  Text _cardtext({required text, required color, required size}) {
    return Text(
      text,
      style:
          TextStyle(fontSize: size, fontWeight: FontWeight.w500, color: color),
    );
  }
}

class VitalBox extends StatelessWidget {
  const VitalBox({
    super.key,
    this.width,
    this.height,
    required this.color,
    this.widget,
  });
  final width;
  final height;
  final Color color;
  final widget;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10)],
          color: color,
          borderRadius: BorderRadius.circular(15)),
      child: widget,
    );
  }
}

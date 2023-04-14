import 'package:MedBox/domain/models/vitalsmodel.dart';
import 'package:MedBox/presentation/widgets/sliverpersistentheader.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/data/repos/Dbhelpers/vitalsdb.dart';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/pages/bodyvitals/addvitals.dart';
import 'package:MedBox/main.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class VitalsMain extends StatefulWidget {
  const VitalsMain({super.key});

  @override
  State<VitalsMain> createState() => _VitalsMainState();
}

class _VitalsMainState extends State<VitalsMain> {
  //Texteditingcontroller for each vital

  late TextEditingController temperature;
  late TextEditingController pressure;
  late TextEditingController heartrate;
  late TextEditingController weight;
  late TextEditingController oxygenlevel;
  late TextEditingController respirationrate;
  late TextEditingController height;

  //
  //
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

    return FutureBuilder(
        future: VitalsDB().getvitals(),
        builder: (context, snapshot) {
          List<VModel>? vitals = snapshot.data;
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                        delegate: HeaderBar(
                            Container(
                              height: size.height * 0.24,
                              width: size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
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
                            size.height * 0.24,
                            50)),
                    snapshot.hasData
                        ? vitals!.isNotEmpty
                            ? SliverGrid.count(crossAxisCount: 2, children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    VitalBox(
                                      callback: () => _editvitaldialog(
                                        context,
                                        size,
                                        controller: height,
                                        image: 'assets/images/bldpre.png',
                                        saveCallback: () {},
                                        title: 'Blood Pressure',
                                      ),
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
                                                  text: vitals.isNotEmpty
                                                      ? vitals[0].bloodpressure
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
                                      callback: () => _editvitaldialog(
                                        context,
                                        size,
                                        controller: height,
                                        image: 'assets/icons/temperature.png',
                                        saveCallback: () {},
                                        title: 'Temperature',
                                      ),
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
                                                  text: vitals.isNotEmpty
                                                      ? vitals[0].temperature
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
                                      callback: () => _editvitaldialog(
                                        context,
                                        size,
                                        controller: height,
                                        image:
                                            'assets/icons/6-medical-blood-oxygen.png',
                                        saveCallback: () {},
                                        title: 'Oxygen Level',
                                      ),
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
                                                  text: vitals.isNotEmpty
                                                      ? vitals[0].oxygenlevel
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
                                      callback: () => _editvitaldialog(
                                        context,
                                        size,
                                        controller: height,
                                        image: 'assets/icons/health-12-512.png',
                                        saveCallback: () {},
                                        title: 'Respiration rate',
                                      ),
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
                                                  text: vitals.isNotEmpty
                                                      ? vitals[0].respiration
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
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    VitalBox(
                                      callback: () => _editvitaldialog(
                                        context,
                                        size,
                                        controller: height,
                                        image: 'assets/icons/heart-beat.png',
                                        saveCallback: () {},
                                        title: 'Heart Rate',
                                      ),
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
                                                  text: vitals.isNotEmpty
                                                      ? vitals[0].heartrate
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
                                              'assets/images/blassets/icons/temperature.pngdpre.png',
                                              color: Colors.green)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    VitalBox(
                                      callback: () => _editvitaldialog(
                                        context,
                                        size,
                                        controller: height,
                                        image: 'assets/icons/health-12-512.png',
                                        saveCallback: () {},
                                        title: 'Weight',
                                      ),
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
                                                  text: vitals.isNotEmpty
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
                                      callback: () {},
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
                                                  text: vitals.isNotEmpty
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
                                      callback: () => _editvitaldialog(
                                        context,
                                        size,
                                        controller: height,
                                        image: 'assets/icons/health-12-512.png',
                                        saveCallback: () {},
                                        title: 'Height',
                                      ),
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
                                                  text: vitals.isNotEmpty
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
                              ])
                            : const SizedBox()
                        : const SizedBox(),
                  ],
                ),
                Positioned(
                    bottom: 100,
                    right: 20,
                    child: SizedBox(
                      height: 80,
                      width: size.width,
                      child: Row(
                        children: [
                          Semantics(
                            button: true,
                            tooltip: 'Overall vitals history',
                            child: InkWell(
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        const Color.fromARGB(255, 61, 228, 55)
                                            .withOpacity(0.6)),
                                child: const Icon(
                                  Icons.bar_chart_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddVitals()));
                            },
                            onLongPress: () {},
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      AppColors.primaryColor.withOpacity(0.6)),
                              child: const Icon(
                                Icons.addchart_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).px8())
              ],
            ),
          );
        });
  }
}

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  //Texteditingcontroller for each vital

  late TextEditingController temperature;
  late TextEditingController pressure;
  late TextEditingController heartrate;
  late TextEditingController weight;
  late TextEditingController oxygenlevel;
  late TextEditingController respirationrate;
  late TextEditingController height;

  //
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
                                              callback: () => _editvitaldialog(
                                                context,
                                                size,
                                                controller: height,
                                                image:
                                                    'assets/images/bldpre.png',
                                                saveCallback: () {},
                                                title: 'Blood Pressure',
                                              ),
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
                                              callback: () => _editvitaldialog(
                                                context,
                                                size,
                                                controller: height,
                                                image:
                                                    'assets/icons/temperature.png',
                                                saveCallback: () {},
                                                title: 'Temperature',
                                              ),
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
                                              callback: () => _editvitaldialog(
                                                context,
                                                size,
                                                controller: height,
                                                image:
                                                    'assets/icons/6-medical-blood-oxygen.png',
                                                saveCallback: () {},
                                                title: 'Oxygen Level',
                                              ),
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
                                              callback: () => _editvitaldialog(
                                                context,
                                                size,
                                                controller: height,
                                                image:
                                                    'assets/icons/health-12-512.png',
                                                saveCallback: () {},
                                                title: 'Respiration rate',
                                              ),
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
                                              callback: () => _editvitaldialog(
                                                context,
                                                size,
                                                controller: height,
                                                image:
                                                    'assets/icons/heart-beat.png',
                                                saveCallback: () {},
                                                title: 'Heart Rate',
                                              ),
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
                                                      'assets/images/blassets/icons/temperature.pngdpre.png',
                                                      color: Colors.green)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            VitalBox(
                                              callback: () => _editvitaldialog(
                                                context,
                                                size,
                                                controller: height,
                                                image:
                                                    'assets/icons/health-12-512.png',
                                                saveCallback: () {},
                                                title: 'Weight',
                                              ),
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
                                              callback: () {},
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
                                              callback: () => _editvitaldialog(
                                                context,
                                                size,
                                                controller: height,
                                                image:
                                                    'assets/icons/health-12-512.png',
                                                saveCallback: () {},
                                                title: 'Height',
                                              ),
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
                                      Lottie.asset(
                                        'assets/lottie/empty.json',
                                        height: size.height * 0.35,
                                        width: size.width * 0.3,
                                      ),
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
              child: SizedBox(
                height: 80,
                width: size.width,
                child: Row(
                  children: [
                    Semantics(
                      button: true,
                      tooltip: 'Overall vitals history',
                      child: InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 61, 228, 55)
                                  .withOpacity(0.6)),
                          child: const Icon(
                            Icons.bar_chart_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddVitals()));
                      },
                      onLongPress: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor.withOpacity(0.6)),
                        child: const Icon(
                          Icons.addchart_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ).px8())
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
}

Text _cardtext({required text, required color, required size}) {
  return Text(
    text,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.w500, color: color),
  );
}

Future<dynamic> _editvitaldialog(BuildContext context, Size size,
    {required controller,
    required title,
    required image,
    required VoidCallback saveCallback}) {
  return showDialog(
      barrierDismissible: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
            width: size.width,
            height: size.height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 10)
              ],
              color: Colors.white,
            ),
            child: VStack([
              ListTile(
                leading: Image.asset(image),
                title: Text(title),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: size.width * 0.25,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: saveCallback,
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.primaryColor),
                  child: const Text('Save entry').centered(),
                ),
              )
            ]));
      });
}

class VitalBox extends StatelessWidget {
  const VitalBox({
    super.key,
    this.width,
    this.height,
    required this.color,
    required this.callback,
    this.widget,
  });
  final width;
  final height;
  final Color color;
  final VoidCallback callback;
  final widget;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10)],
            color: color,
            borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            widget,
            Positioned(
                top: 3,
                right: 3,
                child: IconButton(
                  onPressed: callback,
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ))
          ],
        ));
  }
}

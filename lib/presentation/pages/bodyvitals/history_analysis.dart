import 'dart:developer';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/data/repos/Dbhelpers/vitalsdb.dart';
import 'package:MedBox/presentation/pages/bodyvitals/vitalstable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../domain/models/vitalsmodel.dart';
import '../../widgets/fl_linechart.dart';

class Vitalshistory extends StatefulWidget {
  const Vitalshistory({super.key});

  @override
  State<Vitalshistory> createState() => _VitalshistoryState();
}

class _VitalshistoryState extends State<Vitalshistory> {
  List<VModel> getvitals = [];
  List<Map<String, dynamic>> avgQuery = [];
  List<Map<String, dynamic>> minQuery = [];
  List<Map<String, dynamic>> maxQuery = [];

  List<Map<String, dynamic>> weeklyQuery1 = [];
  List<Map<String, dynamic>> weeklyQuery2 = [];
  List<Map<String, dynamic>> weeklyQuery3 = [];
  List<Map<String, dynamic>> weeklyQuery4 = [];
  List<Map<String, dynamic>> weeklyQuery5 = [];
  List<Map<String, dynamic>> weeklyQuery6 = [];
  List<Map<String, dynamic>> weeklyQuery7 = [];

  @override
  void initState() {
    overallQuery();

    super.initState();
  }

  Future overallQuery() async {
    try {
      await VitalsDB().getvitals().then((value) {
        setState(() {
          getvitals = value;
        });
      });

      await VitalsDB().avgquery().then((value) {
        setState(() {
          avgQuery = value;
        });
      });

      await VitalsDB().minquery().then((value) {
        minQuery = value;
      });

      await VitalsDB().maxquery().then((value) {
        maxQuery = value;
      });

      await VitalsDB().weeklyreadings(day: 'Monday').then((value) {
        setState(() {
          weeklyQuery1 = value;
        });
      });

      await VitalsDB().weeklyreadings(day: 'Tuesday').then((value) {
        setState(() {
          weeklyQuery2 = value;
        });
      });

      await VitalsDB().weeklyreadings(day: 'Wednesday').then((value) {
        weeklyQuery3 = value;
      });

      await VitalsDB().weeklyreadings(day: 'Thursday').then((value) {
        weeklyQuery4 = value;
      });

      await VitalsDB().weeklyreadings(day: 'Friday').then((value) {
        weeklyQuery5 = value;
      });
      await VitalsDB().weeklyreadings(day: 'Saturday').then((value) {
        weeklyQuery6 = value;
      });
      await VitalsDB().weeklyreadings(day: 'Sunday').then((value) {
        weeklyQuery7 = value;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                tooltip: 'View table chart for all health vitals',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VitalsTable()));
                },
                icon: const Icon(Icons.grid_on_sharp),
                iconSize: 25,
                color: AppColors.primaryColor,
              )
            ],
            centerTitle: true,
            title: const Text('Health Overview',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  fontFamily: 'Popb',
                  color: Colors.black,
                )),
            bottom: TabBar(
              key: const ObjectKey('tabbar'),
              tabs: [
                ...icons.map((e) => Tab(
                      icon: ImageIcon(AssetImage(e)),
                    )),
              ],
            ),
          ),
          body: FutureBuilder(
              future: VitalsDB().weeklyreadings(day: 'Friday'),
              builder: (context, snapshot) {
                return TabBarView(key: const ObjectKey('tabview'), children: [
                  CustomScrollView(
                    key: const ValueKey(0),
                    slivers: [
                      circularcardsliver(size,
                          value:
                              '${getvitals.isEmpty ? 0.0 : getvitals.last.temperature}',
                          unit: 'deg.celsius'),
                      minavgmax(
                        size,
                        color2: Colors.black,
                        color: AppColors.primaryColor,
                        avgtitle: 'AVG',
                        avgvalue:
                            "${avgQuery[0]['temperature'].toStringAsFixed(2)}",
                        maxtitle: 'MAX',
                        maxvalue: "${maxQuery[0]['temperature']}",
                        mintitle: 'MIN',
                        minvalue: "${minQuery[0]['temperature']}",
                      ),
                      SliverToBoxAdapter(
                        child: Linechart(flspots: [
                          const FlSpot(0, 0),
                          FlSpot(
                              1,
                              weeklyQuery1.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery1[0]['temperature']}')),
                          FlSpot(
                              2,
                              weeklyQuery2.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery2.last['temperature']}')),
                          FlSpot(
                              3,
                              weeklyQuery3.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery3[0]['temperature']}')),
                          FlSpot(
                              4,
                              weeklyQuery4.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery4[0]['temperature']}')),
                          FlSpot(
                              5,
                              weeklyQuery5.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery5[0]['temperature']}')),
                          FlSpot(
                              6,
                              weeklyQuery6.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery6[0]['temperature']}')),
                          FlSpot(
                              7,
                              weeklyQuery7.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery7[0]['temperature']}')),
                        ]),
                      )
                    ],
                  ),
                  CustomScrollView(
                    key: const ValueKey(1),
                    slivers: [
                      circularcardsliver(size,
                          value:
                              '${getvitals.isEmpty ? 0.0 : getvitals.last.bloodpressure}',
                          unit: 'mmHg'),
                      minavgmax(
                        size,
                        color2: Colors.black,
                        color: AppColors.primaryColor,
                        avgtitle: 'AVG',
                        avgvalue:
                            "${avgQuery[0]['bloodpressure'].toStringAsFixed(2)}",
                        maxtitle: 'MAX',
                        maxvalue: "${maxQuery[0]['bloodpressure']}",
                        mintitle: 'MIN',
                        minvalue: "${minQuery[0]['bloodpressure']}",
                      ),
                      SliverToBoxAdapter(
                        child: Linechart(flspots: [
                          const FlSpot(0, 0),
                          FlSpot(
                              1,
                              weeklyQuery1.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery1[0]['bloodpressure']}')),
                          FlSpot(
                              2,
                              weeklyQuery2.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery2.last['bloodpressure']}')),
                          FlSpot(
                              3,
                              weeklyQuery3.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery3[0]['bloodpressure']}')),
                          FlSpot(
                              4,
                              weeklyQuery4.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery4[0]['bloodpressure']}')),
                          FlSpot(
                              5,
                              weeklyQuery5.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery5[0]['bloodpressure']}')),
                          FlSpot(
                              6,
                              weeklyQuery6.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery6[0]['bloodpressure']}')),
                          FlSpot(
                              7,
                              weeklyQuery7.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery7[0]['bloodpressure']}')),
                        ]),
                      )
                    ],
                  ),
                  CustomScrollView(
                    key: const ValueKey(2),
                    slivers: [
                      circularcardsliver(size,
                          value:
                              '${getvitals.isEmpty ? 0.0 : getvitals.last.heartrate}',
                          unit: 'bpm'),
                      minavgmax(
                        size,
                        color2: Colors.black,
                        color: AppColors.primaryColor,
                        avgtitle: 'AVG',
                        avgvalue:
                            "${avgQuery[0]['heartrate'].toStringAsFixed(2)}",
                        maxtitle: 'MAX',
                        maxvalue: "${maxQuery[0]['heartrate']}",
                        mintitle: 'MIN',
                        minvalue: "${minQuery[0]['heartrate']}",
                      ),
                      SliverToBoxAdapter(
                        child: Linechart(flspots: [
                          const FlSpot(0, 0),
                          FlSpot(
                              1,
                              weeklyQuery1.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery1[0]['heartrate']}')),
                          FlSpot(
                              2,
                              weeklyQuery2.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery2.last['heartrate']}')),
                          FlSpot(
                              3,
                              weeklyQuery3.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery3[0]['heartrate']}')),
                          FlSpot(
                              4,
                              weeklyQuery4.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery4[0]['heartrate']}')),
                          FlSpot(
                              5,
                              weeklyQuery5.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery5[0]['heartrate']}')),
                          FlSpot(
                              6,
                              weeklyQuery6.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery6[0]['heartrate']}')),
                          FlSpot(
                              7,
                              weeklyQuery7.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery7[0]['heartrate']}')),
                        ]),
                      )
                    ],
                  ),
                  CustomScrollView(
                    key: const ValueKey(3),
                    slivers: [
                      circularcardsliver(size,
                          value:
                              '${getvitals.isEmpty ? 0.0 : getvitals.last.oxygenlevel}',
                          unit: '%'),
                      minavgmax(
                        size,
                        color2: Colors.black,
                        color: AppColors.primaryColor,
                        avgtitle: 'AVG',
                        avgvalue:
                            "${avgQuery[0]['oxygenlevel'].toStringAsFixed(2)}",
                        maxtitle: 'MAX',
                        maxvalue: "${maxQuery[0]['oxygenlevel']}",
                        mintitle: 'MIN',
                        minvalue: "${minQuery[0]['oxygenlevel']}",
                      ),
                      SliverToBoxAdapter(
                        child: Linechart(flspots: [
                          const FlSpot(0, 0),
                          FlSpot(
                              1,
                              weeklyQuery1.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery1[0]['oxygenlevel']}')),
                          FlSpot(
                              2,
                              weeklyQuery2.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery2.last['oxygenlevel']}')),
                          FlSpot(
                              3,
                              weeklyQuery3.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery3[0]['oxygenlevel']}')),
                          FlSpot(
                              4,
                              weeklyQuery4.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery4[0]['oxygenlevel']}')),
                          FlSpot(
                              5,
                              weeklyQuery5.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery5[0]['oxygenlevel']}')),
                          FlSpot(
                              6,
                              weeklyQuery6.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery6[0]['oxygenlevel']}')),
                          FlSpot(
                              7,
                              weeklyQuery7.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery7[0]['oxygenlevel']}')),
                        ]),
                      )
                    ],
                  ),
                  CustomScrollView(
                    key: const ValueKey(4),
                    slivers: [
                      circularcardsliver(size,
                          value:
                              '${getvitals.isEmpty ? 0.0 : getvitals.last.respiration}',
                          unit: 'bpm'),
                      minavgmax(
                        size,
                        color2: Colors.black,
                        color: AppColors.primaryColor,
                        avgtitle: 'AVG',
                        avgvalue:
                            "${avgQuery[0]['respiration'].toStringAsFixed(2)}",
                        maxtitle: 'MAX',
                        maxvalue: "${maxQuery[0]['respiration']}",
                        mintitle: 'MIN',
                        minvalue: "${minQuery[0]['respiration']}",
                      ),
                      SliverToBoxAdapter(
                        child: Linechart(flspots: [
                          const FlSpot(0, 0),
                          FlSpot(
                              1,
                              weeklyQuery1.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery1[0]['respiration']}')),
                          FlSpot(
                              2,
                              weeklyQuery2.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery2.last['respiration']}')),
                          FlSpot(
                              3,
                              weeklyQuery3.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery3[0]['respiration']}')),
                          FlSpot(
                              4,
                              weeklyQuery4.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery4[0]['respiration']}')),
                          FlSpot(
                              5,
                              weeklyQuery5.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery5[0]['respiration']}')),
                          FlSpot(
                              6,
                              weeklyQuery6.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery6[0]['respiration']}')),
                          FlSpot(
                              7,
                              weeklyQuery7.isEmpty
                                  ? 0
                                  : double.parse(
                                      '${weeklyQuery7[0]['respiration']}')),
                        ]),
                      )
                    ],
                  ),
                ]);
              }),
        ));
  }

  SliverToBoxAdapter minavgmax(Size size,
      {required Color color,
      required color2,
      required mintitle,
      required minvalue,
      required avgtitle,
      required avgvalue,
      required maxtitle,
      required maxvalue}) {
    return SliverToBoxAdapter(
      child: Container(
          width: size.width - 20,
          height: size.height * 0.2,
          margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(30),
          ),
          child: VxGlassmorphic(
            blur: 0,
            circularRadius: 5,
            shadowStrength: 0,
            opacity: 0.5,
            height: size.height * 0.2,
            width: size.width - 20,
            child: HStack(
              [
                minmaxavgelement(
                  title: mintitle,
                  tcolor: Colors.blue,
                  vcolor: color2,
                  value: minvalue,
                ),
                const SizedBox(width: 40),
                minmaxavgelement(
                  title: avgtitle,
                  tcolor: color,
                  vcolor: color2,
                  value: avgvalue,
                ),
                const SizedBox(width: 40),
                minmaxavgelement(
                  title: maxtitle,
                  tcolor: Colors.red,
                  vcolor: color2,
                  value: maxvalue,
                ),
              ],
              alignment: MainAxisAlignment.spaceBetween,
            ).px12().py12(),
          )),
    );
  }

  minmaxavgelement(
      {required Color tcolor,
      required Color vcolor,
      required title,
      required value}) {
    return Card(
      elevation: 10,
      child: VStack([
        Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: 'Popb',
              color: tcolor,
            )),
        const SizedBox(height: 30),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: vcolor,
                fontFamily: 'Pop')),
        const SizedBox(height: 20),
        Divider(color: AppColors.primaryColor.withOpacity(0.6), thickness: 1),
      ]).px20().py8(),
    );
  }

  SliverToBoxAdapter circularcardsliver(Size size,
      {required value, required unit}) {
    return SliverToBoxAdapter(
      child: Container(
        width: size.width * 0.5,
        height: size.height * 0.22,
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Lottie.asset(
              'assets/lottie/140890-blink.json',
              width: size.width * 0.46,
              height: size.height * 0.23,
            ).centered(),
            Container(
              width: size.width * 0.43,
              height: size.height * 0.2,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2,
                      color: AppColors.primaryColor.withOpacity(0.6))),
              child: VStack(
                [
                  Text(value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Popb',
                        color: Colors.white,
                      )),
                  const SizedBox(height: 10),
                  Text(unit,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: 'Pop',
                        color: Colors.white,
                      )),
                ],
                alignment: MainAxisAlignment.center,
                crossAlignment: CrossAxisAlignment.center,
              ).centered(),
            ).centered()
          ],
        ),
      ),
    );
  }
}

List icons = [
  'assets/icons/temperature.png',
  'assets/icons/blood-pressure.png',
  'assets/icons/heartbeat.png',
  'assets/icons/6-medical-blood-oxygen.png',
  'assets/icons/heart-beat.png',
];

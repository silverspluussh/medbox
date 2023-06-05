import 'dart:developer';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/data/repos/Dbhelpers/vitalsdb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

      setState(() {});
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
            centerTitle: true,
            title: Text('Health Overview',
                style: Theme.of(context).textTheme.titleSmall),
            bottom: TabBar(
              tabs: [
                ...icons.map((e) => Tab(
                      icon: ImageIcon(AssetImage(e)),
                    )),
              ],
            ),
          ),
          body: FutureBuilder(
                  future: VitalsDB().avgquery(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: kprimary, strokeWidth: 5),
                      );
                    }
                    return snapshot.data!.isNotEmpty
                        ? TabBarView(
                            key: const ObjectKey('tabview'),
                            children: [
                                CustomScrollView(
                                  slivers: [
                                    circularcardsliver(size,
                                        value:
                                            '${getvitals.isEmpty ? 0.0 : getvitals.last.temperature}',
                                        unit: 'deg.celsius'),
                                    minavgmax(
                                      size,
                                      color2: Colors.black,
                                      color: kprimary,
                                      avgtitle: 'AVG',
                                      avgvalue:
                                          "${avgQuery[0]['temperature'].toStringAsFixed(1)}",
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
                                                    '${weeklyQuery1.last['temperature']}')),
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
                                                    '${weeklyQuery3.last['temperature']}')),
                                        FlSpot(
                                            4,
                                            weeklyQuery4.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery4.last['temperature']}')),
                                        FlSpot(
                                            5,
                                            weeklyQuery5.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery5.last['temperature']}')),
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
                                  slivers: [
                                    circularcardsliver(size,
                                        value:
                                            '${getvitals.isEmpty ? 0.0 : getvitals.last.bloodpressure}',
                                        unit: 'mmHg'),
                                    minavgmax(
                                      size,
                                      color2: Colors.black,
                                      color: kprimary,
                                      avgtitle: 'AVG',
                                      avgvalue:
                                          "${avgQuery[0]['bloodpressure'].toStringAsFixed(2)}",
                                      maxtitle: 'MAX',
                                      maxvalue:
                                          "${maxQuery[0]['bloodpressure']}",
                                      mintitle: 'MIN',
                                      minvalue:
                                          "${minQuery[0]['bloodpressure']}",
                                    ),
                                    SliverToBoxAdapter(
                                      child: Linechart(flspots: [
                                        const FlSpot(0, 0),
                                        FlSpot(
                                            1,
                                            weeklyQuery1.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery1.last['bloodpressure']}')),
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
                                                    '${weeklyQuery3.last['bloodpressure']}')),
                                        FlSpot(
                                            4,
                                            weeklyQuery4.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery4.last['bloodpressure']}')),
                                        FlSpot(
                                            5,
                                            weeklyQuery5.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery5.last['bloodpressure']}')),
                                        FlSpot(
                                            6,
                                            weeklyQuery6.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery6.last['bloodpressure']}')),
                                        FlSpot(
                                            7,
                                            weeklyQuery7.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery7.last['bloodpressure']}')),
                                      ]),
                                    )
                                  ],
                                ),
                                CustomScrollView(
                                  slivers: [
                                    circularcardsliver(size,
                                        value:
                                            '${getvitals.isEmpty ? 0.0 : getvitals.last.heartrate}',
                                        unit: 'bpm'),
                                    minavgmax(
                                      size,
                                      color2: Colors.black,
                                      color: kprimary,
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
                                                    '${weeklyQuery1.last['heartrate']}')),
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
                                                    '${weeklyQuery3.last['heartrate']}')),
                                        FlSpot(
                                            4,
                                            weeklyQuery4.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery4.last['heartrate']}')),
                                        FlSpot(
                                            5,
                                            weeklyQuery5.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery5.last['heartrate']}')),
                                        FlSpot(
                                            6,
                                            weeklyQuery6.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery6.last['heartrate']}')),
                                        FlSpot(
                                            7,
                                            weeklyQuery7.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery7.last['heartrate']}')),
                                      ]),
                                    )
                                  ],
                                ),
                                CustomScrollView(
                                  slivers: [
                                    circularcardsliver(size,
                                        value:
                                            '${getvitals.isEmpty ? 0.0 : getvitals.last.oxygenlevel}',
                                        unit: '%'),
                                    minavgmax(
                                      size,
                                      color2: Colors.black,
                                      color: kprimary,
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
                                                    '${weeklyQuery1.last['oxygenlevel']}')),
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
                                                    '${weeklyQuery3.last['oxygenlevel']}')),
                                        FlSpot(
                                            4,
                                            weeklyQuery4.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery4.last['oxygenlevel']}')),
                                        FlSpot(
                                            5,
                                            weeklyQuery5.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery5.last['oxygenlevel']}')),
                                        FlSpot(
                                            6,
                                            weeklyQuery6.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery6.last['oxygenlevel']}')),
                                        FlSpot(
                                            7,
                                            weeklyQuery7.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery7.last['oxygenlevel']}')),
                                      ]),
                                    )
                                  ],
                                ),
                                CustomScrollView(
                                  slivers: [
                                    circularcardsliver(size,
                                        value:
                                            '${getvitals.isEmpty ? 0.0 : getvitals.last.respiration}',
                                        unit: 'bpm'),
                                    minavgmax(
                                      size,
                                      color2: Colors.black,
                                      color: kprimary,
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
                                                    '${weeklyQuery1.last['respiration']}')),
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
                                                    '${weeklyQuery3.last['respiration']}')),
                                        FlSpot(
                                            4,
                                            weeklyQuery4.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery4.last['respiration']}')),
                                        FlSpot(
                                            5,
                                            weeklyQuery5.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery5.last['respiration']}')),
                                        FlSpot(
                                            6,
                                            weeklyQuery6.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery6.last['respiration']}')),
                                        FlSpot(
                                            7,
                                            weeklyQuery7.isEmpty
                                                ? 0
                                                : double.parse(
                                                    '${weeklyQuery7.last['respiration']}')),
                                      ]),
                                    )
                                  ],
                                ),
                              ])
                        : const Center(
                            child: Text('No data at the moment'),
                          );
                  })
              .animate()
              .slideX(duration: 300.milliseconds, delay: 100.milliseconds),
        ));
  }

  SliverToBoxAdapter minavgmax(Size size,
      {Color? color,
      color2,
      mintitle,
      minvalue,
      avgtitle,
      avgvalue,
      maxtitle,
      maxvalue}) {
    return SliverToBoxAdapter(
      child: VxGlassmorphic(
        blur: 0,
        circularRadius: 30,
        shadowStrength: 0,
        opacity: 0.5,
        height: size.height * 0.2,
        width: size.width,
        child: HStack(
          [
            minmaxavgelement(
              title: mintitle,
              tcolor: Colors.blue,
              vcolor: color2,
              value: minvalue,
            ),
            const SizedBox(width: 20),
            minmaxavgelement(
              title: avgtitle,
              tcolor: color!,
              vcolor: color2,
              value: avgvalue,
            ),
            const SizedBox(width: 20),
            minmaxavgelement(
              title: maxtitle,
              tcolor: Colors.red,
              vcolor: color2,
              value: maxvalue,
            ),
          ],
          alignment: MainAxisAlignment.spaceEvenly,
        ).px4().py12(),
      ),
    );
  }

  minmaxavgelement({Color? tcolor, Color? vcolor, title, value}) {
    return Card(
      elevation: 10,
      child: VStack([
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 10),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 10),
        Divider(color: kprimary.withOpacity(0.6), thickness: 1),
      ]).px8().py4(),
    );
  }

  SliverToBoxAdapter circularcardsliver(Size size, {value, unit}) {
    return SliverToBoxAdapter(
      child: Container(
        width: size.width * 0.45,
        height: size.height * 0.15,
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Lottie.asset(
              'assets/lottie/140890-blink.json',
              width: size.width * 0.46,
              height: size.height * 0.15,
            ).centered(),
            Container(
              width: size.width * 0.43,
              height: size.height * 0.15,
              decoration: BoxDecoration(
                  color: kprimary.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border:
                      Border.all(width: 2, color: kprimary.withOpacity(0.6))),
              child: VStack(
                [
                  Text(value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: 'Pop',
                        color: Colors.white,
                      )),
                  const SizedBox(height: 10),
                  Text(unit,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
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

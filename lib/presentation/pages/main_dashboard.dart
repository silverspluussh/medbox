// ignore_for_file: use_build_context_synchronously
import 'package:MedBox/presentation/pages/prescriptions/addprescription.dart';
import 'package:MedBox/presentation/pages/prescriptions/viewprescription.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/providers/vitalsprovider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../domain/models/emotions.dart';
import '../../domain/sharedpreferences/profileshared.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  String emoaddress = 'assets/images/exciting.png';
  bool isgoogle = false;

  late List<Map<String, dynamic>> vitals = [];

  bool loading = true;
  void referesh() async {
    final data1 = await VitalsDB.queryvital();
    setState(() {
      vitals = data1;
      loading = false;
    });
  }

  setfield() async {
    setState(() {
      isgoogle = SharedCli().getgmailstatus() ?? false;

      emoaddress = SharedCli().getemoji() ?? 'assets/images/exciting.png';
    });
  }

  @override
  void initState() {
    setfield();
    referesh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<VitalsProvider>(builder: (context, val, child) {
      return CustomScrollView(
        slivers: [
          _emojiecontainer(size),
          SliverToBoxAdapter(
              child: _labeltext(label: 'Daily Body Vitals', color: Colors.black)
                  .py12()),
          _vitalscase(size, val),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const AddPrescription()))),
              child: BoxContainer(
                  height: size.height * 0.24,
                  width: size.width - 50,
                  widget: VStack([
                    _labeltext(
                        label: 'Upload Your Prescription', color: Colors.black),
                    const SizedBox(height: 5),
                    Image.asset(
                      'assets/images/smartphone-rx-prescription.jpg',
                      height: size.height * 0.12,
                      width: size.width - 50,
                    ),
                    _labeltext(
                            label: 'Upload Your Claim Form',
                            color: AppColors.primaryColor)
                        .centered(),
                  ])),
            ),
          ),
          _esubscription(size)
        ],
      );
    }).animate().fadeIn(duration: 100.milliseconds, delay: 100.milliseconds);
  }

  SliverToBoxAdapter _esubscription(Size size) {
    return SliverToBoxAdapter(
      child: BoxContainer(
          height: 90,
          width: size.width - 60,
          widget: ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const Prescription()))),
            leading: Image.asset(
              'assets/images/medical-pr.jpg',
              width: 45,
              height: 45,
            ),
            title: _labeltext(
                label: 'View e - Prescriptions', color: Colors.black),
            subtitle:
                _labeltext(label: 'Issued by Physician', color: Colors.black12),
            trailing: const Icon(
              Icons.keyboard_arrow_right_outlined,
              size: 25,
              color: AppColors.primaryColor,
            ),
          )),
    );
  }

  SliverToBoxAdapter _vitalscase(Size size, VitalsProvider val) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            height: 120,
            width: size.width - 40,
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
          ),
          Container(
            width: size.width,
            height: 120,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    Color.fromARGB(255, 232, 230, 247),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Colors.black26)
                ]),
            child: val.vv.index == 0
                ? _vitalscol(
                    image: 'assets/icons/blood-pressure.png',
                    label: 'Blood pressure',
                    reading:
                        vitals.isNotEmpty ? vitals[0]['bloodpressure'] : '0',
                    callback: () {
                      if (val.vv.index == 0) {
                        val.changevitals(VitalsProvider(Vv.heart));
                      }
                    },
                    units: 'mmHg')
                : val.vv.index == 1
                    ? _vitalscol(
                        image: 'assets/icons/heart-beat.png',
                        label: 'Heart rate',
                        reading:
                            vitals.isNotEmpty ? vitals[0]['heartrate'] : '0',
                        callback: () {
                          if (val.vv.index == 1) {
                            val.changevitals(VitalsProvider(Vv.temperature));
                          }
                        },
                        units: 'bpm')
                    : val.vv.index == 2
                        ? _vitalscol(
                            image: 'assets/icons/temperature.png',
                            label: 'Body temperature',
                            reading: vitals.isNotEmpty
                                ? vitals[0]['temperature']
                                : '0',
                            units: 'deg-celsius',
                            callback: () {
                              if (val.vv.index == 2) {
                                val.changevitals(
                                    VitalsProvider(Vv.oxygenlevel));
                              }
                            })
                        : _vitalscol(
                            image: 'assets/icons/heart-beat.png',
                            label: 'Oxygen level',
                            reading: vitals.isNotEmpty
                                ? vitals[0]['oxygenlevel']
                                : '0',
                            units: '%',
                            callback: () {
                              if (val.vv.index == 3) {
                                val.changevitals(VitalsProvider(Vv.pressure));
                              }
                            }),
          ),
        ],
      ),
    );
  }

  Column _vitalscol(
      {required VoidCallback callback,
      required image,
      required label,
      required reading,
      required units}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(
              image,
              height: 50,
              width: 50,
              color: Colors.white,
            ),
            const SizedBox(width: 15),
            _labeltext(label: label, color: Colors.white),
            const Spacer(),
            IconButton(
                onPressed: callback,
                icon: const Icon(
                  Icons.keyboard_arrow_up_sharp,
                  size: 30,
                ))
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _valuetext(label: reading),
            const SizedBox(width: 15),
            Text(
              units,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black26),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Text _labeltext({required String label, required color}) {
    return Text(
      label,
      style: TextStyle(
          fontFamily: 'Popb',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: color),
    );
  }

  Text _valuetext({required String label}) {
    return Text(
      label,
      style: const TextStyle(
          fontFamily: 'Popb',
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Colors.white),
    );
  }

  _emojiecontainer(Size size) {
    return SliverToBoxAdapter(
      child: BoxContainer(
        height: 100,
        width: size.width - 60,
        widget: Row(
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How are you feeling today? ',
                    style: TextStyle(
                        fontFamily: 'Popb',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () =>
                        Future.delayed(const Duration(milliseconds: 200), () {
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Mood',
                          pageBuilder: (context, _, __) {
                            return Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35)),
                                width: size.width - 80,
                                height: size.height * 0.5,
                                child: Scaffold(
                                    body: GridView.count(
                                  childAspectRatio: 1.3,
                                  crossAxisCount: 2,
                                  children: [
                                    ...emoticons.map((e) => Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  emoaddress = e.image;
                                                });
                                                await SharedCli()
                                                    .setemo(value: emoaddress)
                                                    .then((value) =>
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    100), () {
                                                          Navigator.pop(
                                                              context);
                                                        }));
                                              },
                                              onLongPress: () {},
                                              child: Container(
                                                width: size.width * 0.3,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          blurRadius: 5,
                                                          color: Colors.black12)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(e.image),
                                                    Text(
                                                      e.emojiname,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Popb',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
                              ),
                            );
                          });
                    }),
                    child: const Text(
                      'set mood',
                      style: TextStyle(
                          fontFamily: 'Popb',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Image.asset(
              emoaddress,
              height: 50,
              width: 50,
            )
          ],
        ),
      ),
    );
  }
}

class BoxContainer extends StatelessWidget {
  const BoxContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.widget});
  final double height;
  final double width;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)]),
      child: widget,
    );
  }
}

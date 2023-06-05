// ignore_for_file: use_build_context_synchronously
import 'package:MedBox/data/repos/Dbhelpers/medicationdb.dart';
import 'package:MedBox/data/repos/Dbhelpers/prescriptiondb.dart';
import 'package:MedBox/data/repos/Dbhelpers/remindDb.dart';
import 'package:MedBox/presentation/pages/prescriptions/addprescription.dart';
import 'package:MedBox/presentation/pages/prescriptions/viewprescription.dart';
import 'package:MedBox/presentation/widgets/emojiman.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/providers/vitalsprovider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../domain/sharedpreferences/sharedprefs.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  String emoaddress = 'assets/images/exciting.png';
  bool isgoogle = false;

  List<Map<String, dynamic>> vitals = [];

  bool loading = true;
  void referesh() async {
    await VitalsDB().initDatabase();
    await ReminderDB().initDatabase();
    await PrescriptionDB().initDatabase();
    await MedicationsDB().initDatabase();

    final data1 = await VitalsDB().queryvital();
    setState(() {
      vitals = data1;
      loading = false;
    });
  }

  @override
  void initState() {
    referesh();
    emoaddress = SharedCli().getemoji() ?? 'assets/images/exciting.png';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<VitalsProvider>(builder: (context, val, child) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
                    _labeltextz(
                            label: 'Upload Your Claim Form', color: kprimary)
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
            title: _labeltextz(
                label: 'View e - Prescriptions', color: Colors.black),
            trailing: const Icon(
              Icons.keyboard_arrow_right_outlined,
              size: 25,
              color: kprimary,
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
                color: kprimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
          ),
          Positioned(
            top: 3,
            child: Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      kprimary,
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
                              units: 'degree-celsius',
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
          ),
        ],
      ),
    );
  }

  _vitalscol({VoidCallback? callback, image, label, reading, units}) {
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
                  fontWeight: FontWeight.w500,
                  color: Colors.black26),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    ).animate().fadeIn(duration: 500.milliseconds);
  }

  Text _labeltext({String? label, color}) {
    return Text(
      label!,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Text _labeltextz({String? label, color}) {
    return Text(label!, style: Theme.of(context).textTheme.bodySmall);
  }

  Text _valuetext({String? label}) {
    return Text(label!, style: Theme.of(context).textTheme.bodyMedium);
  }

  _emojiecontainer(Size size) {
    return SliverToBoxAdapter(
      child: BoxContainer(
        width: size.width - 60,
        widget: Column(
          children: [
            Text('How are you feeling today? ',
                style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: [
                InkWell(
                  onTap: () =>
                      Future.delayed(const Duration(milliseconds: 50), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmojiChanger()));
                  }),
                  child: const Text(
                    'Set mood',
                    style: TextStyle(
                        fontFamily: 'Pop',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.blue),
                  ),
                ),
                const Spacer(),
                Image.asset(
                  emoaddress,
                  height: 40,
                  width: 40,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BoxContainer extends StatelessWidget {
  final double width;
  final Widget widget;

  const BoxContainer({super.key, required this.width, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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

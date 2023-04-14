import 'package:flutter/material.dart';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/providers/vitalsprovider.dart';
import 'package:MedBox/utils/extensions/photos_extension.dart';
import 'package:MedBox/main.dart';
import 'package:provider/provider.dart';

import '../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../domain/models/emotions.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  String username = '';
  String emoaddress = 'assets/images/exciting.png';

  var pfp;
  bool isgoogle = false;

  @override
  void initState() {
    setfield();
    referesh();
    super.initState();
  }

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
      pfp = prefs.getString('pfp');
      isgoogle = prefs.getBool('googleloggedin') ?? false;
      username = prefs.getString('username') ??
          prefs.getString('googlename') ??
          'No Username set';
      emoaddress = prefs.getString('emotion') ?? 'assets/images/exciting.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<VitalsProvider>(builder: (context, val, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  _goodaycontainer(size),
                  const SizedBox(height: 10),
                  _emojiecontainer(size),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: size.width - 50,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Container(
                        width: size.width,
                        height: 150,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
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
                                reading: vitals.isNotEmpty
                                    ? vitals[0]['bloodpressure']
                                    : '0',
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
                                    reading: vitals.isNotEmpty
                                        ? vitals[0]['heartrate']
                                        : '0',
                                    callback: () {
                                      if (val.vv.index == 1) {
                                        val.changevitals(
                                            VitalsProvider(Vv.temperature));
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
                                            val.changevitals(
                                                VitalsProvider(Vv.pressure));
                                          }
                                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _vitaltile(
                    icon: 'assets/icons/heartbeat.png',
                    title: 'Heart rate',
                    callback: () => val.changevitals(VitalsProvider(Vv.heart)),
                  ),
                  const SizedBox(height: 20),
                  _vitaltile(
                    icon: 'assets/icons/temperature.png',
                    title: 'Body temperature',
                    callback: () =>
                        val.changevitals(VitalsProvider(Vv.temperature)),
                  ),
                  const SizedBox(height: 20),
                  _vitaltile(
                    icon: 'assets/icons/health-12-512.png',
                    title: 'Blood pressure',
                    callback: () =>
                        val.changevitals(VitalsProvider(Vv.pressure)),
                  ),
                  const SizedBox(height: 20),
                  _vitaltile(
                    icon: 'assets/icons/6-medical-blood-oxygen.png',
                    title: 'Oxyggen level',
                    callback: () =>
                        val.changevitals(VitalsProvider(Vv.oxygenlevel)),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          })),
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
            _labeltext(label: label),
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

  ListTile _vitaltile(
      {required title, required icon, required VoidCallback callback}) {
    return ListTile(
      onTap: callback,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Popb',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      leading: Image.asset(
        icon,
        width: 30,
        height: 30,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      tileColor: Colors.black12.withOpacity(0.05),
    );
  }

  Text _labeltext({required String label}) {
    return Text(
      label,
      style: const TextStyle(
          fontFamily: 'Popb',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white),
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

  SizedBox _goodaycontainer(Size size) {
    return SizedBox(
      height: 90,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              height: 80,
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good day, ',
                    style: TextStyle(
                        fontFamily: 'Popb',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    username,
                    style: const TextStyle(
                        fontFamily: 'Popb',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              )),
          const Spacer(),
          Container(
            height: 50,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: prefs.getBool('googleloggedin') == true
                        ? NetworkImage(prefs.getString('googleimage')!)
                        : pfp != null
                            ? MemoryImage(Utility().dataFromBase64String(pfp))
                            : const AssetImage('assets/icons/profile-35-64.png')
                                as ImageProvider)),
          ),
        ],
      ),
    );
  }

  BoxContainer _emojiecontainer(Size size) {
    return BoxContainer(
      height: 100,
      width: size.width - 40,
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
                      fontSize: 13,
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
                                              await prefs
                                                  .setString(
                                                      'emotion', emoaddress)
                                                  .then((value) =>
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100), () {
                                                        Navigator.pop(context);
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
            height: 55,
            width: 55,
          )
        ],
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

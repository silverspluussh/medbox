import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:velocity_x/velocity_x.dart';

class DrugAlarms extends StatefulWidget {
  const DrugAlarms({super.key});

  @override
  State<DrugAlarms> createState() => _DrugAlarmsState();
}

class _DrugAlarmsState extends State<DrugAlarms> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: VStack([
            const SizedBox(height: 30),
            HStack(alignment: MainAxisAlignment.start, [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                    color: AppColors.primaryColor,
                  ))
            ]),
            const SizedBox(height: 10),
            const Text(
              'ACTIVE REMINDERS',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Pop',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ).pSymmetric(h: 30),
            const SizedBox(height: 20),
            SizedBox(
              height: size.height,
              width: size.width,
              child: FutureBuilder(
                  future: NotifConsole().getreminders(),
                  builder: (context, reminders) {
                    if (!reminders.hasData) {
                      return const Center(
                        child: Text('No reminder alerts set'),
                      );
                    }
                    if (reminders.hasData) {
                      List<PendingNotificationRequest>? activenotif =
                          reminders.data;
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          itemCount: activenotif!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              width: size.width * 0.6,
                              height: 185,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromARGB(255, 10, 48, 12)),
                              child: VStack([
                                Row(
                                  children: [
                                    Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      margin: const EdgeInsets.all(1),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 2),
                                        child: Text(
                                          activenotif[index].title!,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Pop',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  backgroundColor: Colors.green,
                                                  child: Container(
                                                    height: 150,
                                                    width: size.width * 0.7,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Remove reminder',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Popb'),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        const Text(
                                                          'Are you sure you want to delete reminder?',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Pop'),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        SizedBox(
                                                          height: 30,
                                                          width:
                                                              size.width * 0.7,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  NotifConsole()
                                                                      .cancelreminder(
                                                                          id: activenotif[index]
                                                                              .id)
                                                                      .then(
                                                                          (value) {
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Yes',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'Popb'),
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'No',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'Popb'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: const ImageIcon(
                                            color: Colors.red,
                                            size: 25,
                                            AssetImage(
                                                'assets/icons/eliminate-50-512.png')))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  activenotif[index].body!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Pop',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ).centered(),
                                const SizedBox(height: 10),
                                Card(
                                  elevation: 5,
                                  color: Colors.green,
                                  margin: const EdgeInsets.all(1),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      "at ${activenotif[index].payload}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Pop',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ).centered(),
                              ]).p20(),
                            );
                          });
                    }
                    return const SizedBox();
                  }),
            ),
          ])),
    ).animate().fadeIn(duration: 100.milliseconds, delay: 100.milliseconds);
  }
}

import 'package:MedBox/version2/utilites/pushnotifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class MedReminders extends StatefulWidget {
  const MedReminders({super.key});

  @override
  State<MedReminders> createState() => _MedRemindersState();
}

class _MedRemindersState extends State<MedReminders> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 0,
        ),
        body: SafeArea(
          child: FutureBuilder(
                  future: NotificationBundle().showReminders(),
                  builder: (context, pending) {
                    if (pending.hasData) {
                      List<PendingNotificationRequest> pend = pending.data!;

                      return _listbuilder(pend, size);
                    }

                    return nodata(size, context);
                  })
              .animate()
              .slideX(duration: 300.milliseconds, delay: 100.milliseconds),
        ),
      ),
    );
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
          Text("No pending reminders",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  ListView _listbuilder(List<dynamic> list, Size size) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: size.width - 40,
            child: Card(
              elevation: 4,
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
                        child: Text(list[index].title,
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          dialogg(context, size, list, index);
                        },
                        icon: const ImageIcon(
                          AssetImage('assets/icons/eliminate-50-512.png'),
                          color: Colors.red,
                          size: 25,
                        ))
                  ],
                ),
                Text(list[index].body,
                        style: Theme.of(context).textTheme.bodySmall)
                    .centered(),
                const SizedBox(height: 10),
                Card(
                  elevation: 5,
                  color: Colors.green,
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(list[index].payload,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
              ]).p20(),
            ),
          );
        });
  }

  Future<dynamic> dialogg(
      BuildContext context, Size size, List<dynamic> list, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.green,
            child: Container(
              height: size.height * 0.3,
              width: size.width * 0.7,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Remove reminder',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  Text('Are you sure you want to delete reminder?',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            NotificationBundle()
                                .deleteAlarm(id: list[index].id)
                                .then((value) {
                              Navigator.pop(context);
                              setState(() {});
                            });
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                                fontFamily: 'Popb'),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: 'Popb'),
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
  }
}

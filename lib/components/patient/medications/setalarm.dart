import 'package:MedBox/components/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../artifacts/colors.dart';

class SetAlarm extends StatefulWidget {
  const SetAlarm({super.key, required this.medicinename, required this.dose});
  final String medicinename;
  final String dose;
  @override
  State<SetAlarm> createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  TimeOfDay? initime = TimeOfDay.now();
  TimeOfDay time = TimeOfDay.now();
// @huawei2023Jnr
//idaas_557466718
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height * 0.6,
        width: size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(height: 50),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const ImageIcon(
                      AssetImage('assets/icons/return-431-512.png'),
                      color: AppColors.primaryColor,
                    ),
                    iconSize: 25),
                const SizedBox(width: 40),
                Text(
                  'Set reminder for ${widget.medicinename}'.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      fontFamily: 'Pop'),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 1.5, color: AppColors.primaryColor)),
                  child: Center(
                    child: Text(
                      time.format(context).toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          fontFamily: 'Pop'),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                IconButton(
                    onPressed: () async {
                      await showTimePicker(
                              context: context, initialTime: initime!)
                          .then((value) {
                        setState(() {
                          time = value!;
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.more_time_rounded,
                      size: 30,
                      color: AppColors.primaryColor,
                    ))
              ],
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                NotifConsole()
                    .medicationalerts(
                        title: widget.medicinename,
                        body:
                            'Reminder to take ${widget.dose} dose(s) of ${widget.medicinename}',
                        hour: time.hour,
                        minute: time.minute)
                    .then((value) {
                  VxToast.show(context,
                      msg: 'Reminder Set Successfully.',
                      bgColor: const Color.fromARGB(255, 19, 46, 20),
                      textColor: Colors.white,
                      pdHorizontal: 10,
                      pdVertical: 5);
                  setState(() {
                    time = TimeOfDay.now();
                  });
                }).then((value) => Navigator.pop(context));
              },
              child: Container(
                width: 150,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.primaryColor),
                child: const Center(
                  child: Text(
                    'Set reminder',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Pop'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

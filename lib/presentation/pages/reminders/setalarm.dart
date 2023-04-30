import 'package:MedBox/utils/extensions/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';

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
    return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 50,
          title: Text(
            'Set reminder for ${widget.medicinename}'.toUpperCase(),
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                fontFamily: 'Pop'),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 1, color: AppColors.primaryColor)),
                  child: Center(
                    child: Text(
                      time.format(context).toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
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
                      size: 25,
                      color: AppColors.primaryColor,
                    ))
              ],
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                NotifConsole()
                    .setreminder(
                        title: widget.medicinename,
                        body:
                            'Reminder to take ${widget.dose} dose(s) of ${widget.medicinename}',
                        hour: time.hour,
                        minute: time.minute)
                    .then((value) {
                  VxToast.show(context,
                      msg: 'Reminder set successfully.',
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
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.primaryColor),
                child: const Center(
                  child: Text(
                    'Set reminder',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Pop'),
                  ),
                ),
              ),
            ),
          ],
        )
            .centered()
            .animate()
            .fadeIn(duration: 100.milliseconds, delay: 10.milliseconds));
  }
}

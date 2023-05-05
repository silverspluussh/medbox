import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../../widgets/formfieldwidget.dart';

class SetAlarm extends StatefulWidget {
  const SetAlarm({Key key, this.medicinename, this.dose}) : super(key: key);
  final String medicinename;
  final String dose;
  @override
  State<SetAlarm> createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  TimeOfDay initime = TimeOfDay.now();
  TimeOfDay time = TimeOfDay.now();

  TextEditingController timec = TextEditingController();
// @huawei2023Jnr
//idaas_557466718
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 50,
          title: Text('Set reminder for ${widget.medicinename}'.toUpperCase(),
              style: popblack),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormfieldX(
                    label: 'Time',
                    controller: timec,
                    readonly: true,
                    hinttext: time.format(context).toString(),
                    validator: (e) {
                      return null;
                    }),
                const SizedBox(width: 40),
                IconButton(
                    onPressed: () async {
                      await showTimePicker(
                              context: context, initialTime: initime)
                          .then((value) {
                        setState(() {
                          timec.text = value.format(context).toString();
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
                  child: Text('Set reminder', style: popblack),
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

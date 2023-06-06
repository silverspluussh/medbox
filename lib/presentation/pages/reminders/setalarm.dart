import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/pages/renderer.dart';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/formfieldwidget.dart';

class SetAlarm extends StatefulWidget {
  final String medicinename;
  final String dose;

  const SetAlarm({super.key, required this.medicinename, required this.dose});
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 50,
        title: Text('Set reminder for ${widget.medicinename}'.toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall),
        centerTitle: true,
      ),
      body: SizedBox(
        height: size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            FormfieldX(
                label: 'Time',
                controller: timec,
                readonly: true,
                hinttext: time.format(context).toString(),
                suffix: IconButton(
                    onPressed: () async {
                      await showTimePicker(
                              context: context, initialTime: initime)
                          .then((value) {
                        setState(() {
                          timec.text = value!.format(context).toString();
                          time = value;
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.more_time_rounded,
                      size: 25,
                      color: kprimary,
                    )),
                validator: (e) {
                  return null;
                }),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                NotifConsole()
                    .setreminder(
                        title: widget.medicinename,
                        body:
                            'Reminder to take ${widget.dose} dose(s) of ${widget.medicinename}',
                        hour: time.hour,
                        payload:
                            '${time.hour.toString()}:${time.minute.toString()}',
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
                }).then((value) => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Render())));
              },
              child: Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: kprimary),
                child: Center(
                  child: Text('Set reminder',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ),
            ),
          ],
        )
            .centered()
            .animate()
            .slideX(duration: 300.milliseconds, delay: 100.milliseconds),
      ),
    );
  }
}

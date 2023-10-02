import 'package:MedBox/version2/UI/meds/editmed.dart';
import 'package:MedBox/version2/models/medication_model.dart';
import 'package:MedBox/version2/wiis/formfieldwidget.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';
import '../../firebase/medicfirebase.dart';
import '../../models/reminders_model.dart';
import '../../sqflite/reminderlocal.dart';
import '../../utilites/pushnotifications.dart';
import '../../utilites/randomgen.dart';
import '../../wiis/buttons.dart';

class ViewMed extends ConsumerStatefulWidget {
  const ViewMed(this.model, {super.key});
  final MModel model;

  @override
  ConsumerState<ViewMed> createState() => _ViewMedState();
}

class _ViewMedState extends ConsumerState<ViewMed> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    DateTime? alarmTime;
    TextEditingController time = TextEditingController();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              child: HStack([
                const Ltxt(text: 'Medicine Information'),
                const Spacer(),
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all(width: 0.5)),
                    child: IconButton(
                        onPressed: () => context.pop(context),
                        icon: const Icon(Icons.close,
                            size: 30, color: Colors.red)))
              ]),
            ),
            20.heightBox,
            Image.asset(widget.model.image!, width: 80, height: 80),
            10.heightBox,
            const Stxt(text: 'Medicine Name'),
            5.heightBox,
            Ltxt(
              text: widget.model.medicinename ?? "__",
            ),
            5.heightBox,
            10.heightBox,
            const Stxt(text: 'Medicine Dosage'),
            5.heightBox,
            Ltxt(
              text: widget.model.dose ?? "__",
            ),
            5.heightBox,
            10.heightBox,
            const Stxt(text: 'Medication type'),
            5.heightBox,
            Ltxt(
              text: widget.model.medicinetype ?? "__",
            ),
            20.heightBox,
            HStack(
              [
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      enableDrag: true,
                      builder: (context) => SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: VStack(
                                  crossAlignment: CrossAxisAlignment.start,
                                  [
                                    10.heightBox,
                                    Image.asset("assets/icons/reminder.png",
                                        width: 80, height: 80),
                                    10.heightBox,
                                    Stxt(text: widget.model.medicinename!),
                                    10.heightBox,
                                    const Ltxt(
                                        text: 'Time to take medication:'),
                                    5.heightBox,
                                    Customfield(
                                      readonly: true,
                                      controller: time,
                                      hinttext: TimeOfDay.now().format(context),
                                      inputType: TextInputType.number,
                                      validator: (value) {
                                        return;
                                      },
                                      suffix: IconButton(
                                          onPressed: () async {
                                            var selecTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());
                                            if (selecTime != null) {
                                              final DateTime now =
                                                  DateTime.now();

                                              var selectedDateTime = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                  selecTime.hour,
                                                  selecTime.minute);
                                              alarmTime = selectedDateTime;
                                              time.text = DateFormat('HH:mm')
                                                  .format(selectedDateTime);
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.alarm_add_rounded)),
                                    ),
                                    15.heightBox,
                                    GestureDetector(
                                      onTap: () => showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              title: const Ltxt(
                                                      text:
                                                          'Schedule medication?')
                                                  .centered(),
                                              content: const Btxt(
                                                text:
                                                    'Are you sure you want to  make a schedule?',
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                              actionsPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                              actions: [
                                                CancelBtn(
                                                    function: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    text: 'Cancel'),
                                                ConfirmBtn(
                                                  function: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    final rcontroller =
                                                        ref.watch(
                                                            remindersDbProvider);
                                                    final rmodel = RModel(
                                                      date: DateFormat(
                                                              'yyyy-MM-dd')
                                                          .format(
                                                              DateTime.now()),
                                                      id: idg(),
                                                      medicinename: widget
                                                          .model.medicinename,
                                                      time: time.text,
                                                      body:
                                                          ' ${widget.model.dose} dose(s) of ${widget.model.medicinename}',
                                                    );

                                                    rcontroller
                                                        .addReminder(rmodel)
                                                        .whenComplete(() {
                                                      NotificationBundle()
                                                          .onSaveAlarm(
                                                        components:
                                                            DateTimeComponents
                                                                .time,
                                                        alarmTime: alarmTime,
                                                        body: rmodel.body,
                                                        id: rmodel.id
                                                            .toString(),
                                                        title: widget
                                                            .model.medicinename,
                                                      );
                                                    }).then((value) {
                                                      context.pop(context);
                                                      time.clear();
                                                      return VxToast.show(
                                                          context,
                                                          textSize: 11,
                                                          msg:
                                                              'Schedule created successfully.',
                                                          bgColor: const Color
                                                              .fromARGB(
                                                              255, 38, 99, 40),
                                                          textColor:
                                                              Colors.white,
                                                          pdHorizontal: 30,
                                                          pdVertical: 20);
                                                    });
                                                  },
                                                  text: 'Schedule',
                                                )
                                              ],
                                            );
                                          }),
                                      child: Container(
                                        width: size.width * 0.9,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 25),
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: kprimary.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: const Text('Schedule medication',
                                                style: TextStyle(
                                                    fontFamily: 'Pop',
                                                    fontSize: 14,
                                                    color: Colors.white))
                                            .centered(),
                                      ),
                                    )
                                  ]),
                            ),
                          )),
                  child: Container(
                    width: size.width * 0.45,
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    height: 45,
                    decoration: BoxDecoration(
                        color: kprimary.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text('Add Schedule',
                            style: TextStyle(
                                fontFamily: 'Pop',
                                fontSize: 14,
                                color: Colors.white))
                        .centered(),
                  ),
                ),
                20.widthBox,
                GestureDetector(
                  onTap: () => context.nextPage(EditMedication(widget.model)),
                  child: Container(
                    width: size.width * 0.4,
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text('Edit Medication',
                            style: TextStyle(
                                fontFamily: 'Pop',
                                fontSize: 14,
                                color: Colors.white))
                        .centered(),
                  ),
                )
              ],
              alignment: MainAxisAlignment.center,
            ),
            15.heightBox,
            GestureDetector(
              onTap: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Ltxt(text: 'Delete medication?').centered(),
                      content: const Btxt(
                        text: 'Are you sure you want to delete medication?',
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      actionsPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      actions: [
                        CancelBtn(
                            function: () => Navigator.of(context).pop(false),
                            text: 'Cancel'),
                        ConfirmBtn(
                          function: () {
                            Navigator.of(context).pop(true);
                            final aduro = ref.watch(medicationFirebaseProvider);

                            aduro
                                .deleteMedication(mid: widget.model.did!)
                                .whenComplete(() => context.pop());
                          },
                          text: 'Remove',
                        )
                      ],
                    );
                  }),
              child: Container(
                width: size.width * 0.9,
                margin: const EdgeInsets.symmetric(vertical: 25),
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15)),
                child: const Text('Remove medication',
                        style: TextStyle(
                            fontFamily: 'Pop',
                            fontSize: 14,
                            color: Colors.white))
                    .centered(),
              ),
            )
          ],
        )),
      ).animate().slideY(duration: 300.ms, begin: 1),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:MedBox/version2/utilites/randomgen.dart';
import 'package:MedBox/version2/wiis/dialogs.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';
import '../../firebase/medicfirebase.dart';
import '../../models/medication_model.dart';
import '../../models/reminders_model.dart';
import '../../providers.dart/authprovider.dart';
import '../../sqflite/reminderlocal.dart';
import '../../utilites/pushnotifications.dart';
import '../../wiis/formfieldwidget.dart';

class Addmedication extends ConsumerStatefulWidget {
  const Addmedication({super.key});

  @override
  ConsumerState<Addmedication> createState() => _AddmedicationState();
}

class _AddmedicationState extends ConsumerState<Addmedication> {
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();

  TextEditingController kind = TextEditingController();
  TextEditingController dose = TextEditingController();
  TextEditingController time = TextEditingController();
  DateTime? alarmTime;

  final formkey = GlobalKey<FormState>();

  final GlobalKey<State> mainkey = GlobalKey<State>();

  bool loader = false;

  @override
  void dispose() {
    name.dispose();
    type.dispose();
    dose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20),
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(color: kBackgroundColor),
        child: Form(
            key: formkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width,
                    child: HStack([
                      Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 0.5)),
                          child: IconButton(
                              onPressed: () => context.pop(context),
                              icon: const Icon(Icons.close,
                                  size: 30, color: Colors.red))),
                      const Spacer(),
                      const Ltxt(text: 'Add Medication'),
                    ]).px12(),
                  ),
                  20.heightBox,
                  const Ltxt(text: 'Medication Name:'),
                  Customfield(
                    readonly: false,
                    controller: name,
                    hinttext: "penincillin V 10mg",
                    inputType: TextInputType.name,
                    validator: (value) {
                      return;
                    },
                  ),
                  15.heightBox,
                  const Ltxt(text: 'Medication Type:'),
                  Customfield(
                      readonly: true,
                      controller: type,
                      hinttext: 'medication type',
                      inputType: TextInputType.name,
                      validator: (value) {
                        return;
                      },
                      suffix: DropdownButton(
                          underline: const SizedBox(),
                          items: [
                            ...['medication', 'prescription'].map((e) =>
                                DropdownMenuItem(
                                    value: e, child: Btxt(text: e)))
                          ],
                          onChanged: (e) {
                            type.text = e ?? 'Medication';
                          })),
                  15.heightBox,
                  const Ltxt(text: 'kind of Medication:'),
                  Customfield(
                      readonly: true,
                      controller: kind,
                      hinttext: 'pills',
                      inputType: TextInputType.name,
                      validator: (value) {
                        return;
                      },
                      suffix: DropdownButton(
                          underline: const SizedBox(),
                          items: [
                            ...[
                              'bottle',
                              'lotion',
                              "pills",
                              "spray",
                              "syringe",
                              "tablet"
                            ].map((e) => DropdownMenuItem(
                                value: e, child: Btxt(text: e)))
                          ],
                          onChanged: (e) {
                            kind.text = e ?? 'pills';
                          })),
                  15.heightBox,
                  const Ltxt(text: 'Medication Dosage:'),
                  Customfield(
                      readonly: true,
                      controller: dose,
                      hinttext: '3x per intake',
                      inputType: TextInputType.name,
                      validator: (value) {
                        return;
                      },
                      suffix: DropdownButton(
                          underline: const SizedBox(),
                          items: [
                            ...['1x', '2x', "3x", "4x", "5x", "6x", "7x"].map(
                                (e) => DropdownMenuItem(
                                    value: e, child: Btxt(text: e)))
                          ],
                          onChanged: (e) {
                            dose.text = e ?? '1x';
                          })),
                  15.heightBox,
                  const Ltxt(text: 'Time to take medication:'),
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
                          var selecTime = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (selecTime != null) {
                            final DateTime now = DateTime.now();

                            var selectedDateTime = DateTime(now.year, now.month,
                                now.day, selecTime.hour, selecTime.minute);
                            alarmTime = selectedDateTime;
                            time.text =
                                DateFormat('HH:mm').format(selectedDateTime);
                          }
                        },
                        icon: const Icon(Icons.alarm_add_rounded)),
                  ),
                  20.heightBox,
                  GestureDetector(
                    onTap: () async {
                      final rcontroller = ref.watch(remindersDbProvider);
                      final mcontroller = ref.watch(medicationFirebaseProvider);
                      final user =
                          ref.watch(authRepositoryProvider).currentUser;

                      final mmodel = MModel(
                          medicinename: name.text,
                          dose: dose.text,
                          mid: user!.uid,
                          medicinetype: type.text,
                          image: "assets/meds/${kind.text}.png");

                      final val = formkey.currentState!.validate();

                      if (val == true) {
                        setState(() {
                          loader = true;
                        });
                        Dialogs.showLoadingDialog(context, mainkey,
                            text: 'Adding ${name.text}',
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ));
                        try {
                          mcontroller
                              .addMedication(med: mmodel)
                              .then((val) async {
                            final rmodel = RModel(
                                date: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                time: time.text,
                                body:
                                    '${user.displayName}, time to take ${name.text}',
                                medicinename: name.text,
                                id: idg());
                            await rcontroller
                                .addReminder(rmodel)
                                .then((value) async {
                              await NotificationBundle()
                                  .onSaveAlarm(
                                      components: DateTimeComponents.time,
                                      alarmTime: alarmTime,
                                      id: rmodel.id.toString(),
                                      body:
                                          'It is time for ${dose.text} : ${name.text}',
                                      title: mmodel.medicinename)
                                  .whenComplete(() async {
                                await NotificationBundle()
                                    .adonMessage(name.text, time.text);
                                Navigator.of(mainkey.currentContext!,
                                        rootNavigator: true)
                                    .pop();
                                setState(() {
                                  loader = false;
                                });

                                context.pop();
                                return VxToast.show(context,
                                    textSize: 11,
                                    msg: 'Medication added successfully.',
                                    bgColor:
                                        const Color.fromARGB(255, 38, 99, 40),
                                    textColor: Colors.white,
                                    pdHorizontal: 30,
                                    pdVertical: 20);
                              });
                            });
                          });
                        } catch (e) {
                          setState(() {
                            loader = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red[400],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              content: Itxt(text: e.toString()).centered()));
                        }
                      }
                    },
                    child: Container(
                      width: size.width * 0.9,
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text('Add Medication',
                              style: TextStyle(
                                  fontFamily: 'Pop',
                                  fontSize: 14,
                                  color: Colors.white))
                          .centered(),
                    ),
                  ),
                ],
              ),
            )),
      ).animate().slideY(duration: 300.ms, begin: 1)),
    );
  }
}

import 'package:MedBox/version2/UI/rtest/rapidtest.dart';
import 'package:MedBox/version2/firebase/appointment.dart';
import 'package:MedBox/version2/models/appointments.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:MedBox/version2/utilites/pushnotifications.dart';
import 'package:MedBox/version2/wiis/formfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../../wiis/txt.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:timezone/timezone.dart' as tz;

class PSchedule extends ConsumerStatefulWidget {
  const PSchedule(this.pharmacy, {super.key});
  final String pharmacy;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PScheduleState();
}

class _PScheduleState extends ConsumerState<PSchedule> {
  @override
  void initState() {
    pharmacy.text = widget.pharmacy;
    super.initState();
  }

  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    date.dispose();
    time.dispose();
    note.dispose();
    number.dispose();
    rapidtest.dispose();
    pharmacy.dispose();
    super.dispose();
  }

  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController rapidtest = TextEditingController();
  TextEditingController pharmacy = TextEditingController();

  tz.TZDateTime? alarmTime;
  tz.TZDateTime? alarmDate;

  @override
  Widget build(BuildContext context) {
    final aps = ref.watch(appointmentFirebaseProvider);
    final user = ref.watch(authRepositoryProvider);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: VStack([
              Row(
                children: [
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: kprimary,
                      )),
                  const Spacer(),
                  const Ttxt(text: 'Schedule test'),
                  const Spacer()
                ],
              ),
              const SizedBox(height: 20),
              Ttxt(text: AppLocalizations.of(context)!.dandt).px20(),
              HStack([
                FormfieldX(
                  label: 'Date',
                  readonly: true,
                  hinttext: DateTime.now().toString().split(' ').first,
                  inputType: TextInputType.datetime,
                  controller: date,
                  validator: (value) {
                    if (value == null) {
                      return 'field cannot be empty';
                    }
                    return null;
                  },
                  suffix: IconButton(
                      onPressed: () async {
                        var selectedate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 730)));

                        if (selectedate != null) {
                          final now = tz.TZDateTime.now(tz.local);
                          var selectedDateTime = tz.TZDateTime(
                              tz.local,
                              selectedate.year,
                              selectedate.month,
                              selectedate.day,
                              now.hour,
                              now.minute);
                          alarmDate = selectedDateTime;
                          date.text =
                              DateFormat('yyyy-MM-dd').format(selectedDateTime);
                        }
                      },
                      icon: const Icon(Icons.date_range_rounded)),
                ),
                FormfieldX(
                  label: AppLocalizations.of(context)!.time,
                  readonly: true,
                  hinttext: TimeOfDay.now().format(context),
                  controller: time,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null) {
                      return 'field cannot be empty';
                    }
                    return null;
                  },
                  suffix: IconButton(
                      onPressed: () async {
                        var selecTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (selecTime != null) {
                          final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
                          var selectedDateTime = tz.TZDateTime(
                              tz.local,
                              now.year,
                              now.month,
                              now.day,
                              selecTime.hour,
                              selecTime.minute);
                          alarmTime = selectedDateTime;
                          time.text =
                              DateFormat('HH:mm').format(selectedDateTime);
                        }
                      },
                      icon: const Icon(Icons.alarm_add_rounded)),
                ),
              ]),
              const SizedBox(height: 20),
              Ttxt(text: AppLocalizations.of(context)!.rtesttype).px20(),
              Row(
                children: [
                  FormfieldX(
                      controller: rapidtest,
                      label: 'Rapid test type',
                      readonly: true,
                      hinttext: AppLocalizations.of(context)!.mmtest,
                      inputType: TextInputType.name,
                      validator: (value) {
                        if (value == null) {
                          return 'field cannot be empty';
                        }
                        return null;
                      },
                      suffix: DropdownButton(
                        underline: const SizedBox(),
                        items: [
                          ...rtests.map((e) =>
                              DropdownMenuItem(value: e, child: Btxt(text: e)))
                        ],
                        onChanged: (e) {
                          rapidtest.text = e!;
                        },
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Ttxt(text: AppLocalizations.of(context)!.pp).px20(),
              Row(
                children: [
                  FormfieldX(
                    label: '',
                    readonly: true,
                    controller: pharmacy,
                    hinttext: 'eg. hale pharmacy',
                    inputType: TextInputType.name,
                    validator: (value) {
                      if (value == null) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Ttxt(text: 'Note').px20(),
              Row(
                children: [
                  FormfieldX(
                    label: 'Note',
                    readonly: false,
                    controller: note,
                    hinttext: 'write a short note for description',
                    inputType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Ttxt(text: 'Number').px20(),
              Row(
                children: [
                  FormfieldX(
                    label: 'Telephone Number',
                    readonly: false,
                    controller: number,
                    hinttext: 'eg 0200394483',
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (value == null) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .cschedule,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall),
                                      const SizedBox(height: 10),
                                      Text(
                                          AppLocalizations.of(context)!.confirm,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                final bool vdate = formkey
                                                    .currentState!
                                                    .validate();

                                                if (vdate == true) {
                                                  final model = ApModel(
                                                      createdAt: DateTime.now()
                                                          .millisecondsSinceEpoch
                                                          .toString(),
                                                      date: date.text,
                                                      note: note.text,
                                                      number: number.text,
                                                      pharmacy: pharmacy.text,
                                                      testtype: rapidtest.text,
                                                      time: time.text,
                                                      status: true);
                                                  await aps
                                                      .addAppointment(
                                                          uid: user
                                                              .currentUser!.uid,
                                                          med: model)
                                                      .whenComplete(() async {
                                                    await NotificationBundle()
                                                        .dateAlarm(
                                                            components:
                                                                DateTimeComponents
                                                                    .dateAndTime,
                                                            alarmTime: tz.TZDateTime(
                                                                tz.local,
                                                                alarmDate!.year,
                                                                alarmDate!
                                                                    .month,
                                                                alarmDate!.day,
                                                                alarmTime!.hour,
                                                                alarmTime!
                                                                    .minute),
                                                            body:
                                                                'Medbox wants to remind you of your ${rapidtest.text} with ${pharmacy.text} today!',
                                                            id: model.aid,
                                                            title:
                                                                '${rapidtest.text.toUpperCase()} REMINDER.')
                                                        .whenComplete(() => VxToast.show(
                                                            context,
                                                            textSize: 11,
                                                            msg:
                                                                'Appointment added successfully.',
                                                            bgColor: const Color
                                                                    .fromARGB(
                                                                255,
                                                                38,
                                                                99,
                                                                40),
                                                            textColor:
                                                                Colors.white,
                                                            pdHorizontal: 30,
                                                            pdVertical: 20))
                                                        .then((value) {
                                                      context.pop();
                                                      rapidtest.clear();
                                                      pharmacy.clear();
                                                      date.clear();
                                                      note.clear();
                                                      time.clear();
                                                      number.clear();
                                                    });
                                                  });
                                                }
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .yes,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontFamily: 'Pop'),
                                              ),
                                            ),
                                            const Spacer(),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .no,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontFamily: 'Pop'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                      child: Text(
                        AppLocalizations.of(context)!.stestnow,
                      ).p8())
                  .centered()
            ]),
          ),
        ),
      )),
    );
  }
}

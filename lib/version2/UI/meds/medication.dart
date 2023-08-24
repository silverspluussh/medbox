import 'dart:developer';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/meds/addmed.dart';
import 'package:MedBox/version2/models/reminders_model.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:MedBox/version2/sqflite/reminderlocal.dart';
import 'package:MedBox/version2/utilites/pushnotifications.dart';
import 'package:MedBox/version2/utilites/randomgen.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../firebase/medicfirebase.dart';
import '../../models/medication_model.dart';
import '../../utilites/photos_extension.dart';
import '../../wiis/async_value_widget.dart';
import '../../wiis/formfieldwidget.dart';
import '../../wiis/shimmer.dart';
import 'package:timezone/timezone.dart' as tz;

class Medications extends ConsumerWidget {
  const Medications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(streamMedicationsProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          mini: true,
          tooltip: 'Add medication',
          shape:
              const CircleBorder(side: BorderSide(width: 0.1, color: kprimary)),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddMed())),
          child: const Icon(
            Icons.add,
            size: 30,
            color: kprimary,
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: AsyncValueWidget(
          loading: ListView.builder(
              itemCount: 8,
              itemBuilder: (con, index) =>
                  const ShimmerWidget.rectangular(height: 80)).centered(),
          value: meds,
          data: (m) => CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: m.isNotEmpty ? m.length : 1,
                itemBuilder: (context, index) {
                  return m.isNotEmpty
                      ? Medcard(index: index, meds: m)
                      : SizedBox(
                          height: 300,
                          width: 500,
                          child: Lottie.asset('assets/lottie/empty.json')
                              .centered(),
                        );
                },
              )
            ],
          ).p12(),
        ),
      ),
    );
  }
}

class Medcard extends ConsumerStatefulWidget {
  const Medcard({super.key, required this.meds, required this.index});
  final List<MModel> meds;
  final int index;

  @override
  ConsumerState<Medcard> createState() => _MedcardState();
}

class _MedcardState extends ConsumerState<Medcard> {
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController dose = TextEditingController();
  TextEditingController time = TextEditingController();

  tz.TZDateTime? _alarmTime;

  @override
  void dispose() {
    name.dispose();
    type.dispose();
    dose.dispose();
    time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: MemoryImage(
              Utility().dataFromBase64String(widget.meds[widget.index].image!)),
          radius: 15,
          backgroundColor: kprimary.withOpacity(0.5),
        ),
        title: Card(
            color: Colors.indigo.withOpacity(0.1),
            child:
                Ttxt(text: widget.meds[widget.index].medicinename!.capitalized)
                    .p4()
                    .centered()),
        subtitle: Text(
          widget.meds[widget.index].medicinetype!.capitalized,
          style: TextStyle(
              fontSize: 11,
              color: widget.meds[widget.index].medicinetype == 'medication'
                  ? kgreen
                  : kred,
              fontWeight: FontWeight.w400),
        ),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: kwhite,
        trailing: PopupMenuButton(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) => [
            PopupMenuItem(
                child: InkWell(
                    onTap: () => bottomPop(
                        context, MediaQuery.of(context).size.height * 0.5,
                        child:
                            VStack(crossAlignment: CrossAxisAlignment.center, [
                          const SizedBox(height: 15),
                          const Ttxt(text: 'Edit medication entry'),
                          FormfieldX(
                            label: 'Medicine Name',
                            readonly: false,
                            controller: name,
                            hinttext: widget.meds[widget.index].medicinename,
                            inputType: TextInputType.name,
                            validator: (value) {
                              return;
                            },
                          ),
                          FormfieldX(
                            label: 'Medication dosage',
                            readonly: false,
                            controller: dose,
                            hinttext: widget.meds[widget.index].dose,
                            inputType: TextInputType.name,
                            validator: (value) {
                              return;
                            },
                          ),
                          FormfieldX(
                              label: 'Medication type',
                              readonly: true,
                              controller: type,
                              hinttext: widget.meds[widget.index].medicinetype,
                              inputType: TextInputType.name,
                              validator: (value) {
                                return;
                              },
                              suffix: DropdownButton(
                                  items: [
                                    ...['medication', 'prescription'].map((e) =>
                                        DropdownMenuItem(
                                            value: e, child: Btxt(text: e)))
                                  ],
                                  onChanged: (e) {
                                    type.text = e ?? 'Medication';
                                  })),
                          ElevatedButton(
                              onPressed: () {
                                final user = ref
                                    .watch(authRepositoryProvider)
                                    .currentUser;
                                final aduro =
                                    ref.watch(medicationFirebaseProvider);
                                final aduromodel = MModel(
                                  mid: widget.meds[widget.index].mid,
                                  dose: dose.text,
                                  image: widget.meds[widget.index].image!,
                                  medicinename: name.text,
                                  medicinetype: type.text,
                                );

                                try {
                                  aduro
                                      .updateMedication(
                                          uid: user!.uid, med: aduromodel)
                                      .whenComplete(() {
                                    context.pop();
                                    return VxToast.show(context,
                                        textSize: 11,
                                        msg: 'medication updated successfully.',
                                        bgColor: const Color.fromARGB(
                                            255, 38, 99, 40),
                                        textColor: Colors.white,
                                        pdHorizontal: 30,
                                        pdVertical: 20);
                                  });
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              child: const Itxt(text: 'save changes').p4())
                        ]).p8()),
                    child: Card(
                      color: Colors.blue.withOpacity(0.7),
                      child: const Itxt(text: 'Edit').px12().py8(),
                    ).py12())),
            PopupMenuItem(
                child: InkWell(
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.24,
                          width: MediaQuery.of(context).size.width * 0.55,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Confirm action',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 10),
                              Text('Do you want to delete medication?',
                                      textAlign: TextAlign.left,
                                      style:
                                          Theme.of(context).textTheme.bodySmall)
                                  .centered()
                                  .px8(),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.pop();
                                        final user = ref
                                            .watch(authRepositoryProvider)
                                            .currentUser;
                                        final aduro = ref
                                            .watch(medicationFirebaseProvider);
                                        context.pop();

                                        aduro
                                            .deleteMedication(
                                                uid: user!.uid,
                                                mid: widget
                                                    .meds[widget.index].mid!)
                                            .whenComplete(() => context.pop());
                                      },
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                            fontFamily: 'Popb'),
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontFamily: 'Popb'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
              child: Card(
                      color: kred.withOpacity(0.7),
                      child: const Itxt(text: 'Delete').p8())
                  .py8(),
            )),
            PopupMenuItem(
                child: InkWell(
              onTap: () => bottomPop(
                  context, MediaQuery.of(context).size.height * 0.3,
                  child: VStack(
                      alignment: MainAxisAlignment.center,
                      crossAlignment: CrossAxisAlignment.center,
                      [
                        const SizedBox(height: 15),
                        const Ttxt(text: 'New medication reminder'),
                        FormfieldX(
                          label: 'Time',
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
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                if (selecTime != null) {
                                  final tz.TZDateTime now =
                                      tz.TZDateTime.now(tz.local);

                                  var selectedDateTime = tz.TZDateTime(
                                      tz.local,
                                      now.year,
                                      now.month,
                                      now.day,
                                      selecTime.hour,
                                      selecTime.minute);
                                  _alarmTime = selectedDateTime;
                                  time.text = DateFormat('HH:mm')
                                      .format(selectedDateTime);
                                }
                              },
                              icon: const Icon(Icons.alarm_add_rounded)),
                        ),
                        ElevatedButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Confirm action',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Do you want to proceed with action?',
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      context.pop();
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
                                                            .meds[widget.index]
                                                            .medicinename,
                                                        time: time.text,
                                                        body:
                                                            ' ${widget.meds[widget.index].dose} dose(s) of ${widget.meds[widget.index].medicinename}',
                                                      );

                                                      rcontroller
                                                          .addReminder(rmodel)
                                                          .whenComplete(() {
                                                        NotificationBundle()
                                                            .onSaveAlarm(
                                                          components:
                                                              DateTimeComponents
                                                                  .time,
                                                          alarmTime: _alarmTime,
                                                          body: rmodel.body,
                                                          id: rmodel.id
                                                              .toString(),
                                                          title: widget
                                                              .meds[
                                                                  widget.index]
                                                              .medicinename,
                                                        );
                                                      }).then((value) {
                                                        context.pop(context);
                                                        time.clear();
                                                        return VxToast.show(
                                                            context,
                                                            textSize: 11,
                                                            msg:
                                                                'reminder added successfully.',
                                                            bgColor: const Color
                                                                    .fromARGB(
                                                                255,
                                                                38,
                                                                99,
                                                                40),
                                                            textColor:
                                                                Colors.white,
                                                            pdHorizontal: 30,
                                                            pdVertical: 20);
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 13,
                                                          fontFamily: 'Popb'),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  TextButton(
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontFamily: 'Popb'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                            child: const Itxt(text: 'Add Reminder').p4()),
                        const SizedBox(height: 20)
                      ]).p12()),
              child: Card(
                  color: kprimary.withOpacity(0.7),
                  child: const Itxt(text: 'Set Reminder').p8()),
            )),
          ],
          child: Btxt(text: 'Dosage: ${widget.meds[widget.index].dose!}'),
        )).py8();
  }
}

bottomPop(context, double h, {required Widget child}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
            height: h,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          ));
}

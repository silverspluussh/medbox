import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/meds/addmed.dart';
import 'package:MedBox/version2/UI/meds/viewmed.dart';
import 'package:MedBox/version2/wiis/custom_appbar.dart';
import 'package:MedBox/version2/wiis/shimmer.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../firebase/medicfirebase.dart';
import '../../models/medication_model.dart';
import '../../models/reminders_model.dart';
import '../../sqflite/reminderlocal.dart';
import '../../utilites/pushnotifications.dart';
import '../../utilites/randomgen.dart';
import '../../wiis/buttons.dart';
import '../../wiis/formfieldwidget.dart';

class Medicate extends ConsumerWidget {
  const Medicate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(streamMedicationsProvider);
    Size size = MediaQuery.sizeOf(context);

    return CustomScrollView(slivers: [
      const CustomAppbar(),
      meds.when(
          data: (data) => SliverList.builder(
              itemCount: data.isEmpty ? 1 : data.length,
              itemBuilder: (context, index) => data.isEmpty
                  ? SizedBox(
                      height: 300,
                      width: 500,
                      child: Lottie.asset('assets/lottie/empty.json',
                              height: 150, width: 100)
                          .centered(),
                    ).centered()
                  : Dismissible(
                      key: Key("${data[index].did}"),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) => showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Ltxt(text: 'Delete medication?')
                                  .centered(),
                              content: const Btxt(
                                text:
                                    'Are you sure you want to delete medication?',
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              actionsPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              actions: [
                                CancelBtn(
                                    function: () => Navigator.pop(context),
                                    text: 'Cancel'),
                                ConfirmBtn(
                                  function: () {
                                    final aduro =
                                        ref.watch(medicationFirebaseProvider);

                                    aduro
                                        .deleteMedication(mid: data[index].did!)
                                        .whenComplete(() => context.pop());
                                  },
                                  text: 'Remove',
                                )
                              ],
                            );
                          }),
                      child: MedCard(data, index))),
          error: (err, st) => SliverToBoxAdapter(
                child: Text(err.toString()),
              ),
          loading: () => SliverList.builder(
              itemCount: 6,
              itemBuilder: ((context, index) =>
                  const ShimmerWidget.rectangular(height: 70).py12()))),
      Container(
        width: size.width * 0.8,
        margin: const EdgeInsets.symmetric(vertical: 25),
        height: 45,
        decoration: BoxDecoration(
            color: kprimary.withOpacity(0.85),
            borderRadius: BorderRadius.circular(15)),
        child: GestureDetector(
          onTap: () => context.nextPage(const Addmedication()),
          child: const Text('Add Medication',
                  style: TextStyle(
                      fontFamily: 'Pop', fontSize: 14, color: Colors.white))
              .centered(),
        ),
      ).centered().sliverToBoxAdapter(),
      100.heightBox.sliverToBoxAdapter(),
    ]);
  }
}

class MedCard extends ConsumerStatefulWidget {
  const MedCard(this.meds, this.index, {super.key});
  final List<MModel> meds;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MedCardState();
}

class _MedCardState extends ConsumerState<MedCard> {
  TextEditingController time = TextEditingController();

  DateTime? alarmTime;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1.1, color: Colors.grey)),
      child: HStack([
        GestureDetector(
          onTap: () => context.nextPage(ViewMed(widget.meds[widget.index])),
          child: Image.asset(
            widget.meds[widget.index].image!,
            height: 50,
            width: size.width * 0.2,
          ),
        ),
        10.widthBox,
        VStack([
          Ltxt(text: widget.meds[widget.index].medicinename!.capitalized),
          5.heightBox,
          Row(
            children: [
              Stxt(text: widget.meds[widget.index].medicinetype!.capitalized),
              10.widthBox,
              Stxt(
                  text: widget.meds[widget.index].image!
                      .split("/")
                      .last
                      .split(".")
                      .first
                      .capitalized),
            ],
          ),
          5.heightBox,
          SizedBox(
            height: 35,
            child: Ltxt(text: widget.meds[widget.index].dose!.capitalized),
          ),
        ]),
        const Spacer(),
        IconButton(
            onPressed: () => showModalBottomSheet(
                context: context,
                showDragHandle: true,
                enableDrag: true,
                builder: (context) => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child:
                            VStack(crossAlignment: CrossAxisAlignment.start, [
                          10.heightBox,
                          Image.asset("assets/icons/reminder.png",
                              width: 80, height: 80),
                          10.heightBox,
                          Stxt(text: widget.meds[widget.index].medicinename!),
                          10.heightBox,
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
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  if (selecTime != null) {
                                    final DateTime now = DateTime.now();

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
                                icon: const Icon(Icons.alarm_add_rounded)),
                          ),
                          15.heightBox,
                          GestureDetector(
                            onTap: () => showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title:
                                        const Ltxt(text: 'Schedule medication?')
                                            .centered(),
                                    content: const Btxt(
                                      text:
                                          'Are you sure you want to  make a schedule?',
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    actionsPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    actions: [
                                      CancelBtn(
                                          function: () =>
                                              Navigator.of(context).pop(false),
                                          text: 'Cancel'),
                                      ConfirmBtn(
                                        function: () {
                                          final rcontroller =
                                              ref.watch(remindersDbProvider);
                                          final rmodel = RModel(
                                            date: DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now()),
                                            id: idg(),
                                            medicinename: widget
                                                .meds[widget.index]
                                                .medicinename,
                                            time: time.text,
                                            body:
                                                '${FirebaseAuth.instance.currentUser!.displayName}, time to take ${widget.meds[widget.index].medicinename}',
                                          );

                                          rcontroller
                                              .addReminder(rmodel)
                                              .whenComplete(() {
                                            NotificationBundle().onSaveAlarm(
                                              components:
                                                  DateTimeComponents.time,
                                              alarmTime: alarmTime,
                                              body: rmodel.body,
                                              id: rmodel.id.toString(),
                                              title: widget.meds[widget.index]
                                                  .medicinename,
                                            );
                                          }).then((value) {
                                            context.pop(context);
                                            time.clear();
                                            return VxToast.show(context,
                                                textSize: 11,
                                                msg:
                                                    'Reminder created successfully.',
                                                bgColor: const Color.fromARGB(
                                                    255, 38, 99, 40),
                                                textColor: Colors.white,
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
                              margin: const EdgeInsets.symmetric(vertical: 25),
                              height: 45,
                              decoration: BoxDecoration(
                                  color: kprimary.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(15)),
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
            icon:
                const ImageIcon(AssetImage('assets/icons/reminders-15-64.png')),
            iconSize: 35),
      ]),
    ).animate().shakeX();
  }
}

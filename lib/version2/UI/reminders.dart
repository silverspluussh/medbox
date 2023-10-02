import 'package:MedBox/version2/models/reminders_model.dart';
import 'package:MedBox/version2/sqflite/reminderlocal.dart';
import 'package:MedBox/version2/utilites/pushnotifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../wiis/txt.dart';

class Reminders extends ConsumerStatefulWidget {
  const Reminders({super.key});

  @override
  ConsumerState<Reminders> createState() => _RemindersState();
}

class _RemindersState extends ConsumerState<Reminders> {
  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersDbProvider);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 45,
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: kprimary,
              )),
          centerTitle: true,
          title: Ltxt(text: 'Reminders'.toUpperCase()),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FutureBuilder(
              future: reminders.fetchReminders(),
              builder: (context, stream) {
                if (stream.hasData) {
                  List<RModel> r = stream.data!;
                  return ListView.builder(
                      itemCount: r.isNotEmpty ? r.length : 1,
                      itemBuilder: (context, index) {
                        return r.isNotEmpty
                            ? MedCard(
                                index: index,
                                model: r,
                                color: medColor[index % 4],
                              ).scale105()
                            : SizedBox(
                                height: 700,
                                width: 500,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/lottie/empty.json',
                                            height: 150, width: 100)
                                        .centered(),
                                    15.heightBox,
                                    const Ttxt(text: 'No reminders to display.')
                                  ],
                                ),
                              );
                      });
                }
                return const SizedBox(
                    child: Ltxt(text: 'No reminders set at the moment.'));
              }),
        ));
  }
}

class MedCard extends ConsumerStatefulWidget {
  const MedCard(
      {required this.color,
      required this.index,
      required this.model,
      super.key});
  final Color color;
  final List<RModel> model;
  final int index;

  @override
  ConsumerState<MedCard> createState() => _MedCardState();
}

class _MedCardState extends ConsumerState<MedCard> {
  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersDbProvider);

    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: size.width * 0.85,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [widget.color.withOpacity(0.5), Colors.black45],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight),
                color: kprimary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 10,
                  foregroundColor: medColor[widget.index % 4],
                  child: const Icon(Icons.check_circle, size: 21).centered(),
                ),
                10.widthBox,
                SizedBox(
                  width: size.width * 0.5,
                  child: VStack([
                    Btxt(text: widget.model[widget.index].medicinename!),
                    5.heightBox,
                    Itxt(text: '${widget.model[widget.index].body}')
                  ]),
                ),
                10.widthBox,
                VStack([
                  Card(
                    color: kwhite,
                    child: Btxt(text: widget.model[widget.index].time!)
                        .px4()
                        .py4(),
                  ),
                  10.heightBox,
                  IconButton(
                      onPressed: () async {
                        await reminders
                            .delReminder(widget.model[widget.index].id!)
                            .then((value) async => await NotificationBundle()
                                .deleteAlarm(id: widget.model[widget.index].id))
                            .whenComplete(() {
                          setState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 30,
                        color: Colors.red,
                      ))
                ])
              ],
            ),
          ),
          Container(
            color: widget.color,
            padding: const EdgeInsets.all(0),
            width: 5,
            height: size.height * 0.08,
          )
        ],
      ),
    ).p8();
  }
}

import 'package:MedBox/version2/firebase/appointment.dart';
import 'package:MedBox/version2/models/reminders_model.dart';
import 'package:MedBox/version2/sqflite/reminderlocal.dart';
import 'package:MedBox/version2/utilites/pushnotifications.dart';
import 'package:MedBox/version2/wiis/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../providers.dart/authprovider.dart';
import '../wiis/shimmer.dart';
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
    final aps = ref.watch(streamAppointmentsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: kprimary,
              )),
          centerTitle: true,
          title: const Ltxt(text: 'Reminders'),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: TabBar(tabs: [
                ...['Medications', 'Appointments'].map((e) => Tab(
                      text: e,
                    ))
              ])),
        ),
        body: TabBarView(children: [
          Padding(
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
                                  color: medColor[index % 4],
                                  child: ListTile(
                                      title: Ttxt(text: r[index].medicinename!),
                                      subtitle: Stxt(text: '${r[index].body}'),
                                      leading: CircleAvatar(
                                        radius: 10,
                                        foregroundColor: medColor[index % 4],
                                        child: const Icon(Icons.check_circle,
                                                size: 21)
                                            .centered(),
                                      ),
                                      trailing: PopupMenuButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Card(
                                            color: kwhite,
                                            child: Ttxt(text: r[index].time!)
                                                .px4()
                                                .py4(),
                                          ),
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    child: InkWell(
                                                  onTap: () {
                                                    context.pop(context);
                                                    reminders
                                                        .delReminder(
                                                            r[index].id!)
                                                        .whenComplete(() {
                                                      NotificationBundle()
                                                          .deleteAlarm(
                                                              id: r[index].id)
                                                          .whenComplete(() {
                                                        setState(() {});
                                                      });
                                                    });
                                                  },
                                                  child: Card(
                                                      color:
                                                          kred.withOpacity(0.7),
                                                      child: const Btxt(
                                                              text:
                                                                  'Delete reminder')
                                                          .p8()),
                                                )),
                                              ])),
                                )
                              : SizedBox(
                                  height: 300,
                                  width: 500,
                                  child:
                                      Lottie.asset('assets/lottie/empty.json')
                                          .centered(),
                                );
                        });
                  }
                  return const SizedBox(
                      child: Ltxt(text: 'No reminders set atm.'));
                }),
          ),
          AsyncValueWidget(
              loading: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: 5,
                  itemBuilder: (con, index) =>
                      const ShimmerWidget.rectangular(height: 50)),
              value: aps,
              data: (ap) => ap.isNotEmpty
                  ? ListView.builder(
                      itemCount: ap.length,
                      itemBuilder: (context, index) {
                        final user =
                            ref.watch(authRepositoryProvider).currentUser;
                        final apps = ref.watch(appointmentFirebaseProvider);
                        return MedCard(
                          color: medColor[index % 4],
                          child: ListTile(
                            title: Ttxt(text: ap[index].testtype ?? ''),
                            subtitle: Card(
                                color: kwhite,
                                child:
                                    Stxt(text: ap[index].pharmacy ?? '').p4()),
                            leading: CircleAvatar(
                              radius: 10,
                              foregroundColor: medColor[index % 4],
                              child: const Icon(Icons.check_circle, size: 21)
                                  .centered(),
                            ),
                            trailing: PopupMenuButton(
                                child: Card(
                                  color: kwhite,
                                  child: Btxt(text: ap[index].date ?? '')
                                      .px4()
                                      .py4(),
                                ),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: InkWell(
                                        onTap: () {
                                          context.pop(context);
                                          apps
                                              .deleteAp(
                                                  uid: user!.uid,
                                                  aid: ap[index].aid ?? '')
                                              .whenComplete(() {
                                            NotificationBundle()
                                                .deleteAlarm(id: ap[index].aid)
                                                .whenComplete(() {
                                              setState(() {});
                                            });
                                          });
                                        },
                                        child: Card(
                                            color: kred.withOpacity(0.7),
                                            child: const Btxt(
                                                    text: 'Cancel Appointment')
                                                .p8()),
                                      )),
                                    ]),
                          ),
                        );
                      })
                  : Lottie.asset('assets/lottie/empty.json').centered()),
        ]),
      ),
    );
  }
}

class MedCard extends ConsumerWidget {
  const MedCard({required this.color, required this.child, super.key});
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.12,
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.12,
            width: size.width * 0.8,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color.withOpacity(0.5), Colors.black45],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight),
                color: kprimary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15)),
            child: child,
          ),
          Container(
            color: color,
            padding: const EdgeInsets.all(0),
            width: 5,
            height: size.height * 0.1,
          )
        ],
      ),
    ).p8();
  }
}

import 'package:MedBox/presentation/pages/reminders/setalarm.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/data/repos/Dbhelpers/medicationdb.dart';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/presentation/pages/medication/add_medication_page.dart';
import 'package:MedBox/utils/extensions/photos_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../domain/models/medication_model.dart';
import '../../widgets/formfieldwidget.dart';

class Medications extends StatefulWidget {
  const Medications({super.key});

  @override
  State<Medications> createState() => _MedicationsState();
}

class _MedicationsState extends State<Medications> {
  List<String> medtype = ['medications', 'prescription'];
  TextEditingController medname = TextEditingController();
  TextEditingController medicinetype = TextEditingController();
  TextEditingController dose = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: MedicationsDB().getmeds(),
        builder: (context, medic) {
          if (medic.hasData) {
            List<MModel> medication = medic.data!;

            return Stack(
              children: [
                CustomScrollView(slivers: [
                  medication.isNotEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Slidable(
                              direction: Axis.horizontal,
                              startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                        flex: 2,
                                        borderRadius: BorderRadius.circular(15),
                                        icon: Icons.delete_outline_rounded,
                                        backgroundColor: kred.withOpacity(0.7),
                                        onPressed: (context) async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  backgroundColor: Colors.green,
                                                  child: Container(
                                                    height: size.height * 0.3,
                                                    width: size.width * 0.7,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Remove medicine',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                            'Are you sure you want to delete medication?',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall),
                                                        const SizedBox(
                                                            height: 10),
                                                        SizedBox(
                                                          height: 40,
                                                          width:
                                                              size.width * 0.7,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    MedicationsDB()
                                                                        .deletemedication(medication[index]
                                                                            .id!)
                                                                        .then(
                                                                            (value) {
                                                                      setState(
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      'Yes',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall)),
                                                              const Spacer(),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'No',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall)),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }),
                                    const SizedBox(width: 5),
                                    SlidableAction(
                                        flex: 2,
                                        borderRadius: BorderRadius.circular(15),
                                        icon: Icons.edit_outlined,
                                        backgroundColor:
                                            kprimary.withOpacity(0.5),
                                        onPressed: (context) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  elevation: 5,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              kBackgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      width: size.width * 0.85,
                                                      height: size.height * 0.6,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          FormfieldX(
                                                              readonly: false,
                                                              hinttext: medication[
                                                                      index]
                                                                  .medicinename!,
                                                              label:
                                                                  'Medicine name',
                                                              controller:
                                                                  medname),
                                                          FormfieldX(
                                                              readonly: false,
                                                              label: 'Dosage',
                                                              hinttext:
                                                                  medication[
                                                                          index]
                                                                      .dose!,
                                                              controller: dose),
                                                          FormfieldX(
                                                            readonly: true,
                                                            suffix:
                                                                DropdownButton(
                                                                    underline: const SizedBox(
                                                                        height:
                                                                            0),
                                                                    icon: const Icon(Icons.keyboard_arrow_down,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            30),
                                                                    elevation:
                                                                        5,
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            'Pop',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12),
                                                                    items: medtype.map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                        val) {
                                                                      return DropdownMenuItem<
                                                                              String>(
                                                                          value: val
                                                                              .toString(),
                                                                          child:
                                                                              Text(val.toString()));
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (val) {
                                                                      setState(
                                                                          () {
                                                                        medicinetype.text =
                                                                            val!;
                                                                      });
                                                                    }),
                                                            controller:
                                                                medicinetype,
                                                            hinttext: medication[
                                                                    index]
                                                                .medicinetype!,
                                                            label:
                                                                'Medication type',
                                                          ),
                                                          const SizedBox(
                                                              height: 30),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                MModel mModel =
                                                                    MModel(
                                                                  dose: dose
                                                                          .text
                                                                          .isNotBlank
                                                                      ? dose
                                                                          .text
                                                                      : medication[
                                                                              index]
                                                                          .dose,
                                                                  image: medication[
                                                                          index]
                                                                      .image,
                                                                  id: medication[
                                                                          index]
                                                                      .id,
                                                                  medicinename: medname
                                                                          .text
                                                                          .isNotBlank
                                                                      ? medname
                                                                          .text
                                                                      : medication[
                                                                              index]
                                                                          .medicinename,
                                                                  medicinetype: medicinetype
                                                                          .text
                                                                          .isNotBlank
                                                                      ? medicinetype
                                                                          .text
                                                                      : medication[
                                                                              index]
                                                                          .medicinetype,
                                                                );
                                                                MedicationsDB()
                                                                    .updatemedicine(
                                                                        mModel)
                                                                    .then(
                                                                        (value) {
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                              child: Text(
                                                                'Save',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleSmall,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ))
                                                        ],
                                                      )),
                                                );
                                              });
                                        }),
                                  ]),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dragDismissible: false,
                                children: [
                                  SlidableAction(
                                      flex: 1,
                                      borderRadius: BorderRadius.circular(15),
                                      icon: Icons.add_alarm_rounded,
                                      backgroundColor:
                                          kprimary.withOpacity(0.5),
                                      onPressed: (context) async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SetAlarm(
                                                    dose:
                                                        medication[index].dose!,
                                                    medicinename:
                                                        medication[index]
                                                            .medicinename!)));
                                      }),
                                ],
                              ),
                              child: ListTile(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: kBackgroundColor,
                                    elevation: 10,
                                    child: SizedBox(
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(medication[index].medicinename!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                          const SizedBox(height: 10),
                                          Text(medication[index].medicinetype!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                          const SizedBox(height: 10),
                                          Text(medication[index].dose!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ],
                                      ).p8(),
                                    ),
                                  ),
                                ),
                                leading: Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  height: 40,
                                  width: (size.width - 90) * 0.4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: MemoryImage(Utility()
                                          .dataFromBase64String(
                                              medication[index].image!)),
                                    ),
                                    border: Border.all(
                                        width: 1,
                                        color: kprimary.withOpacity(0.3)),
                                  ),
                                ),
                                title: Text(
                                    medication[index]
                                        .medicinename!
                                        .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                subtitle: Text(
                                  '${medication[index].medicinetype}'
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'Pop',
                                      color: kred,
                                      fontWeight: FontWeight.w300),
                                ),
                              ).p8(),
                            ),
                            childCount: medication.length,
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: SizedBox(
                              width: size.width - 90,
                              height: size.height * 0.5,
                              child: Center(
                                child: Column(
                                  children: [
                                    Lottie.asset('assets/lottie/not-found.json',
                                        height: size.height * 0.35,
                                        width: size.width * 0.3,
                                        animate: true,
                                        reverse: true),
                                    const SizedBox(height: 20),
                                    Text("Medication data not set yet.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall)
                                        .centered(),
                                  ],
                                ),
                              )),
                        ),
                ]),
                Positioned(
                    bottom: 30,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddMedications()));
                      },
                      onLongPress: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kprimary.withOpacity(0.6)),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ))
              ],
            )
                .animate()
                .fadeIn(duration: 100.milliseconds, delay: 50.milliseconds);
          }
          return SizedBox(
                  width: size.width - 90,
                  height: size.height * 0.5,
                  child: Center(
                    child: Column(
                      children: [
                        Lottie.asset('assets/lottie/not-found.json',
                            height: size.height * 0.35,
                            width: size.width * 0.3,
                            animate: true,
                            reverse: true),
                        const SizedBox(height: 20),
                        Text("Medication data not set yet.",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ).centered(),
                  ))
              .animate()
              .slideX(duration: 300.milliseconds, delay: 100.milliseconds);
        });
  }
}

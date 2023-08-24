import 'dart:developer';
import 'dart:typed_data';

import 'package:MedBox/constants/datas.dart';
import 'package:MedBox/version2/firebase/medicfirebase.dart';
import 'package:MedBox/version2/models/medication_model.dart';
import 'package:MedBox/version2/models/reminders_model.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:MedBox/version2/sqflite/reminderlocal.dart';
import 'package:MedBox/version2/utilites/pushnotifications.dart';
import 'package:MedBox/version2/utilites/randomgen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../constants/colors.dart';
import '../../utilites/photos_extension.dart';
import '../../wiis/formfieldwidget.dart';
import '../../wiis/txt.dart';
import 'package:timezone/timezone.dart' as tz;

class AddMed extends ConsumerStatefulWidget {
  const AddMed({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddMedState();
}

class _AddMedState extends ConsumerState<AddMed> {
  final formkey = GlobalKey<FormState>();

  TextEditingController time = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController dose = TextEditingController();

  bool loader = false;

  @override
  void dispose() {
    time.dispose();
    name.dispose();
    type.dispose();
    dose.dispose();

    super.dispose();
  }

  String? imagepath;
  Uint8List? imagepickedd;

  pickImageFromLocal() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        imagepickedd = result.files.first.bytes;
        imagepath = Utility.base64String(imagepickedd!);
      });
    } else {}
  }

  tz.TZDateTime? _alarmTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: kprimary,
                        )),
                    const Spacer(),
                    Ttxt(text: AppLocalizations.of(context)!.addmed),
                    const Spacer()
                  ],
                ),
                Row(
                  children: [
                    FormfieldX(
                      label: AppLocalizations.of(context)!.medname,
                      controller: name,
                      readonly: false,
                      hinttext: 'eg. paracetamol',
                      inputType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'field cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                        label: AppLocalizations.of(context)!.medtype,
                        readonly: true,
                        controller: type,
                        hinttext: 'eg. medication',
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'field cannot be empty';
                          }
                          return null;
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
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                      label: AppLocalizations.of(context)!.dose,
                      readonly: false,
                      hinttext: 'eg. 2',
                      controller: dose,
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'field cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                      label: AppLocalizations.of(context)!.t,
                      controller: time,
                      readonly: true,
                      hinttext: time.text.isEmpty ? '0:00' : time.text,
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'field cannot be empty';
                        }
                        return null;
                      },
                      suffix: IconButton(
                          onPressed: () async {
                            var selecTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (selecTime != null) {
                              var selectedDateTime = tz.TZDateTime(
                                  tz.local, selecTime.hour, selecTime.minute);
                              _alarmTime = selectedDateTime;
                              time.text =
                                  DateFormat('HH:mm').format(selectedDateTime);
                            }
                          },
                          icon: const Icon(Icons.alarm_add_sharp)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: imagepath != null
                            ? MemoryImage(imagepickedd!) as ImageProvider
                            : const AssetImage('assets/icons/pills-3.png'),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: kprimary)),
                  child: Center(
                    child: IconButton(
                        onPressed: () => pickImageFromLocal(),
                        icon: const Icon(Icons.add_a_photo_rounded, size: 40)),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                      onPressed: () async {
                        final rcontroller = ref.watch(remindersDbProvider);
                        final mcontroller =
                            ref.watch(medicationFirebaseProvider);
                        final user =
                            ref.watch(authRepositoryProvider).currentUser;

                        final mmodel = MModel(
                            medicinename: name.text,
                            dose: dose.text,
                            mid: idg().toString(),
                            medicinetype: type.text,
                            image: imagepath.isEmptyOrNull
                                ? defaulticon
                                : imagepath);

                        final val = formkey.currentState!.validate();

                        if (val == true) {
                          setState(() {
                            loader = true;
                          });
                          try {
                            mcontroller
                                .addMedication(uid: user!.uid, med: mmodel)
                                .then((val) async {
                              final rmodel = RModel(
                                  date: DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  time: time.text,
                                  body: '${dose.text} dose(s) of ${name.text}',
                                  medicinename: name.text,
                                  id: idg());
                              await rcontroller
                                  .addReminder(rmodel)
                                  .then((value) async {
                                await NotificationBundle()
                                    .onSaveAlarm(
                                        components: DateTimeComponents.time,
                                        alarmTime: _alarmTime,
                                        id: rmodel.id.toString(),
                                        body:
                                            '${dose.text} dose(s) of ${name.text}',
                                        title: mmodel.medicinename)
                                    .whenComplete(() {
                                  setState(() {
                                    loader = false;
                                  });
                                  context.pop();
                                  return VxToast.show(context,
                                      textSize: 11,
                                      msg: 'Medicine added successfully.',
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
                            log(e.toString());
                          }
                        }
                      },
                      child: Itxt(text: AppLocalizations.of(context)!.addmed)
                          .px8()
                          .py4()),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

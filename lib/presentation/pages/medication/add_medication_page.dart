// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'dart:typed_data';
import 'package:MedBox/constants/fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/data/repos/Dbhelpers/medicationdb.dart';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:MedBox/domain/models/medication_model.dart';
import 'package:MedBox/utils/extensions/photos_extension.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../widgets/formfieldwidget.dart';
import '../renderer.dart';

class AddMedications extends StatefulWidget {
  const AddMedications({Key key}) : super(key: key);

  @override
  State<AddMedications> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedications> {
  ///

  final medformkey = GlobalKey<FormState>();

  TextEditingController medname = TextEditingController();
  TextEditingController medicinetype = TextEditingController();
  TextEditingController dose = TextEditingController();
  TextEditingController alarm = TextEditingController();
  TextEditingController notificaton = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController hours = TextEditingController();
  TextEditingController minutes = TextEditingController();
  TextEditingController timeset = TextEditingController();

  ///

  bool alarmbool = false;
  bool notifbool = false;
  DateTime dateTime = DateTime.now();
  tz.TZDateTime datime =
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 6));

  List<String> medtype = [
    'medications',
    'prescription',
  ];
  String vall;

  ///
  PageController pagecontroller = PageController();
  MedicationsDB medicationsDB = MedicationsDB();

  @override
  void dispose() {
    pagecontroller.dispose();
    super.dispose();
  }

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    vall = medtype.last;
    pagecontroller.addListener(() {
      setState(() {
        currentPage = pagecontroller.page?.toInt() ?? 0;
      });
    });
  }

  String imagepath;
  Uint8List imagepickedd;
  TimeOfDay initialtime = TimeOfDay.now();
  TimeOfDay newtimeofday;
  String meridian;

  pickImageFromLocal() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      withData: true,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        imagepickedd = result.files.first.bytes;
        imagepath = imagepickedd.toString();
        image.text = Utility.base64String(imagepickedd);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add new medication', style: popheaderB),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Form(
              key: medformkey,
              child: SizedBox(
                height: size.height * 0.8,
                width: size.width,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pagecontroller,
                  children: [firstpage(), thirdpage()],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _progressindicator(
                    color: currentPage == 0
                        ? AppColors.primaryColor
                        : const Color.fromARGB(31, 44, 44, 44)),
                const SizedBox(width: 15),
                _progressindicator(
                    color: currentPage == 1
                        ? AppColors.primaryColor
                        : const Color.fromARGB(31, 59, 59, 59)),
              ],
            ),
          ),
        ],
      ).p8(),
    );
  }

  thirdpage() {
    Size size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            width: size.width * 0.78,
            child: const Text(
              'Upload a photo of the medication or add from gallery',
              textAlign: TextAlign.center,
              style: popheaderB,
            ),
          ).py8(),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            width: size.width * 0.6,
            height: size.height * 0.35,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: imagepath != null
                      ? MemoryImage(imagepickedd) as ImageProvider
                      : const AssetImage('assets/images/pillbottle-min.jpg'),
                ),
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primaryColor.withOpacity(0.5)),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {
                    pickImageFromLocal();
                  },
                  icon: const Icon(
                    Icons.add_a_photo_outlined,
                    size: 50,
                    color: AppColors.primaryColor,
                  )),
            ),
          ),
          const SizedBox(height: 60),
        ])),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              String desc =
                  'Reminder to take ${dose.text} dose(s) of ${medname.text}';

              MModel mModel = MModel(
                dose: dose.text,
                id: Random().nextInt(150),
                image: image.text,
                medicinename: medname.text,
                medicinetype: medicinetype.text,
              );

              medicationsDB
                  .addmedController(mModel: mModel)
                  .then((value) async {
                await NotifConsole()
                    .setreminder(
                        title: medname.text,
                        body: desc,
                        payload: '${hours.text}:${minutes.text} $meridian',
                        hour: int.parse(hours.text),
                        minute: int.parse(minutes.text))
                    .then((value) {
                  setState(() {});

                  VxToast.show(context,
                      msg: 'Medicine added successfully.',
                      bgColor: const Color.fromARGB(255, 38, 99, 40),
                      textColor: Colors.white,
                      pdHorizontal: 30,
                      pdVertical: 20);
                }).then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Render())));
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              width: size.width * 0.5,
              height: 60,
              child: const Center(
                child: Text(
                  'Add Medication',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Popb', fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  firstpage() {
    Size size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Text(
            'Medicine Details:',
            style: popheaderB,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: size.height * 0.6,
            width: size.width,
            child: Flex(
              direction: Axis.vertical,
              children: [
                const SizedBox(height: 50),
                FormfieldX(
                    readonly: false,
                    validator: (e) {
                      if (e.isEmpty) {
                        return 'Field needs to have inputs';
                      }
                      return null;
                    },
                    inputType: TextInputType.name,
                    hinttext: 'eg. paracetamol',
                    label: 'Medication name',
                    controller: medname),
                FormfieldX(
                  readonly: true,
                  controller: medicinetype,
                  suffix: DropdownButton(
                      underline: const SizedBox(height: 0),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.black, size: 30),
                      elevation: 5,
                      items:
                          medtype.map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem<String>(
                            value: val.toString(),
                            child: Text(
                              val.toString(),
                              style: popblack,
                            ));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          medicinetype.text = val;
                          vall = val;
                        });
                      }).px4(),
                  hinttext: vall ?? 'eg. medication',
                  label: 'Medication type',
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Field needs to have inputs';
                    }
                    return null;
                  },
                ),
                FormfieldX(
                  readonly: false,
                  inputType: TextInputType.number,
                  hinttext: 'eg. 3 pills per intake',
                  label: 'Dosage',
                  controller: dose,
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Field needs to have inputs';
                    }
                    return null;
                  },
                ),
                FormfieldX(
                  readonly: true,
                  label: 'Time',
                  controller: timeset,
                  hinttext: 'Set time',
                  suffix: IconButton(
                      onPressed: () async {
                        newtimeofday = await showTimePicker(
                                context: context, initialTime: initialtime)
                            .then((value) {
                          setState(() {
                            hours.text = value.hour.toString();
                            minutes.text = value.minute.toString();
                            timeset.text =
                                '${value.hour.toString()}:${value.minute.toString()} $meridian';
                            if (value.hour <= 11) {
                              meridian = 'AM';
                            } else if (value.hour >= 12) {
                              meridian = 'PM';
                            }
                          });
                          return null;
                        });
                      },
                      icon: const Icon(
                        Icons.more_time_rounded,
                        size: 25,
                        color: AppColors.primaryColor,
                      )),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TextButton.icon(
            onPressed: () {
              final filled = medformkey.currentState.validate();

              if (filled == true) {
                pagecontroller.nextPage(
                    duration: 100.milliseconds, curve: Curves.easeIn);
                currentPage = 1;
              }
            },
            label: const Text(
              'Next',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.primaryColor,
              ),
            ),
            icon: const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Container _progressindicator({color}) {
    return Container(
      width: 35,
      height: 15,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
    );
  }
}

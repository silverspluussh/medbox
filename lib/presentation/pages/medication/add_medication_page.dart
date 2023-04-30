// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:MedBox/data/repos/Dbhelpers/medicationdb.dart';
import 'package:MedBox/utils/extensions/notification.dart';
import 'package:MedBox/domain/models/medication_model.dart';
import 'package:MedBox/utils/extensions/photos_extension.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../renderer.dart';

class AddMedications extends StatefulWidget {
  const AddMedications({super.key});

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

  ///
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
  }

  List<String> medtype = [
    'medications',
    'prescription',
  ];
  String? vall;

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
    _configureLocalTimeZone();
    vall = medtype.last;
    pagecontroller.addListener(() {
      setState(() {
        currentPage = pagecontroller.page?.toInt() ?? 0;
      });
    });
  }

  String? imagepath;
  Uint8List? imagepickedd;
  TimeOfDay initialtime = TimeOfDay.now();
  TimeOfDay? newtimeofday;
  String? meridian;

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
        imagepath = imagepickedd.toString();
        image.text = Utility.base64String(imagepickedd!);
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
        title: const Text(
          'Add new medication',
          style:
              TextStyle(fontSize: 13, fontFamily: 'Popb', color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              height: size.height * 0.8,
              width: size.width,
              child: PageView(
                controller: pagecontroller,
                children: [firstpage(), thirdpage()],
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
      ),
    );
  }

  thirdpage() {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: medformkey,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: size.width * 0.78,
              child: const Text(
                'Upload a photo of the medication or add from gallery',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Popb', fontSize: 14),
              ),
            ),
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
                        ? MemoryImage(imagepickedd!) as ImageProvider
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
                if (medformkey.currentState!.validate() == true) {
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
                } else {
                  VxToast.show(context,
                      msg: 'Some fields have not been filled.',
                      bgColor: const Color.fromARGB(255, 224, 33, 33),
                      textColor: Colors.white,
                      pdHorizontal: 30,
                      pdVertical: 20);
                }
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
      ),
    );
  }

  firstpage() {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: medformkey,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Text(
              'Medicine Details:',
              style: TextStyle(fontFamily: 'Popb', fontSize: 13),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            inputformfield(
                readonly: false,
                inputType: TextInputType.name,
                hinttext: 'eg. paracetamol',
                title: 'Medication name',
                height: 50,
                width: size.width - 50,
                controller: medname),
            inputformfield(
              readonly: true,
              widget: DropdownButton(
                  underline: const SizedBox(height: 0),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.black, size: 30),
                  elevation: 5,
                  items: medtype.map<DropdownMenuItem<String>>((String val) {
                    return DropdownMenuItem<String>(
                        value: val.toString(),
                        child: Text(
                          val.toString(),
                          style: const TextStyle(fontFamily: 'Pop'),
                        ));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      medicinetype.text = val!;
                      vall = val;
                    });
                  }),
              width: size.width - 50,
              height: 50,
              hinttext: vall ?? 'eg. medication',
              title: 'Medication type',
            ),
            inputformfield(
                readonly: false,
                inputType: TextInputType.number,
                hinttext: 'eg. 3 pills per intake',
                title: 'Dosage',
                controller: dose,
                height: 50,
                widget: const Text(
                  '(pills / tablets)',
                  style: TextStyle(fontFamily: 'Pop', fontSize: 11),
                ),
                width: size.width - 50),
            const Text(
              'Time',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pop',
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                conta(
                    call: () {},
                    controller: timeset,
                    height: 50.0,
                    width: size.width * 0.3,
                    hinttext: 'set time'),
                const SizedBox(width: 50),
                IconButton(
                    onPressed: () async {
                      newtimeofday = await showTimePicker(
                              context: context, initialTime: initialtime)
                          .then((value) {
                        setState(() {
                          hours.text = value!.hour.toString();
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
                    ))
              ],
            ),
            const SizedBox(height: 20),
          ])),
          SliverToBoxAdapter(
            child: TextButton.icon(
              onPressed: () {
                final filled = medformkey.currentState!.validate();

                if (filled == true) {
                  pagecontroller.nextPage(
                      duration: 100.milliseconds, curve: Curves.easeIn);
                  currentPage = 1;
                }
              },
              label: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 17,
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
      ),
    );
  }

  Container _progressindicator({required color}) {
    return Container(
      width: 35,
      height: 15,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
    );
  }

  conta({width, height, controller, hinttext, required VoidCallback? call}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: width!,
        height: height,
        child: TextFormField(
          onTap: call,
          keyboardType: TextInputType.number,
          autofocus: false,
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
                color: Colors.black,
                fontFamily: 'Pop',
                fontSize: 12,
                fontWeight: FontWeight.w400),
            hintText: hinttext,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
          ),
        ),
      ),
    );
  }

  inputformfield(
      {required String title,
      TextEditingController? controller,
      required String hinttext,
      TextInputType? inputType,
      required bool readonly,
      double? width,
      double? height,
      Widget? widget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Pop',
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                const SizedBox(width: 5),
                SizedBox(
                  width: width! * 0.5,
                  height: height,
                  child: TextFormField(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return 'Field needs to have inputs';
                      }
                      return null;
                    },
                    autofocus: false,
                    controller: controller,
                    keyboardType: inputType,
                    readOnly: readonly,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Pop',
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                      hintText: hinttext,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: widget ?? const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

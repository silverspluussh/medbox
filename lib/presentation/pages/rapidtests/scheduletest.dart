import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ScheduleRapidTest extends StatefulWidget {
  const ScheduleRapidTest({super.key});

  @override
  State<ScheduleRapidTest> createState() => _ScheduleRapidTestState();
}

enum Scheduletimes {
  eigtham,
  nineam,
  tenam,
  elevenam,
  twelvepm,
  onepm,
  twopm,
  threepm,
  fourpm,
  fivepm
}

List times = [
  '8:00am',
  '9:00am',
  '10:00am',
  '11:00am',
  '12:00pm',
  '13:00pm',
  '14:00pm',
  '15:00',
  '16:00pm',
  '17:00pm'
];

class _ScheduleRapidTestState extends State<ScheduleRapidTest> {
  final formkey = GlobalKey<FormState>();

  var time = Scheduletimes.tenam;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Schedule Rapid Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Center(
            child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _formwidget(size,
                          label: '*Rapid Test location',
                          hint: 'eg. espat pharmacy,47 military',
                          suffix: DropdownButton(
                            items: [],
                            onChanged: (e) {},
                            icon: const Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: AppColors.primaryColor,
                            ),
                          )),
                      _formwidget(size,
                          label: '*Rapid Test Type',
                          hint: 'eg. malaria test,cholesterol test',
                          suffix: DropdownButton(
                            items: [],
                            onChanged: (e) {},
                            icon: const Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: AppColors.primaryColor,
                            ),
                          )),
                      _formwidget(size,
                          label: '*Full name',
                          hint: 'eg. Francis Ohemeng Amponsah'),
                      _formwidget(size,
                          label: '*Contact', hint: 'eg. 0233495568'),
                      _formwidget(size,
                          label: '*Email Address',
                          hint: 'eg. Francis Ohemeng Amponsah'),
                      _formwidget(size,
                          label: '*Residential Address',
                          hint: 'eg. Plt 50, Teshie Tebibiani'),
                      _formwidget(size, label: '*City', hint: 'eg. Accra'),
                      _formwidget(size,
                          label: '*Add note',
                          hint: 'eg. Have a good day dear sir .',
                          maxlines: 4),
                      const Text('What date and time work best for you?'),
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 25,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(height: 15),
                      _formwidget(size, label: 'Date'),
                      _formwidget(size, label: 'Date', hint: 'Select time'),
                      const SizedBox(height: 30),
                      Card(
                        color: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'BOOK APPOINTMENT',
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'Pop'),
                        ).centered().py12(),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

// Container(
//                                             width: size.width * 0.15,
//                                             color: Colors.blue,
//                                             height: 30),
  _formwidget(Size size, {controller, hint, label, maxlines, suffix}) {
    return SizedBox(
      height: 75,
      width: size.width * 0.72,
      child: VStack(
        [
          Text(label),
          const SizedBox(height: 5),
          SizedBox(
            height: 45,
            width: size.width * 0.7,
            child: TextFormField(
              maxLines: maxlines,
              validator: (e) {
                if (e!.isEmpty) {
                  return 'Field cannot be empty';
                }
                return null;
              },
              controller: controller,
              decoration: InputDecoration(
                  suffix: suffix,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: hint,
                  hintStyle:
                      const TextStyle(fontSize: 12, color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1,
                    ),
                  )),
            ),
          ),
        ],
        alignment: MainAxisAlignment.start,
        crossAlignment: CrossAxisAlignment.start,
      ),
    ).py8();
  }
}

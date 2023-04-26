import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../domain/models/rapidtestmodel.dart';
import '../rapidtests/scheduletest.dart';

class RapidTests extends StatelessWidget {
  const RapidTests({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [_titlebox(size, context), _testlists()],
    );
  }

  SliverList _testlists() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return ListTile(
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(color: AppColors.primaryColor.withOpacity(0.3))),
        leading: const CircleAvatar(
            minRadius: 15,
            foregroundImage: AssetImage('assets/icons/capsules.png'),
            maxRadius: 16),
        title: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
          color: tests[index].testresults == true ? Colors.red : Colors.green,
          child: Text(tests[index].results!).centered().py8(),
        ),
        subtitle: Text(tests[index].testname!),
        trailing: Text(tests[index].testdate!),
      ).p8();
    }, childCount: tests.length));
  }

  SliverToBoxAdapter _titlebox(Size size, BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: size.width,
        height: 50,
        child: HStack([
          const Text(
            'All Test Results',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Popb'),
          ),
          const Spacer(),
          Semantics(
            button: true,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScheduleRapidTest())),
              child: Card(
                color: AppColors.primaryColor,
                elevation: 5,
                child: const Text(
                  'Schedule Test',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pop'),
                ).centered().px16(),
              ),
            ),
          ),
          const SizedBox(width: 30),
          DropdownButton(
              icon: Icon(
                Icons.sort_rounded,
                size: 25,
                color: AppColors.primaryColor.withOpacity(0.6),
              ),
              items: [],
              onChanged: (c) {})
        ]).px12(),
      ).py12(),
    );
  }
}

List<RapidtestModel> tests = [
  RapidtestModel(
      results: 'Postive',
      testdate: '26th Jan,2023',
      testname: 'Malaria',
      testresults: true),
  RapidtestModel(
      results: 'Negative',
      testdate: '26th Jan,2023',
      testname: 'Cholestrol',
      testresults: false),
  RapidtestModel(
      results: 'Negative',
      testdate: '26th Jan,2023',
      testname: 'Hepatitis B',
      testresults: false),
  RapidtestModel(
      results: 'Postive',
      testdate: '26th Jan,2023',
      testname: 'Typhoid',
      testresults: true),
  RapidtestModel(
      results: 'Negative',
      testdate: '26th Jan,2023',
      testname: 'Pregnancy',
      testresults: false),
  RapidtestModel(
      results: 'Negative',
      testdate: '26th Jan,2023',
      testname: 'Sickle Cell',
      testresults: false),
  RapidtestModel(
      results: 'Postive',
      testdate: '26th Jan,2023',
      testname: 'Anaemia',
      testresults: true),
  RapidtestModel(
      results: 'Negative',
      testdate: '26th Jan,2023',
      testname: 'Blood Pressure',
      testresults: false),
];

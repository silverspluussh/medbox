import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../domain/models/rapidtestmodel.dart';

class RapidTests extends StatefulWidget {
  const RapidTests({
    super.key,
  });

  @override
  State<RapidTests> createState() => _RapidTestsState();
}

class _RapidTestsState extends State<RapidTests> {
  String userID = prefs.getString('googlename') ??
      prefs.getString('username') ??
      'Anonymous';

  final Stream<QuerySnapshot> tests = FirebaseFirestore.instance
      .collection('rapidtests')
      .where('patientcontact', isEqualTo: '0557466718')
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rapidtests')
            .doc('joojo')
            .snapshots(),
        builder: ((context, snapshot) => CustomScrollView(
              slivers: [
                _titlebox(size, context),
                snapshot.hasData
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                        return ListTile(
                          tileColor: Colors.white,
                          contentPadding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.3))),
                          leading: const CircleAvatar(
                              minRadius: 15,
                              foregroundImage:
                                  AssetImage('assets/icons/capsules.png'),
                              maxRadius: 16),
                          title: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1)),
                            color: snapshot.data!.data()!['testresults']
                                        [index] ==
                                    true
                                ? Colors.red
                                : Colors.green,
                            child: Text(snapshot.data!
                                    .data()!['results'][index]
                                    .toString()
                                    .trim())
                                .centered()
                                .py8(),
                          ),
                          subtitle: Text(
                            snapshot.data!
                                .data()!['testname'][index]
                                .toString()
                                .trim(),
                            style: const TextStyle(
                                fontFamily: 'Pop',
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          trailing: Text(
                            snapshot.data!
                                .data()!['testdate'][index]
                                .toString()
                                .trim(),
                            style: const TextStyle(
                                fontFamily: 'Pop',
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryColor),
                          ),
                        ).p8();
                      }, childCount: 2))
                    : const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No rapid test available.'),
                        ),
                      )
              ],
            )));
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

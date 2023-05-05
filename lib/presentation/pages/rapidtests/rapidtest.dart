import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class RapidTests extends StatefulWidget {
  const RapidTests({Key key}) : super(key: key);

  @override
  State<RapidTests> createState() => _RapidTestsState();
}

class _RapidTestsState extends State<RapidTests> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rapidtests')
            .where('patientcontact', isEqualTo: SharedCli().getemail())
            .snapshots(),
        builder: ((context, tests) {
          if (tests.hasData) {
            return CustomScrollView(
              slivers: [
                _titlebox(size, context),
                tests.data.docs.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                        return ExpansionTile(
                            backgroundColor: Colors.white,
                            tilePadding: const EdgeInsets.all(10),
                            childrenPadding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: BorderSide(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.3))),
                            leading: const CircleAvatar(
                                minRadius: 15,
                                foregroundImage:
                                    AssetImage('assets/icons/capsules.png'),
                                maxRadius: 16),
                            title: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1)),
                              color: tests.data.docs.first['testresults']
                                          [index] ==
                                      true
                                  ? Colors.red
                                  : Colors.green,
                              child: Text(
                                tests.data.docs[0]['results'][index],
                              ).centered().py8(),
                            ),
                            subtitle: Text(
                              tests.data.docs[0]['testname'][index],
                              style: popblack,
                            ),
                            trailing: const SizedBox(width: 70),
                            children: const [
                              Text(
                                  'This is the body of rapid test. All necessary details will be provided here.',
                                  style: TextStyle(
                                      fontFamily: 'Pop', fontSize: 12)),
                            ]).p8();
                      }, childCount: 2))
                    : const SliverToBoxAdapter(
                        child: Center(
                          child:
                              Text('No rapid test available.', style: popblack),
                        ),
                      )
              ],
            );
          }
          return const Center(
            child: Text(
              'No rapid test available.',
              style: popblack,
            ),
          );
        }));
  }

  SliverToBoxAdapter _titlebox(Size size, BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: size.width,
        height: 50,
        child: const HStack([
          Text(
            'All Test Results',
            style: popheaderB,
          ),
          Spacer(),
          SizedBox(width: 30),
        ]).px12(),
      ).py12(),
    );
  }
}

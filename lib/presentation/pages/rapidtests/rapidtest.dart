import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/domain/sharedpreferences/sharedprefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:velocity_x/velocity_x.dart';

class RapidTests extends StatefulWidget {
  const RapidTests({super.key});

  @override
  State<RapidTests> createState() => _RapidTestsState();
}

class _RapidTestsState extends State<RapidTests> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('profiles')
                .doc(SharedCli().getuserID())
                .collection('rapidtest')
                .doc(SharedCli().getuserID())
                .snapshots(),
            builder: ((context, tests) {
              if (tests.hasData) {
                return CustomScrollView(
                  slivers: [
                    _titlebox(size, context),
                    tests.data!.data()!.isNotEmpty
                        ? SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                            return ExpansionTile(
                                backgroundColor: Colors.white,
                                tilePadding: const EdgeInsets.all(10),
                                childrenPadding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(
                                        color: kprimary.withOpacity(0.3))),
                                leading: const CircleAvatar(
                                    minRadius: 15,
                                    foregroundImage:
                                        AssetImage('assets/icons/capsules.png'),
                                    maxRadius: 16),
                                title: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1)),
                                  color: tests.data!.data()![0]['testresults']
                                              [index] ==
                                          true
                                      ? Colors.red
                                      : Colors.green,
                                  child: Text(
                                    tests.data!.data()![0]['results'][index],
                                  ).centered().py8(),
                                ),
                                subtitle: Text(
                                    tests.data!.data()![0]['testname'][index],
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                trailing: const SizedBox(width: 70),
                                children: [
                                  Text(
                                      'This is the body of rapid test. All necessary details will be provided here.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ]).p8();
                          }, childCount: 2))
                        : SliverToBoxAdapter(
                            child: Center(
                              child: Text('No rapid test available.',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ),
                          )
                  ],
                );
              }
              return Center(
                child: Text('No rapid test available.',
                    style: Theme.of(context).textTheme.titleSmall),
              );
            }))
        .animate()
        .slideX(duration: 300.milliseconds, delay: 100.milliseconds);
  }

  SliverToBoxAdapter _titlebox(Size size, BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: size.width,
        height: 50,
        child: HStack([
          Text('All Test Results',
              style: Theme.of(context).textTheme.titleSmall),
          const Spacer(),
          const SizedBox(width: 30),
        ]).px12(),
      ).py12(),
    );
  }
}

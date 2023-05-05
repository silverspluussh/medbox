import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/colors.dart';
import '../pages/bodyvitals/addvitals.dart';
import '../pages/bodyvitals/history_analysis.dart';

class VitalsButtons extends StatelessWidget {
  const VitalsButtons({
    Key key,
    this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Semantics(
            button: true,
            tooltip: 'Overall vitals history',
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Vitalshistory()));
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 61, 228, 55)
                        .withOpacity(0.6)),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Semantics(
            button: true,
            tooltip: 'Add new vitals',
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddVitals()));
              },
              onLongPress: () {},
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withOpacity(0.6)),
                child: const Icon(
                  Icons.addchart_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ).px2();
  }
}

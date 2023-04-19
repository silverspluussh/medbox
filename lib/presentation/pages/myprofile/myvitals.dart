import 'package:MedBox/data/repos/Dbhelpers/vitalsdb.dart';
import 'package:MedBox/domain/models/vitalsmodel.dart';
import 'package:MedBox/presentation/pages/bodyvitals/vscreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/radialbarchart.dart';
import '../../widgets/vitalsbuttons.dart';

class MyVitals extends StatelessWidget {
  const MyVitals({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: FutureBuilder(
          future: VitalsDB().getvitals(),
          builder: (context, snapshot) {
            List<VModel>? model = snapshot.data;
            if (snapshot.hasData) {
              return model!.isNotEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 30, top: 0),
                          child: SizedBox(
                            height: 55,
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 20),
                                Text(
                                  'Vitals Monitor'.toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: 'Pop',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ).centered(),
                                const Spacer(),
                                VitalsButtons(size: size)
                              ],
                            ),
                          ),
                        )),
                        VitalsMain(vitals: model),
                        SliverToBoxAdapter(
                          child: SizedBox(
                              width: size.width,
                              height: size.height * 0.87,
                              child: RadialBarAngle(
                                model: model,
                              )),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 80))
                      ],
                    )
                  : nodata(size);
            }
            return const SizedBox();
          }),
    );
  }

  nodata(Size size) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/empty.json',
            height: size.height * 0.35,
            width: size.width * 0.3,
          ),
          const SizedBox(height: 20),
          const Text(
            "No health data added at the moment.\nYou can change that tapping on the edit button.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Pop',
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

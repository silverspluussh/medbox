import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/fl_linechart.dart';

class Vitalshistory extends StatelessWidget {
  const Vitalshistory({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                ...icons.map((e) => Tab(
                      icon: ImageIcon(AssetImage(e)),
                    )),
              ],
            ),
          ),
          body: TabBarView(children: [
            CustomScrollView(
              slivers: [
                circularcardsliver(size),
                minavgmax(size,
                    color2: Colors.black,
                    color: AppColors.primaryColor,
                    title: 'title',
                    value: '123'),
                const SliverToBoxAdapter(
                  child: Linechart(),
                )
              ],
            ),
            CustomScrollView(
              slivers: [
                circularcardsliver(size),
                minavgmax(size,
                    color2: Colors.black,
                    color: AppColors.primaryColor,
                    title: 'title',
                    value: '123'),
                const SliverToBoxAdapter(
                  child: Linechart(),
                )
              ],
            ),
            CustomScrollView(
              slivers: [
                circularcardsliver(size),
                minavgmax(size,
                    color2: Colors.black,
                    color: AppColors.primaryColor,
                    title: 'title',
                    value: '123'),
                const SliverToBoxAdapter(
                  child: Linechart(),
                )
              ],
            ),
            CustomScrollView(
              slivers: [
                circularcardsliver(size),
                minavgmax(size,
                    color2: Colors.black,
                    color: AppColors.primaryColor,
                    title: 'title',
                    value: '123'),
                const SliverToBoxAdapter(
                  child: Linechart(),
                )
              ],
            ),
            CustomScrollView(
              slivers: [
                circularcardsliver(size),
                minavgmax(size,
                    color2: Colors.black,
                    color: AppColors.primaryColor,
                    title: 'title',
                    value: '123'),
                const SliverToBoxAdapter(
                  child: Linechart(),
                )
              ],
            ),
          ]),
        ));
  }

  SliverToBoxAdapter minavgmax(Size size,
      {required Color color, required color2, required title, required value}) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: size.width - 20,
        height: size.height * 0.24,
        child: HStack(
          [
            minmaxavgelement(
                title: title, tcolor: color, vcolor: color2, value: value),
            const SizedBox(width: 40),
            Container(
                padding: const EdgeInsets.only(left: 34, right: 34),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                        width: 4,
                        color: AppColors.primaryColor.withOpacity(0.5)),
                    left: BorderSide(
                        width: 4,
                        color: AppColors.primaryColor.withOpacity(0.5)),
                  ),
                ),
                child: minmaxavgelement(
                    title: title, tcolor: color, vcolor: color2, value: value)),
            const SizedBox(width: 40),
            minmaxavgelement(
                title: title, tcolor: color, vcolor: color2, value: value),
          ],
          alignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  minmaxavgelement(
      {required Color tcolor,
      required Color vcolor,
      required title,
      required value}) {
    return VStack([
      Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: tcolor,
          )),
      const SizedBox(height: 30),
      Text(value,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: vcolor,
          )),
      const SizedBox(height: 20),
      Divider(color: AppColors.primaryColor.withOpacity(0.6), thickness: 1),
    ]);
  }

  SliverToBoxAdapter circularcardsliver(Size size) {
    return SliverToBoxAdapter(
      child: Container(
        width: size.width * 0.5,
        height: size.height * 0.22,
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Lottie.asset(
              'assets/lottie/140890-blink.json',
              width: size.width * 0.46,
              height: size.height * 0.23,
            ).centered(),
            Container(
              width: size.width * 0.43,
              height: size.height * 0.2,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2,
                      color: AppColors.primaryColor.withOpacity(0.6))),
              child: const VStack(
                [
                  Text('123',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      )),
                  SizedBox(height: 10),
                  Text('bfg',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      )),
                ],
                alignment: MainAxisAlignment.center,
                crossAlignment: CrossAxisAlignment.center,
              ).centered(),
            ).centered()
          ],
        ),
      ),
    );
  }
}

List icons = [
  'assets/icons/blood-pressure.png',
  'assets/icons/health-12-512.png',
  'assets/icons/temperature.png',
  'assets/icons/heart-beat.png',
  'assets/icons/6-medical-blood-oxygen.png',
];

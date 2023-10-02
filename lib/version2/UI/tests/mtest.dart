import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/UI/tests/viewtest.dart';
import 'package:MedBox/version2/firebase/rtestfirebase.dart';
import 'package:MedBox/version2/models/rapidtestmodel.dart';
import 'package:MedBox/version2/wiis/shimmer.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

class Mtests extends ConsumerWidget {
  const Mtests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(streamTestsProvider);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            toolbarHeight: 40,
            title: Ltxt(text: 'My Medical Tests Results'),
            centerTitle: true,
          ),
          tests.when(
              data: (t) => SliverList.builder(
                  itemCount: t.isNotEmpty ? t.length : 1,
                  itemBuilder: (context, index) => t.isEmpty
                      ? SizedBox(
                          width: size.width,
                          height: size.height,
                          child: const Ltxt(text: "No Medical Results found.")
                              .centered(),
                        )
                      : Container(
                          width: size.width * 0.8,
                          height: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: medColor[index % 4].withOpacity(0.05),
                              border: const Border(
                                  bottom: BorderSide(width: 1, color: kblack))),
                          child: GestureDetector(
                            onTap: () =>
                                context.nextPage(Viewtest(RapidtestModel())),
                            child: HStack(
                                crossAlignment: CrossAxisAlignment.center,
                                [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: medColor[index % 4]),
                                    child: Center(
                                      child: Image.asset(
                                          "assets/icons/blood-analysis.png"),
                                    ),
                                  ),
                                  10.widthBox,
                                  VStack(alignment: MainAxisAlignment.start, [
                                    const Ltxt(text: "Blood test results"),
                                    const Stxt(text: "2nd September, 2023."),
                                    Card(
                                      child: const Btxt(text: 'Espat pharmacy.')
                                          .px4(),
                                    )
                                  ]),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 20, color: Colors.black38)
                                ]),
                          ),
                        )),
              error: (err, stk) => Center(child: Ltxt(text: err.toString()))
                  .sliverToBoxAdapter(),
              loading: () => const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      ShimmerWidget.rectangular(height: 90),
                      ShimmerWidget.rectangular(height: 90),
                      ShimmerWidget.rectangular(height: 90),
                      ShimmerWidget.rectangular(height: 90),
                      ShimmerWidget.rectangular(height: 90),
                      ShimmerWidget.rectangular(height: 90),
                      ShimmerWidget.rectangular(height: 90),
                    ],
                  ).sliverToBoxAdapter())
        ],
      ),
    );
  }
}

import 'package:MedBox/version2/models/rapidtestmodel.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

class Viewtest extends ConsumerWidget {
  const Viewtest(this.model, {super.key});
  final RapidtestModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width,
                child: HStack([
                  Ltxt(text: model.testkitname ?? "Medical Result"),
                  const Spacer(),
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 0.5)),
                      child: IconButton(
                          onPressed: () => context.pop(context),
                          icon: const Icon(Icons.close,
                              size: 30, color: Colors.red)))
                ]),
              ),
              20.heightBox,
              const Stxt(text: 'Medical Test Type'),
              10.heightBox,
              Ltxt(text: model.testtype ?? "__"),
              15.heightBox,
              const Stxt(text: 'Test Results'),
              10.heightBox,
              Card(
                color: model.testoutcome?.toUpperCase() == "POSITIVE"
                    ? Colors.red[700]
                    : Colors.green[700],
                child: Itxt(text: model.testoutcome ?? "Negative").p4(),
              ),
              15.heightBox,
              const Stxt(text: 'Test Description'),
              10.heightBox,
              const Ltxt(text: "This is description for this rapid test."),
              15.heightBox,
              const Stxt(text: 'Test Date'),
              10.heightBox,
              Ltxt(text: model.testdate ?? "__"),
              15.heightBox,
              const Stxt(text: 'Test Time'),
              10.heightBox,
              Ltxt(text: model.testtime ?? "__"),
              15.heightBox,
              const Stxt(text: 'Pharmacy conducted'),
              10.heightBox,
              Ltxt(text: model.pharmacyName ?? "__"),
              15.heightBox,
              const Stxt(text: 'Test Bill'),
              10.heightBox,
              Ltxt(text: "GHS ${model.testBill ?? "0.0"}"),
              15.heightBox,
            ],
          ).safeArea(),
        ),
      ).animate().slideY(duration: 300.ms, begin: 1),
    );
  }
}

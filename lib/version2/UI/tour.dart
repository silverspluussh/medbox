import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/version2/utilites/sharedprefs.dart';
import 'package:MedBox/version2/UI/render.dart';
import 'package:MedBox/version2/wiis/borderbtn.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Apptour extends ConsumerWidget {
  const Apptour({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: VStack(
            alignment: MainAxisAlignment.center,
            crossAlignment: CrossAxisAlignment.center,
            [
              const Spacer(),
              Ttxt(text: AppLocalizations.of(context)!.welcome),
              const Spacer(),
              BBtn(
                  icon: const Icon(Icons.health_and_safety_rounded),
                  label: AppLocalizations.of(context)!.ivitals,
                  action: () {}),
              const SizedBox(height: 20),
              BBtn(
                  icon: const Icon(Icons.medication_liquid_rounded),
                  label: AppLocalizations.of(context)!.imeds,
                  action: () {}),
              const SizedBox(height: 20),
              BBtn(
                  icon: const Icon(Icons.info_outline),
                  label: AppLocalizations.of(context)!.itest,
                  action: () {}),
              const SizedBox(height: 20),
              BBtn(
                  icon: const Icon(Icons.local_pharmacy_rounded),
                  label: AppLocalizations.of(context)!.ipharm,
                  action: () {}),
              const SizedBox(height: 20),
              const Spacer(),
              Container(
                height: size.height * 0.25,
                width: size.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: kprimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: VStack([
                  Container(
                          height: 5,
                          width: size.width * 0.2,
                          color: Colors.white)
                      .centered(),
                  const SizedBox(height: 15),
                  Text(AppLocalizations.of(context)!.getstarted,
                          style: const TextStyle(
                              fontFamily: 'Pop',
                              fontWeight: FontWeight.w500,
                              color: kwhite,
                              fontSize: 18))
                      .centered(),
                  const Spacer(),
                  MaterialButton(
                    height: 50,
                    splashColor: kwhite,
                    color: kwhite,
                    onPressed: () {
                      SharedCli().tourstatus(value: true);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyRender()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home, color: kprimary),
                        const SizedBox(width: 50),
                        Ttxt(text: AppLocalizations.of(context)!.mvhomescreen),
                      ],
                    ),
                  )
                ]).p4(),
              )
            ]),
      ),
    );
  }
}

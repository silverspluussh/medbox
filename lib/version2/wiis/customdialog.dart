import 'package:MedBox/version2/wiis/buttons.dart';
import 'package:MedBox/version2/wiis/txt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Customdialog extends ConsumerWidget {
  const Customdialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);

    return Dialog(
      backgroundColor: Colors.green,
      child: Container(
        height: size.height * 0.24,
        width: size.width * 0.75,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Ttxt(
              text: AppLocalizations.of(context)!.outconf,
            ),
            const SizedBox(height: 10),
            Btxt(
              text: AppLocalizations.of(context)!.sure,
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              width: size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CancelBtn(
                      function: () => Navigator.of(context).pop(false),
                      text: 'cancel'),
                  const Spacer(),
                  ConfirmBtn(
                      function: () {
                        Navigator.pop(context);
                        FirebaseAuth.instance.signOut();
                      },
                      text: AppLocalizations.of(context)!.yes),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

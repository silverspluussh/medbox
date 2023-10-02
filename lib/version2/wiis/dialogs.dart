import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
      {required String text, required Widget child}) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              key: key,
              backgroundColor: kprimary.withOpacity(0.5),
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          child,
                          15.widthBox,
                          Text(
                            text,
                            style: const TextStyle(
                                fontFamily: 'Manrope',
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                                fontSize: 15),
                          ),
                        ]).px8(),
                  ),
                )
              ]);
        });
  }

  static Future<void> showSuccessDialog(BuildContext context, GlobalKey key,
      {required String text, required Widget child}) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              key: key,
              backgroundColor: kprimary.withOpacity(0.5),
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: Row(
                      children: [
                        child,
                        15.widthBox,
                        Text(
                          text,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontFamily: 'Manrope',
                              fontSize: 15),
                        ),
                      ],
                    ).px8(),
                  ),
                )
              ]);
        });
  }
}

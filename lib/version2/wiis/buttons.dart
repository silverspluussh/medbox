import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

//color: kPrimary,

class CancelBtn extends StatelessWidget {
  const CancelBtn({super.key, required this.function, required this.text});
  final VoidCallback function;
  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: function,
        child: Container(
          margin: const EdgeInsets.all(5),
          height: 45,
          width: size.width * 0.3,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ).centered(),
        ),
      ),
    );
  }
}

class ConfirmBtn extends StatelessWidget {
  const ConfirmBtn({super.key, required this.function, required this.text});
  final VoidCallback function;
  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: function,
        child: Container(
          margin: const EdgeInsets.all(5),
          height: 45,
          width: size.width * 0.3,
          decoration: BoxDecoration(
            color: kprimary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ).centered(),
        ),
      ),
    );
  }
}

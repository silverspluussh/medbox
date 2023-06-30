import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/colors.dart';

class BBtn extends ConsumerWidget {
  const BBtn(
      {required this.icon,
      required this.label,
      required this.action,
      super.key});
  final Icon icon;
  final VoidCallback action;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      width: size.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1, color: kprimary)),
      child: InkWell(
        onTap: action,
        child: HStack([
          icon,
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Pop',
                fontWeight: FontWeight.w400,
                color: kprimary),
          ),
          const Spacer(),
        ]).px4(),
      ),
    );
  }
}

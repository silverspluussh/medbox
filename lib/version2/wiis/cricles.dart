import 'package:flutter/material.dart';

class Circles extends StatelessWidget {
  const Circles(
      {super.key,
      required this.width,
      required this.height,
      required this.color});
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

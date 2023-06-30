import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cuscontainer extends ConsumerWidget {
  const Cuscontainer(
      {super.key,
      required this.child,
      required this.height,
      required this.decor});
  final double height;
  final Widget child;
  final String decor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var s = MediaQuery.of(context);
    return GestureDetector(
      child: Container(
        width: s.size.width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(decor), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.grey)),
        child: child,
      ),
    );
  }
}

import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';

class Btxt extends StatelessWidget {
  final String text;

  const Btxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }
}

class Ttxt extends StatelessWidget {
  final String text;

  const Ttxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall);
  }
}

class Stxt extends StatelessWidget {
  final String text;

  const Stxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 11,
            fontFamily: 'Pop',
            fontWeight: FontWeight.w500,
            color: kblack));
  }
}

class Itxt extends StatelessWidget {
  final String text;

  const Itxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Pop',
            fontWeight: FontWeight.w400,
            color: kwhite));
  }
}

class Ltxt extends StatelessWidget {
  final String text;

  const Ltxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.labelMedium);
  }
}

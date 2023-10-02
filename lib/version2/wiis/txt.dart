import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';

class Btxt extends StatelessWidget {
  final String text;

  const Btxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Pop',
            fontWeight: FontWeight.w400,
            color: kblack));
  }
}

class Ttxt extends StatelessWidget {
  final String text;

  const Ttxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Pop',
            fontWeight: FontWeight.w500,
            color: kblack));
  }
}

class Stxt extends StatelessWidget {
  final String text;

  const Stxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Pop',
            fontWeight: FontWeight.w500,
            color: Colors.grey));
  }
}

class Itxt extends StatelessWidget {
  final String text;

  const Itxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Pop',
            fontWeight: FontWeight.w500,
            color: kwhite));
  }
}

class Ltxt extends StatelessWidget {
  final String text;

  const Ltxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Pop',
            fontWeight: FontWeight.w600,
            color: kblack));
  }
}

import 'package:flutter/material.dart';

enum Drugtype { pill, tablet, syringe, cosmetics, bottle }

class MedicationState with ChangeNotifier {
  String image;
  String title;
  Drugtype drugtype;

  MedicationState({
    required this.drugtype,
    required this.image,
    required this.title,
  });

  selectype(MedicationState meds) {
    drugtype = meds.drugtype;
    title = meds.title;

    notifyListeners();
  }
}

List<MedicationState> drugtypes = [
  MedicationState(
    drugtype: Drugtype.pill,
    image: 'assets/icons/pill.png',
    title: 'Pill',
  ),
  MedicationState(
      drugtype: Drugtype.bottle,
      image: 'assets/icons/bottlex.png',
      title: 'Bottle'),
  MedicationState(
      drugtype: Drugtype.tablet,
      image: 'assets/icons/tablet.png',
      title: 'Tablet'),
  MedicationState(
      drugtype: Drugtype.syringe,
      image: 'assets/icons/syringe.png',
      title: 'Syringe'),
  MedicationState(
      drugtype: Drugtype.cosmetics,
      image: 'assets/icons/cosmetics-5-64.png',
      title: 'Cosmetics'),
];

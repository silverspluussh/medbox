import 'package:flutter/material.dart';

enum Vv { pressure, heart, temperature, oxygenlevel }

class VitalsProvider with ChangeNotifier {
  Vv vv;
  VitalsProvider(this.vv);

  changevitals(VitalsProvider vitalsProvider) {
    vv = vitalsProvider.vv;
    notifyListeners();
  }
}

import 'dart:math';

String idgen() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

int idg() {
  return (Random().nextInt(20010) * 150);
}

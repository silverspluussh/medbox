import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final algProvider = StateProvider<TextEditingController>((ref) {
  return ref.controller.state;
});

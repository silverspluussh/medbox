import 'package:flutter/material.dart';

class L10n {
  static final all = [const Locale('en'), const Locale('fr')];

  static String getflag(String flag) {
    switch (flag) {
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      default:
        return '🇺🇸';
    }
  }
}

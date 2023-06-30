import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n.dart';

class Language with ChangeNotifier {
  Locale? locale;
  Locale get localization => locale ?? const Locale('en');

  void setlocalizations(Locale local) {
    if (!L10n.all.contains(localization)) return;
    locale = local;

    notifyListeners();
  }

  void clearlocalization() {
    locale = null;
    notifyListeners();
  }
}

final languageProvider = ChangeNotifierProvider<Language>((ref) => Language());

import 'package:flutter/material.dart';

import '../../translation/l10n/l10n.dart';

class LanguageProvider with ChangeNotifier {
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

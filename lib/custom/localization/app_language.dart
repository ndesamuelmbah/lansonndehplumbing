import 'dart:async';

import 'package:lansonndehplumbing/repository/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Do not change order
enum Language {
  english,
  french,
  swahili,
}

class AppLanguageProvider extends ChangeNotifier {
  Language selectedLanguage = Language.english;

  final generalBox = GetIt.instance<GeneralBox>();
  Map<Language, Locale> languages = {
    Language.english: const Locale('en'),
    Language.french: const Locale('fr'),
    Language.swahili: const Locale('sw'),
  };

  AppLanguageProvider() {
    initialise();
  }

  Locale get locale => languages[selectedLanguage]!;

  void initialise() {
    selectedLanguage = Language.values[generalBox.get('languageCode') ?? 0];
  }

  void changeLanguage(Language language) async {
    if (selectedLanguage == language) {
      return;
    }
    selectedLanguage = language;
    await generalBox.put('languageCode', language.index);
    notifyListeners();
    Timer(const Duration(milliseconds: 200), () {
      notifyListeners();
    });
  }
}

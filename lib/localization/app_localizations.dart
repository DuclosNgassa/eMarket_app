import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  //helper method to keep the code in the widget concise
  //Localizations are accessed using an inheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsdelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    //Load the language JSON file from the "Lang" folder
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  //This method will be call from every Widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key];
  }
}

// LocalizationDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsdelegate
    extends LocalizationsDelegate<AppLocalizations> {

  // This delegate instance will never change (it doesn´t even have fields)
  // It can provide a constant constructor.
  const _AppLocalizationsdelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalization is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

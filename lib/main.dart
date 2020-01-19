import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/splash_screen/splash_screen_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        //List all of the app supported locales here
        supportedLocales: [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
        ],
        //These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: [
          //Class which loads the translation from json files
          AppLocalizations.delegate,
          //Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          //Built-in localization for text direction LTR / RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Return a locale which will be used by the app
        //localeResolutionCallback: getLocale,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one from the list. In this case English
          return supportedLocales.first;
        },

        home: SplashScreenPage(),
        //home: NavigationPage(HOMEPAGE),
      ),
    );
  });
}

Locale getLocale(locale, supportedLocales) {
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode &&
        supportedLocale.countryCode == locale.countryCode) {
      return supportedLocale;
    }
  }
  // If the locale of the device is not supported, use the first one from the list. In this case English
  return supportedLocales.first;
}

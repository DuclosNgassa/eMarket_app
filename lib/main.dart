import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(
      new MaterialApp(
        //home: Login(),
        home: NavigationPage(HOMEPAGE),
        //debugShowCheckedModeBanner: false,
      ),
    );
  });
}

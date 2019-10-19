import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    new MaterialApp(
      //home: Login(),
      home: NavigationPage(HOMEPAGE),
      //debugShowCheckedModeBanner: false,
    ),
  );
}

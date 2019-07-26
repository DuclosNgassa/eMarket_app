import 'package:flutter/material.dart';
import '../custom_widget/custom_multi_image_picker.dart';

class Statistik extends StatelessWidget {
  final String pageTitle;

  Statistik(this.pageTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Container(),
      ),
    );
  }
}

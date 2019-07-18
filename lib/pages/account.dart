import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  final String pageTitle;

  Account(this.pageTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text(pageTitle),
      ),
    );
  }
}

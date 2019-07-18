import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final String pageTitle;

  Search(this.pageTitle);

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

import 'package:flutter/material.dart';

class CustomLinearGradient extends StatelessWidget {
  final Widget myChild;

  CustomLinearGradient({this.myChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.deepPurple[400],
            Colors.deepPurple[300],
            Colors.deepPurple[400],
            Colors.deepPurple[300],
          ],
        ),
      ),
      child: myChild,
    );
  }
}

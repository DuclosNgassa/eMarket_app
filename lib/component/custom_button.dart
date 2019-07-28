import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {@required this.onPressed,
      @required this.fillColor,
      @required this.splashColor,
      @required this.icon,
      @required this.iconColor,
      @required this.text,
      @required this.textStyle});

  final GestureTapCallback onPressed;
  final Color fillColor;
  final Color splashColor;
  final Color iconColor;
  final IconData icon;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: fillColor,
      splashColor: splashColor,
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(width: 8.0,),
            Text(
              text,
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}

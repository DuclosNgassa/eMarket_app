import 'package:emarket_app/util/size_config.dart';
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
    SizeConfig().init(context);

    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: fillColor,
      splashColor: splashColor,
      shape: const StadiumBorder(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 2,
            ),
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

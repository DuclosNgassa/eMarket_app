import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyNotification {


  static void showInfoFlushbar(BuildContext context, String title, String message, Icon icon, Color leftBarIndicatorColor, int duration) {
    Flushbar(
      title: 'Info',
      message: message,
      icon: icon,
      leftBarIndicatorColor: leftBarIndicatorColor,
      duration: Duration(seconds: 2),
    )..show(context);
  }


  static Future<void> showConfirmationDialog(BuildContext context, String title, String body, GestureTapCallback onPressedJA, GestureTapCallback onPressedNEIN) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Non'),
              onPressed: onPressedNEIN,
            ),
            FlatButton(
              child: Text('Oui'),
              onPressed: onPressedJA,
            ),
          ],
        );
      },
    );
  }

}

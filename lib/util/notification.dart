import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

class MyNotification {


  static void showInfoFlushbar(BuildContext context, String title, String message, Icon icon, Color leftBarIndicatorColor, int duration) {
    Flushbar(
      title: 'Info',
      message: message,
      icon: icon,
      leftBarIndicatorColor: leftBarIndicatorColor,
      duration: Duration(seconds: 8),
    )
      ..show(context);
  }

}

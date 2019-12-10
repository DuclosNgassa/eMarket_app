import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class CustomIconMessage extends StatelessWidget {
  CustomIconMessage(
      {@required this.countNewMessage});

  final int countNewMessage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Container(
        color: colorRed,
        height: SizeConfig.blockSizeVertical * 3,
        width: SizeConfig.blockSizeHorizontal * 5,
        child: Center(
          child: Text(
            countNewMessage.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

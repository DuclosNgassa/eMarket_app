import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class CustomIconMessage extends StatelessWidget {
  CustomIconMessage({@required this.countNewMessage});

  final int countNewMessage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      child: Container(
        color: GlobalColor.colorRed,
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

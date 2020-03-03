
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final int index;

  const ListItem({Key key, this.index});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.blockSizeVertical * 9,
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical * 1.5,
        horizontal: SizeConfig.blockSizeHorizontal * 1.5,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
            child: CircleAvatar(
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 10,
                height: SizeConfig.blockSizeVertical * 9,
              ),
            ),
          ),
          index != -1
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'eMarket $index',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('eMarket'),
              Text('eMarket'),
            ],
          )
              : Expanded(
            child: Container(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

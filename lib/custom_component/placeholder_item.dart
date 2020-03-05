import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final int page;

  const ListItem({Key key, this.page});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    if (page == MESSAGEPAGE) {
      return _buildMessagePlaceHolder();
    }
    if (page == ACCOUNTPAGE) {
      return _buildAccountPlaceHolder();
    }
  }

  Widget _buildMessagePlaceHolder() {
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
          Expanded(
            child: Container(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccountPlaceHolder() {
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
          Expanded(
            child: Container(
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 2,
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 15,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

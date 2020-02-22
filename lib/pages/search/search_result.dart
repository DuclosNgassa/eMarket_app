
import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget{
  final List<Post> resultList;
  final List<Favorit> myFavorits;
  final String userEmail;


  SearchResultPage(this.resultList, this.myFavorits, this.userEmail);

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResultPage>{
  bool showPictures = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Switch(
                  value: showPictures,
                  onChanged: (value) {
                    setState(() {
                      showPictures = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                Padding(
                  padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 2),
                  child: Text(
                    AppLocalizations.of(context).translate('pictures'),
                    style: SizeConfig.styleNormalBlackBold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            constraints: BoxConstraints.expand(
                height: SizeConfig.screenHeight * 0.845),
            child: PostCardComponentPage(postList: widget.resultList, myFavorits:widget.myFavorits, userEmail: widget.userEmail, showPictures: showPictures),
          ),
        ],
      ),
    );
  }
}
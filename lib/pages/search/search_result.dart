import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  final List<Post> searchResultList;
  final List<Favorit> myFavorits;
  final String userEmail;
  final Categorie parentCategory;

  SearchResultPage(
      {this.searchResultList,
      this.myFavorits,
      this.userEmail,
      this.parentCategory});

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResultPage> {
  bool showPictures = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 2,
                  right: SizeConfig.blockSizeHorizontal * 2),
              child: Row(
                mainAxisAlignment: widget.parentCategory != null
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: <Widget>[
                  widget.parentCategory != null
                      ? Expanded(
                          child: Text(
                            AppLocalizations.of(context).translate('category') +
                                ": " +
                                widget.parentCategory.title,
                            style: SizeConfig.styleNormalBlackBold,
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
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
                  Text(
                    AppLocalizations.of(context).translate('pictures'),
                    style: SizeConfig.styleNormalBlackBold,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            constraints:
                BoxConstraints.expand(height: SizeConfig.screenHeight * 0.845),
            child: PostCardComponentPage(
                postList: widget.searchResultList,
                myFavorits: widget.myFavorits,
                userEmail: widget.userEmail,
                showPictures: showPictures),
          ),
        ],
      ),
    );
  }
}

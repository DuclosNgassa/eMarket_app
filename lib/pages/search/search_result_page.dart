import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/global/global_styling.dart';
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
  final Category selectedCategory;
  final bool showPictures;

  SearchResultPage(
      {this.searchResultList,
      this.myFavorits,
      this.userEmail,
      this.selectedCategory,
      this.showPictures});

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.selectedCategory != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 1.5),
                      child: Text(
                        AppLocalizations.of(context).translate('category') +
                            ": " +
                            widget.selectedCategory.title,
                        style: GlobalStyling.styleNormalBlackBold,
                      ),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            constraints:
                BoxConstraints.expand(height: SizeConfig.screenHeight * 0.845),
            child: PostCardComponentPage(
                postList: widget.searchResultList,
                myFavorits: widget.myFavorits,
                userEmail: widget.userEmail,
                showPictures: widget.showPictures),
          ),
        ],
      ),
    );
  }
}

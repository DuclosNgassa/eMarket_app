import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class PostUserPage extends StatefulWidget {
  final List<Post> posts;
  final List<Favorit> myFavorits;
  final String postOwnerName;
  final String postOwnerEmail;
  final String userEmail;

  PostUserPage(this.posts, this.postOwnerName, this.postOwnerEmail,
      this.myFavorits, this.userEmail);

  @override
  _PostUserPageState createState() => _PostUserPageState();
}

class _PostUserPageState extends State<PostUserPage> {
  bool showPictures = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: SizeConfig.screenHeight / 4,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [colorDeepPurple400, colorDeepPurple300],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 5,
                      top: SizeConfig.blockSizeVertical * 5),
                  constraints: BoxConstraints.expand(
                      height: SizeConfig.screenHeight / 6),
                  child: _buildTitle(),
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.125),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(top: 10),
                            constraints: BoxConstraints.expand(
                                height: SizeConfig.screenHeight * 0.845),
                            child: PostCardComponentPage(postList: widget.posts, myFavorits:widget.myFavorits, userEmail: widget.userEmail, showPictures: showPictures),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTitle() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 2,
            right: SizeConfig.blockSizeHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: new Text(
                    AppLocalizations.of(context).translate('advert_list') +
                        ' ' +
                        widget.postOwnerName,
                    style: SizeConfig.styleTitleWhite,
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Text(
                        AppLocalizations.of(context).translate('pictures'),
                        style: SizeConfig.styleNormalBlack,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

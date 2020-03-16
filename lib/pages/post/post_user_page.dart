import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class PostUserPage extends StatefulWidget {
  final List<Post> posts;
  final List<Favorit> myFavorits;
  final String postOwnerName;
  final String postOwnerEmail;
  final String userEmail;
  final bool showPictures;

  PostUserPage(this.posts, this.postOwnerName, this.postOwnerEmail,
      this.myFavorits, this.userEmail, this.showPictures);

  @override
  _PostUserPageState createState() => _PostUserPageState();
}

class _PostUserPageState extends State<PostUserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

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
                          colors: [
                            GlobalColor.colorDeepPurple400,
                            GlobalColor.colorDeepPurple300
                          ],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 7,
                      left: SizeConfig.blockSizeHorizontal * 2,
                      right: SizeConfig.blockSizeHorizontal),
                  child: _buildTitle(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 2,
                    right: SizeConfig.blockSizeHorizontal * 2,
                  ),
                  child: Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
                    child: _buildPostsContainer(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: new Text(
              AppLocalizations.of(context).translate('advert_list') +
                  ' ' +
                  widget.postOwnerName,
              style: GlobalStyling.styleTitleWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsContainer() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            constraints:
                BoxConstraints.expand(height: SizeConfig.screenHeight * 0.9),
            child: PostCardComponentPage(
                postList: widget.posts,
                myFavorits: widget.myFavorits,
                userEmail: widget.userEmail,
                showPictures: widget.showPictures),
          ),
        ],
      ),
    );
  }
}

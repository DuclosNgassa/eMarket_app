import 'package:emarket_app/custom_component/home_card.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class PostUserPage extends StatefulWidget {
  final List<Post> posts;
  final List<Favorit> myFavorits;
  final String userName;

  PostUserPage(this.posts, this.userName, this.myFavorits);

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

    return Container(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 5,
                      top: SizeConfig.blockSizeVertical * 5),
                  constraints: BoxConstraints.expand(
                      height: SizeConfig.screenHeight / 6),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [colorDeepPurple400, colorDeepPurple300],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
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
                            constraints: BoxConstraints.expand(
                                height: SizeConfig.screenHeight * 0.845),
                            child: buildMyPostListView(),
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
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, left: SizeConfig.blockSizeHorizontal * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: new Text(
                    "List des annonces de " +
                        widget.userName,
                    style: SizeConfig.styleTitleWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMyPostListView() {

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      childAspectRatio: 1.5,

      children: List.generate(widget.posts.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
              left: index % 2 == 0 ? SizeConfig.blockSizeHorizontal * 2 : 0),
          child: HomeCard(
            widget.posts.elementAt(index),
            widget.myFavorits,
            SizeConfig.blockSizeVertical * 18,
            SizeConfig.screenWidth * 0.5 - 10,
          ),
        );
      }),
    );
  }
}


import 'package:emarket_app/custom_component/home_card.dart';
import 'package:emarket_app/custom_component/home_card_picture.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCardComponentPage extends StatefulWidget{
  final List<Post> postList;
  final List<Favorit> myFavorits;
  final String userEmail;
  final bool showPictures;

  PostCardComponentPage({this.postList, this.myFavorits, this.userEmail, this.showPictures});

  @override
  PostCardComponentState createState() => PostCardComponentState();
}

class PostCardComponentState extends State<PostCardComponentPage>{

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return buildPostListView(widget.showPictures);
  }

  Widget buildPostListView(bool showPictures) {
    if (showPictures) {
      return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1,
        children: List.generate(widget.postList.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
                left: index % 2 == 0 ? SizeConfig.blockSizeHorizontal * 2 : 0),
            child: HomeCardPicture(
              widget.postList.elementAt(index),
              widget.myFavorits,
              widget.userEmail,
              SizeConfig.blockSizeVertical * 60,
              SizeConfig.screenWidth * 0.5 - 10,
            ),
          );
        }),
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1.5,
        children: List.generate(widget.postList.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
                left: index % 2 == 0 ? SizeConfig.blockSizeHorizontal * 2 : 0),
            child: HomeCard(
              widget.postList[index],
              widget.myFavorits,
              widget.userEmail,
              SizeConfig.blockSizeVertical * 18,
              SizeConfig.screenWidth * 0.5 - 10,
            ),
          );
        }),
      );
    }
  }

}
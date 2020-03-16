import 'package:emarket_app/custom_component/home_card.dart';
import 'package:emarket_app/custom_component/home_card_picture.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCardComponentPage extends StatefulWidget {
  final List<Post> postList;
  final List<Favorit> myFavorits;
  final String userEmail;
  final bool showPictures;

  PostCardComponentPage(
      {this.postList, this.myFavorits, this.userEmail, this.showPictures});

  @override
  PostCardComponentState createState() => PostCardComponentState();
}

class PostCardComponentState extends State<PostCardComponentPage> {
  List<Post> postListItems = new List();

  int perPage = 10;
  int present = 0;

  //bool showPictures = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return buildPostListView(widget.showPictures);
  }

  Widget buildPostListView(bool showPictures) {
    _loadMorePost(widget.postList);
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

  void _initControllers() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePost(widget.postList);
        setState(() {});
      }
    });
  }

  void _loadMorePost(List<Post> _postList) {
    print("_loadMorePost");
    if (present < _postList.length) {
      if ((present + perPage) > _postList.length) {
        postListItems.addAll(_postList.getRange(present, _postList.length));
        present = _postList.length;
      } else {
        postListItems.addAll(_postList.getRange(present, present + perPage));
        present = present + perPage;
      }
    }
  }
}

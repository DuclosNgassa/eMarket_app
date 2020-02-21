import 'dart:async';

import 'package:emarket_app/custom_component/custom_categorie_button.dart';
import 'package:emarket_app/custom_component/home_card_picture.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/pages/search/datasearch.dart';
import 'package:emarket_app/services/categorie_service.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_component/home_card.dart';
import '../../model/post.dart';
import '../../services/post_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final PostService _postService = new PostService();
  final FavoritService _favoritService = new FavoritService();
  final CategorieService _categorieService = new CategorieService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> allConversation = new List<Message>();
  bool showPictures = false;

  String _deviceToken = "";
  String _userEmail = "";

  final List<Message> fireBaseMessages = [];

  List<Post> searchResult = new List();
  List<Post> postList = new List();
  List<Post> postListItems = new List();
  List<Favorit> myFavorits = new List();
  List<Categorie> categories = new List();

  List<Categorie> parentCategories = new List();

  int perPage = 10;
  int present = 0;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMyFavorits();
    _loadMyCategories();

    _firebaseMessaging.onTokenRefresh.listen(setDeviceToken);
    _firebaseMessaging.getToken();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMorePost(postList);
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return FutureBuilder(
      future: _loadPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data.length > 0){
            loadMorePost(snapshot.data);
            return Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 3),
              height: SizeConfig.screenHeight,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: SizeConfig.blockSizeVertical * 10,
                    floating: true,
                    snap: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 2),
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      hintText: AppLocalizations.of(context)
                                          .translate('give_your_search'),
                                      labelText: AppLocalizations.of(context)
                                          .translate('search'),
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      showSearch(
                                        context: context,
                                        delegate: DataSearch(postList, myFavorits,
                                            _userEmail, null, null),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  tooltip: AppLocalizations.of(context)
                                      .translate('to_search'),
                                  onPressed: () {
                                    showSearch(
                                      context: context,
                                      delegate: DataSearch(postList, myFavorits,
                                          _userEmail, null, null),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 2,
                                ),

//this goes in as one of the children in our column
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: SizeConfig.blockSizeHorizontal),
                                  child: Column(
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
                                        AppLocalizations.of(context)
                                            .translate('pictures'),
                                        style: SizeConfig.styleNormalBlack,
                                      ),
                                      //Icon(Icons.photo_camera, size: SizeConfig.blockSizeHorizontal * 7, color: Colors.black,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 5,
                    ),
                    delegate:
                    SliverChildListDelegate([_buildCategorieGridView()]),
                  ),
                  _buildSliverGrid(showPictures),
                ],
              ),
            );
          } else{
            return new Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 3,
                  vertical: SizeConfig.blockSizeVertical * 2,
                ),
                child: Text(
                  AppLocalizations.of(context).translate('no_post_found'),
                ),
              ),
            );
          }
        }
        else if (snapshot.hasError) {
          MyNotification.showInfoFlushbar(
              context,
              AppLocalizations.of(context).translate('erro'),
              AppLocalizations.of(context).translate('error_loading'),
              Icon(
                Icons.info_outline,
                size: 28,
                color: Colors.redAccent,
              ),
              Colors.redAccent,
              4);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/gif/loading.gif",
              ),
              Text(AppLocalizations.of(context)
                  .translate('loading'),)
            ],
          ),
        );
      },
    );
  }

  SliverGrid _buildSliverGrid(bool showPictures) {
    if (showPictures) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == postListItems.length) {
              return CupertinoActivityIndicator();
            }
            return Padding(
              padding: EdgeInsets.only(
                  left:
                      index % 2 == 0 ? SizeConfig.blockSizeHorizontal * 2 : 0),
              child: HomeCardPicture(
                  postListItems.elementAt(index),
                  myFavorits,
                  _userEmail,
                  SizeConfig.blockSizeVertical * 40,
                  SizeConfig.screenWidth * 0.5 - 10),
            );
          },
          childCount: postListItems.length,
        ),
      );
    } else {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == postListItems.length) {
              return CupertinoActivityIndicator(
                radius: SizeConfig.blockSizeHorizontal * 10,
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                  left:
                      index % 2 == 0 ? SizeConfig.blockSizeHorizontal * 2 : 0),
              child: HomeCard(
                  postListItems.elementAt(index),
                  myFavorits,
                  _userEmail,
                  SizeConfig.blockSizeVertical * 20,
                  SizeConfig.screenWidth * 0.5 - 10),
            );
          },
          childCount: postListItems.length,
        ),
      );
    }
  }

  Widget _buildCategorieGridView() {
    TextStyle _myTextStyle = TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockHorizontal * 2.6,
    );

    double heightCustomCategorieButton = SizeConfig.blockSizeVertical * 5;
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(parentCategories.length, (index) {
        return CustomCategorieButton(
          width: SizeConfig.blockSizeHorizontal * 32,
          height: heightCustomCategorieButton,
          fillColor: colorDeepPurple400,
          icon: IconData(int.parse(parentCategories[index].icon),
              fontFamily: 'MaterialIcons'),
          splashColor: colorWhite,
          iconColor: colorWhite,
          text: parentCategories[index].title,
          textStyle: _myTextStyle,
          onPressed: () =>
              showSearchWithParentCategorie(parentCategories[index].id),
        );
      }),
    );
  }

  void loadMorePost(List<Post> _postList) {
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

  void showSearchWithParentCategorie(int parentCategorie) async {
    List<int> childCategories = new List();

    for (Categorie categorie in categories) {
      if (categorie.parentid == parentCategorie) {
        childCategories.add(categorie.id);
      }
    }

    showSearch(
      context: context,
      delegate:
          DataSearch(postList, myFavorits, _userEmail, null, childCategories),
    );
  }

  Future<List<Post>> _loadPost() async {
    List<Post> _postList = await _postService.fetchActivePosts();

    //fetch image to display
    for (var post in _postList) {
      await post.getImageUrl();
    }

    postList = _postService.sortDescending(_postList);

    return postList;
  }

  Future<void> _loadMyFavorits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString(USER_EMAIL);

    if (_userEmail != null && _userEmail.isNotEmpty) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(_userEmail);
      //setState(() {});
    }
  }

  Future<void> _loadMyCategories() async {
    categories = await _categorieService.fetchCategories();
    List<Categorie> translatedcategories =
        _categorieService.translateCategories(categories, context);

    for (var _categorie in translatedcategories) {
      if (_categorie.parentid == null) {
        parentCategories.add(_categorie);
      }
    }

    parentCategories.sort((a, b) => a.title.compareTo(b.title));
    Categorie categorieTemp = parentCategories.firstWhere((categorie) =>
        categorie.title == 'Other categories' ||
        categorie.title == 'Autre categories');
    parentCategories.removeWhere((categorie) =>
        categorie.title == 'Other categories' ||
        categorie.title == 'Autre categories');
    parentCategories.add(categorieTemp);

    //setState(() {});
  }

  void setDeviceToken(String event) async {
    _deviceToken = event;
    if (_deviceToken.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(DEVICE_TOKEN, _deviceToken);
    }
    print('Device-Token-Home: $event');
  }
}
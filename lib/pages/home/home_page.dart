import 'dart:async';
import 'dart:convert';

import 'package:emarket_app/custom_component/custom_categorie_button.dart';
import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/pages/search/search_page.dart';
import 'package:emarket_app/services/categorie_service.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  List<Message> allConversation = new List<Message>();
  bool showPictures = false;

  String _deviceToken = "";
  String _userEmail = "";
  String _searchLabel;
  final List<Message> fireBaseMessages = [];

  double heightCustomCategorieButton = SizeConfig.blockSizeVertical * 5;
  TextStyle _myTextStyle = TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.safeBlockHorizontal * 2.6,
  );
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

    _firebaseMessaging.onTokenRefresh.listen(setDeviceToken);
    _firebaseMessaging.getToken();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMorePost(postList);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _searchLabel = AppLocalizations.of(context).translate('search');

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: SizeConfig.screenHeight,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.screenWidth * 0.82,
                      child: _buildCategorieGridView(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: colorDeepPurple400,
                          ),
                          iconSize: SizeConfig.blockSizeHorizontal * 11,
                          tooltip: AppLocalizations.of(context)
                              .translate('to_search'),
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: SearchPage(postList, myFavorits,
                                  _userEmail, _searchLabel, null, null, null),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                    height: SizeConfig.screenHeight * 0.74,
                    child: _buildPageWithDataFromServer()),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: SizeConfig.blockSizeVertical,
              right: SizeConfig.screenWidth * 0.4),
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () => _changeShowPictures(),
            tooltip: 'Image',
            child: Icon(Icons.image),
          ),
        ));
  }

  _changeShowPictures() async {
    showPictures = !showPictures;
    setState(() {});
  }

  Widget _buildPageWithDataFromServer() {
    return FutureBuilder(
      future: _loadPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Stop load post cache");
          if (snapshot.data.length > 0) {
            loadMorePost(snapshot.data);
            return Container(
              padding: EdgeInsets.only(top: 10),
              constraints: BoxConstraints.expand(
                  height: SizeConfig.screenHeight * 0.845),
              child: PostCardComponentPage(
                  postList: snapshot.data,
                  myFavorits: myFavorits,
                  userEmail: _userEmail,
                  showPictures: showPictures),
            ); //_buildPostGrid(showPictures);
          } else {
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
        } else if (snapshot.hasError) {
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
        return _buildPageWithDataFromCache();
      },
    );
  }

  Widget _buildPageWithDataFromCache() {
    return FutureBuilder(
      future: _loadPostFromCache(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Stop load post cache");
          if (snapshot.data.length > 0) {
            loadMorePost(snapshot.data);
            return Container(
              padding: EdgeInsets.only(top: 10),
              constraints: BoxConstraints.expand(
                  height: SizeConfig.screenHeight * 0.845),
              child: PostCardComponentPage(
                  postList: snapshot.data,
                  myFavorits: myFavorits,
                  userEmail: _userEmail,
                  showPictures: showPictures),
            );
          } else {
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
        } else if (snapshot.hasError) {
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
              Text(
                AppLocalizations.of(context).translate('loading'),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorieGridView() {
    return FutureBuilder(
        future: _loadMyCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              crossAxisCount: 1,
              scrollDirection: Axis.horizontal,
              children: List.generate(parentCategories.length, (index) {
                return CustomCategorieButton(
                  width: SizeConfig.blockSizeHorizontal * 32,
                  height: heightCustomCategorieButton,
                  fillColor: colorWhite,
                  icon: IconData(int.parse(parentCategories[index].icon),
                      fontFamily: 'MaterialIcons'),
                  splashColor: colorDeepPurple400,
                  iconColor: colorDeepPurple400,
                  text: parentCategories[index].title,
                  textStyle: _myTextStyle,
                  onPressed: () =>
                      showSearchWithParentCategorie(parentCategories[index]),
                );
              }),
            );
          } else if (snapshot.hasError) {
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
            child: CupertinoActivityIndicator(
              radius: SizeConfig.blockSizeHorizontal * 5,
            ),
          );
        });
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

  void showSearchWithParentCategorie(Categorie parentCategorie) async {
    List<int> childCategories = new List();

    for (Categorie categorie in categories) {
      if (categorie.parentid == parentCategorie.id) {
        childCategories.add(categorie.id);
      }
    }

    showSearch(
      context: context,
      delegate: SearchPage(postList, myFavorits, _userEmail, _searchLabel, null,
          childCategories, parentCategorie),
    );
  }

  Future<List<Post>> _loadPost() async {
    print("Start load post");
    postList = await _postService.fetchActivePosts();
    return postList;
  }

  Future<List<Post>> _loadPostFromCache() async {
    print("Start load post cache");

    postList = await _postService.fetchActivePostFromCacheWithoutServerCall();
    return postList;
  }

  Future<void> _loadMyFavorits() async {
    _userEmail = await _sharedPreferenceService.read(USER_EMAIL);

    if (_userEmail != null && _userEmail.isNotEmpty) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(_userEmail);
    }
  }

  Future<List<Categorie>> _loadMyCategories() async {
    String listCategoryFromSharePrefs =
        await _sharedPreferenceService.read(CATEGORIE_LIST);

    if (listCategoryFromSharePrefs != null) {
      Iterable iterableCategories = jsonDecode(listCategoryFromSharePrefs);
      categories = await iterableCategories.map<Categorie>((category) {
        return Categorie.fromJsonPref(category);
      }).toList();
    } else {
      categories = await _categorieService.fetchCategories();

      //Cache translated categories
      String jsonCategorie = jsonEncode(categories);
      _sharedPreferenceService.save(CATEGORIE_LIST, jsonCategorie);
    }
    if (parentCategories == null || parentCategories.isEmpty) {
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
    }
    return parentCategories;
  }

  void setDeviceToken(String event) async {
    _deviceToken = event;
    if (_deviceToken.isNotEmpty) {
      _sharedPreferenceService.save(DEVICE_TOKEN, _deviceToken);
    }
    print('Device-Token-Home: $event');
  }
}

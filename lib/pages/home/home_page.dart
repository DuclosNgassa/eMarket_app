import 'dart:async';

import 'package:emarket_app/bloc/category_manager.dart';
import 'package:emarket_app/bloc/post_manager.dart';
import 'package:emarket_app/custom_component/custom_categorie_button.dart';
import 'package:emarket_app/custom_component/post_card_component.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/category_wrapper.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post_wrapper.dart';
import 'package:emarket_app/pages/search/search_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:emarket_app/util/util.dart';
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
  GlobalKey<RefreshIndicatorState> refreshKey;
  final PostService _postService = new PostService();
  final FavoritService _favoritService = new FavoritService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  PostManager _postManager = new PostManager();

  List<Message> allConversation = new List<Message>();
  bool showPictures = true;

  String _deviceToken = "";
  String _userEmail = "";
  String _searchLabel;
  final List<Message> fireBaseMessages = [];

  double heightCustomCategorieButton = SizeConfig.blockSizeVertical * 5;
  TextStyle _myTextStyle = TextStyle(
    color: GlobalColor.colorWhite,
    fontSize: SizeConfig.safeBlockHorizontal * 2.6,
  );
  List<Post> searchResult = new List();
  List<Post> postList = new List();
  List<Post> postListItems = new List();
  List<Favorit> myFavorits = new List();
  List<Category> categories = new List();

  List<Category> parentCategories = new List();

  int perPage = 10;
  int present = 0;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
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
    GlobalStyling().init(context);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: SizeConfig.blockSizeVertical * 11,
                      width: SizeConfig.screenWidth * 0.82,
                      child: _buildCategorieGridView(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: GlobalColor.colorDeepPurple400,
                          ),
                          iconSize: SizeConfig.blockSizeHorizontal * 11,
                          tooltip: AppLocalizations.of(context)
                              .translate('to_search'),
                          onPressed: _openSearchPage,
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
              bottom: 0, //SizeConfig.blockSizeVertical,
              right: SizeConfig.screenWidth * 0.39),
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () => _changeShowPictures(),
            tooltip: 'Image',
            child: Icon(
              Icons.image,
              size: SizeConfig.safeBlockHorizontal * 11,
            ),
          ),
        ));
  }

  _openSearchPage() {
    if (postList != null && postList.isNotEmpty) {
      showSearch(
        context: context,
        delegate: SearchPage(postList, myFavorits, _userEmail, _searchLabel,
            null, null, null, showPictures),
      );
    } else {
      _showLoadAllPostMessage();
    }
  }

  _changeShowPictures() async {
    showPictures = !showPictures;
    await Util.saveShowPictures(showPictures, _sharedPreferenceService);
    setState(() {});
  }

  Widget _buildPageWithDataFromServer() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await _invalidatePostCache();
      },
      child: StreamBuilder<PostWrapper>(
        stream: _postManager.postWrapper,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Stop load post cache");
            setPostData(snapshot);
            if (snapshot.data.postList.length > 0) {
              loadMorePost(snapshot.data.postList);
              return Container(
                padding: EdgeInsets.only(top: 10),
                constraints: BoxConstraints.expand(
                    height: SizeConfig.screenHeight * 0.845),
                child: PostCardComponentPage(
                    postList: snapshot.data.postList,
                    myFavorits: snapshot.data.favoritList,
                    userEmail: _userEmail,
                    showPictures: snapshot.data.showPictures),
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
                AppLocalizations.of(context).translate('error'),
                AppLocalizations.of(context).translate('error_loading'),
                Icon(
                  Icons.info_outline,
                  size: 28,
                  color: Colors.redAccent,
                ),
                Colors.redAccent,
                3);
          }
          return _buildPageWithDataFromCache();
        },
      ),
    );
  }

  void setPostData(AsyncSnapshot<PostWrapper> snapshot) {
    postList = snapshot.data.postList;
    showPictures = snapshot.data.showPictures;
    myFavorits = snapshot.data.favoritList;
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
              AppLocalizations.of(context).translate('error'),
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
    CategoryManager _categoryManager = new CategoryManager(context);

    return StreamBuilder<CategoryWrapper>(
      stream: _categoryManager.categoryWrapper,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          parentCategories = snapshot.data.parentCategories;
          categories = snapshot.data.childCategories;
          return GridView.count(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            crossAxisCount: 1,
            scrollDirection: Axis.horizontal,
            children: List.generate(parentCategories.length, (index) {
              return CustomCategorieButton(
                width: SizeConfig.blockSizeHorizontal * 32,
                height: heightCustomCategorieButton,
                fillColor: GlobalColor.colorWhite,
                icon: Util.getCategoryIcon(
                    parentCategories[index].id, parentCategories[index].icon),
                splashColor: GlobalColor.colorDeepPurple400,
                iconColor: GlobalColor.colorDeepPurple400,
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
              AppLocalizations.of(context).translate('error'),
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
      },
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

  void showSearchWithParentCategorie(Category parentCategorie) async {
    List<int> childCategories = new List();

    if (postList != null && postList.isNotEmpty) {
      for (Category categorie in categories) {
        if (categorie.parentid == parentCategorie.id) {
          childCategories.add(categorie.id);
        }
      }

      showSearch(
        context: context,
        delegate: SearchPage(postList, myFavorits, _userEmail, _searchLabel,
            null, childCategories, parentCategorie, showPictures),
      );
    } else {
      _showLoadAllPostMessage();
    }
  }

  void _showLoadAllPostMessage() {
    MyNotification.showInfoFlushbar(
        context,
        AppLocalizations.of(context).translate('info'),
        AppLocalizations.of(context).translate('download_all_post_first'),
        Icon(
          Icons.info_outline,
          size: 28,
          color: GlobalColor.colorBlue,
        ),
        GlobalColor.colorBlue,
        4);
  }

  Future<List<Post>> _loadPostFromCache() async {
    print("Start load post cache");

    postList = await _postService.fetchActivePostFromCacheWithoutServerCall();
    await _loadMyFavorits();

    return postList;
  }

  void setDeviceToken(String event) async {
    _deviceToken = event;
    if (_deviceToken.isNotEmpty) {
      _sharedPreferenceService.save(DEVICE_TOKEN, _deviceToken);
    }
    print('Device-Token-Home: $event');
  }

  Future<void> _invalidatePostCache() async {
    await _sharedPreferenceService.remove(CATEGORIE_LIST_CACHE_TIME);
    await _sharedPreferenceService.remove(POST_LIST_CACHE_TIME);

    setState(() {});
  }

  Future<void> _loadMyFavorits() async {
    _userEmail = await _sharedPreferenceService.read(USER_EMAIL);

    if (_userEmail != null && _userEmail.isNotEmpty) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(_userEmail);
    }
  }
}

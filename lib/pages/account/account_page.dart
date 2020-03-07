import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/custom_component/placeholder_item.dart';
import 'package:emarket_app/form/post_edit_form.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/login_source.dart';
import 'package:emarket_app/model/enumeration/status.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shimmer/shimmer.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountState createState() => new _AccountState();
}

class _AccountState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  final PostService _postService = new PostService();
  final FavoritService _favoritService = new FavoritService();
  final SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  final GoogleSignIn _gSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TabController controller;

  String userName = 'eMarket';
  String userEmail = 'eMarket@softsolutions.de';
  List<Post> _myPosts = new List();
  List<Post> _myFavoritPosts = new List();
  List<Favorit> _myFavorits = new List();

  @override
  void initState() {
    loadUser();
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 2),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      userName,
                                      style: GlobalStyling.styleTitleWhite,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  showLogout(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 2),
                              child: Text(
                                userEmail,
                                style: GlobalStyling.styleNormalWhite,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      expandedHeight: SizeConfig.screenHeight * 0.19,
                      bottom: TabBar(
                        labelColor: GlobalColor.colorDeepPurple500,
                        labelStyle: GlobalStyling.styleNormalBlackBold,
                        //isScrollable: true,
                        indicatorColor: GlobalColor.colorDeepPurple400,
                        tabs: [
                          Tab(
                              text: AppLocalizations.of(context)
                                  .translate('my_adverts')),
                          Tab(
                              text: AppLocalizations.of(context)
                                  .translate('my_favorits')),
                        ],
                        controller: controller,
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: controller,
                  children: [
                    buildMyPostListView(),
                    buildMyFavoritPostListView(),
                  ],
                ),
              ),
            );
          }
          return new Login(LoginSource.accountPage, null);
        });
  }

  Widget buildMyPostListView() {
    return FutureBuilder(
      future: _loadMyPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                itemBuilder: (context, index) => Slidable(
                      actionPane: SlidableBehindActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: GlobalColor.colorTransparent,
                        child: Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: GlobalColor.colorGrey200,
                            ),
                            child: ListTile(
                              onTap: () =>
                                  showPostDetailPage(_myPosts.elementAt(index)),
                              leading: CircleAvatar(
                                backgroundColor:
                                    isPostArchivated(_myPosts.elementAt(index))
                                        ? GlobalColor.colorGrey400
                                        : GlobalColor.colorDeepPurple300,
                                child: Text((index + 1).toString()),
                                foregroundColor: GlobalColor.colorWhite,
                              ),
                              title: Text(_myPosts.elementAt(index).title),
                              subtitle: Text(DateConverter.convertToString(
                                  _myPosts.elementAt(index).created_at,
                                  context)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      _myPosts.elementAt(index).fee.toString() +
                                          ' ' +
                                          AppLocalizations.of(context)
                                              .translate('fcfa')),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical,
                                  ),
                                  isPostArchivated(_myPosts.elementAt(index))
                                      ? Text(
                                          AppLocalizations.of(context)
                                              .translate('sold'),
                                          style: GlobalStyling.styleFormGrey,
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        isPostActive(
                          _myPosts.elementAt(index),
                        )
                            ? IconSlideAction(
                                caption: AppLocalizations.of(context)
                                    .translate('sold'),
                                color: Colors.green,
                                icon: Icons.done,
                                onTap: () => archivatePost(
                                    _myPosts.elementAt(index), index),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        isPostActive(_myPosts.elementAt(index))
                            ? IconSlideAction(
                                caption: AppLocalizations.of(context)
                                    .translate('change'),
                                color: GlobalColor.colorBlue,
                                icon: Icons.edit,
                                onTap: () => showPostEditForm(
                                  _myPosts.elementAt(index),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption:
                              AppLocalizations.of(context).translate('delete'),
                          color: GlobalColor.colorRed,
                          icon: Icons.delete,
                          onTap: () => _showDeletePostDialog(
                              _myPosts.elementAt(index), index),
                        ),
                      ],
                    ),
                itemCount: _myPosts.length);
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 2,
                  vertical: SizeConfig.blockSizeVertical),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)
                                .translate('no_sell_item1') +
                            "\n\n" +
                            AppLocalizations.of(context)
                                .translate('no_sell_item2'),
                        style: GlobalStyling.styleTitleBlack,
                      ),
                    ),
                  ),
                ],
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
        return ListView.builder(
          itemCount: 10,
          // Important code
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[400],
            highlightColor: Colors.white,
            child: ListItem(
              page: ACCOUNTPAGE,
            ),
          ),
        );
      },
    );
  }

  Widget buildMyFavoritPostListView() {
    return FutureBuilder(
      future: _loadMyFavorits(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                itemBuilder: (context, index) => Slidable(
                      actionPane: SlidableBehindActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.transparent,
                        child: Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: GlobalColor.colorGrey200,
                            ),
                            child: ListTile(
                              onTap: () => showPostDetailPage(
                                  _myFavoritPosts.elementAt(index)),
                              leading: CircleAvatar(
                                backgroundColor: isPostActive(
                                        _myFavoritPosts.elementAt(index))
                                    ? GlobalColor.colorDeepPurple300
                                    : GlobalColor.colorGrey400,
                                child: Text((index + 1).toString()),
                                foregroundColor: GlobalColor.colorWhite,
                              ),
                              title:
                                  Text(_myFavoritPosts.elementAt(index).title),
                              subtitle: Text(DateConverter.convertToString(
                                  _myFavoritPosts.elementAt(index).created_at,
                                  context)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(_myFavoritPosts
                                          .elementAt(index)
                                          .fee
                                          .toString() +
                                      ' ' +
                                      AppLocalizations.of(context)
                                          .translate('fcfa')),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical,
                                  ),
                                  !isPostActive(
                                          _myFavoritPosts.elementAt(index))
                                      ? Text(
                                          AppLocalizations.of(context)
                                              .translate('sold'),
                                          style: GlobalStyling.styleFormGrey,
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption:
                              AppLocalizations.of(context).translate('delete'),
                          color: GlobalColor.colorRed,
                          icon: Icons.delete,
                          onTap: () => _showDeleteFavoritDialog(
                              _myFavoritPosts.elementAt(index).id, index),
                        ),
                      ],
                    ),
                itemCount: _myFavoritPosts.length);
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 2,
                  vertical: SizeConfig.blockSizeVertical),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate('no_favorit') +
                            "\n\n" +
                            AppLocalizations.of(context)
                                .translate('mark_favorit'),
                        style: GlobalStyling.styleTitleBlack,
                      ),
                    ),
                  ),
                ],
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
        return ListView.builder(
          itemCount: 10,
          // Important code
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[400],
            highlightColor: Colors.white,
            child: ListItem(
              page: ACCOUNTPAGE,
            ),
          ),
        );
      },
    );
  }

  bool isPostActive(Post post) {
    return post.status == Status.active;
  }

  bool isPostArchivated(Post post) {
    return post.status == Status.archivated;
  }

  Future<void> archivatePost(Post post, int index) async {
    post.status = Status.archivated;
    Map<String, dynamic> postParams = post.toMapUpdate(post);
    Post updatedPost = await _postService.update(postParams);
    _myPosts.removeAt(index);
    _myPosts.insert(index, updatedPost);
    setState(() {});
  }

  showPostDetailPage(Post post) {
    if (isPostActive(post)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PostDetailPage(post);
          },
        ),
      );
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('item_sold'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
    }
  }

  Future<void> _showDeleteFavoritDialog(int id, int index) async {
    return MyNotification.showConfirmationDialog(
        context,
        AppLocalizations.of(context).translate('confirmation'),
        AppLocalizations.of(context).translate('confirm_delete'),
        () => {deleteFavoritPost(id, index), Navigator.of(context).pop()},
        () => Navigator.of(context).pop());
  }

  Future<void> _showDeletePostDialog(Post post, int index) async {
    return MyNotification.showConfirmationDialog(
        context,
        AppLocalizations.of(context).translate('confirmation'),
        AppLocalizations.of(context).translate('confirm_delete'),
        () => {deletePost(post, index), Navigator.of(context).pop()},
        () => Navigator.of(context).pop());
  }

  Future<void> deletePost(Post _post, int index) async {
    Post post = _post;
    post.status = Status.deleted;

    Map<String, dynamic> postParams = post.toMapUpdate(post);
    await _postService.update(postParams);
    _myPosts.removeAt(index);

    //Find if favoritList contains deleted post
    int indexFavoritToUpdate =
        _myFavoritPosts.indexWhere((item) => item.id == _post.id);
    if (indexFavoritToUpdate >= 0) {
      Post postFavoriteToUpdate =
          _myFavoritPosts.removeAt(indexFavoritToUpdate);
      postFavoriteToUpdate.status = Status.deleted;
      _myFavoritPosts.insert(indexFavoritToUpdate, postFavoriteToUpdate);
    }
    setState(() {});
  }

  Future<void> deleteFavoritPost(int postId, int index) async {
    for (int i = 0; i < _myFavorits.length; i++) {
      if (_myFavorits[i].postid == postId) {
        await _favoritService.delete(_myFavorits[i].id);
        _myFavoritPosts.removeAt(index);
        break;
      }
    }
    setState(() {});
  }

  showPostEditForm(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostEditForm(post, _scaffoldKey);
        },
      ),
    );
  }

  Future<void> loadUser() async {
    String _userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    String _userName = await _sharedPreferenceService.read(USER_NAME);
    if (_userEmail != null && _userEmail.isNotEmpty) {
      userEmail = _userEmail;
      userName = _userName ?? userName;
      //_loadMyFavorits();
      //setState(() {});
    }
  }

  Future<List<Post>> _loadMyPosts() async {
    if (userEmail != null && _myPosts.isEmpty) {
      _myPosts = await _postService.fetchPostByUserEmail(userEmail);
    }

    return _myPosts;
  }

  Future<List<Post>> _loadMyFavorits() async {
    if (userEmail != null &&
        userEmail.isNotEmpty &&
        _myFavorits.isEmpty &&
        _myFavoritPosts.isEmpty) {
      String EMAIL_MY_FAVORIT_LIST_CACHE_TIME =
          MY_FAVORIT_LIST_CACHE_TIME + userEmail;

      String cacheTimeString =
          await _sharedPreferenceService.read(EMAIL_MY_FAVORIT_LIST_CACHE_TIME);
      if (cacheTimeString != null) {
        DateTime cacheTime = DateTime.parse(cacheTimeString);
        DateTime actualDateTime = DateTime.now();

        if (actualDateTime.difference(cacheTime) > Duration(minutes: 3)) {
          _myFavoritPosts =
              await _favoritService.loadMyFavoritFromServer(userEmail);
        } else {
          _myFavoritPosts =
              await _favoritService.loadMyFavoritFromCache(userEmail);
        }
      } else {
        _myFavoritPosts =
            await _favoritService.loadMyFavoritFromServer(userEmail);
      }
      return _myFavoritPosts;
    }

    return _myFavoritPosts;
  }

  Widget showLogout() {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            //FirebaseUser user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 2),
              child: CustomButton(
                fillColor: GlobalColor.colorRed,
                icon: FontAwesomeIcons.signOutAlt,
                //icon: Icons.directions_run,
                splashColor: Colors.white,
                iconColor: Colors.white,
                text: AppLocalizations.of(context).translate('logout'),
                textStyle: TextStyle(
                    color: Colors.white, fontSize: SizeConfig.BUTTON_FONT_SIZE),
                onPressed: () => _logOut(),
              ),
            );
          }

          /// other way there is no user logged.
          return new CupertinoActivityIndicator(
            radius: SizeConfig.safeBlockHorizontal * 10,
          );
        });
  }

  _logOut() async {
    await FirebaseAuth.instance.signOut();
    _gSignIn.signOut();
    _sharedPreferenceService.clearForLogOut();

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => new NavigationPage(
            HOMEPAGE), //new ProfileScreen(detailsUser: details),
      ),
    );
  }
}

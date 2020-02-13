import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/form/post_edit_form.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/status.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountState createState() => new _AccountState();
}

class _AccountState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  final PostService _postService = new PostService();
  final FavoritService _favoritService = new FavoritService();
  final GoogleSignIn _gSignIn = GoogleSignIn();
  TabController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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
                                      style: SizeConfig.styleTitleWhite,
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
                                style: SizeConfig.styleNormalWhite,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      expandedHeight: SizeConfig.screenHeight * 0.19,
                      bottom: TabBar(
                        labelColor: Colors.black,
                        labelStyle: SizeConfig.styleNormalBlack,
                        //isScrollable: true,
                        indicatorColor: colorDeepPurple400,
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
            return ListView.separated(
                itemBuilder: (context, index) => Slidable(
                      actionPane: SlidableBehindActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () =>
                              showPostDetailPage(_myPosts.elementAt(index)),
                          leading: CircleAvatar(
                            backgroundColor:
                                isPostArchivated(_myPosts.elementAt(index))
                                    ? colorGrey400
                                    : colorDeepPurple300,
                            child: Text((index + 1).toString()),
                            foregroundColor: colorWhite,
                          ),
                          title: Text(_myPosts.elementAt(index).title),
                          subtitle: Text(DateConverter.convertToString(
                              _myPosts.elementAt(index).created_at, context)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(_myPosts.elementAt(index).fee.toString() +
                                  ' ' +
                                  AppLocalizations.of(context)
                                      .translate('fcfa')),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical,
                              ),
                              if (isPostArchivated(_myPosts.elementAt(index)))
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('sold'),
                                  style: SizeConfig.styleFormGrey,
                                ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        if (isPostActive(_myPosts.elementAt(index)))
                          IconSlideAction(
                            caption:
                                AppLocalizations.of(context).translate('sold'),
                            color: Colors.green,
                            icon: Icons.done,
                            onTap: () =>
                                archivatePost(_myPosts.elementAt(index), index),
                          ),
                        if (isPostActive(_myPosts.elementAt(index)))
                          IconSlideAction(
                            caption: AppLocalizations.of(context)
                                .translate('change'),
                            color: colorBlue,
                            icon: Icons.edit,
                            onTap: () =>
                                showPostEditForm(_myPosts.elementAt(index)),
                          ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption:
                              AppLocalizations.of(context).translate('delete'),
                          color: colorRed,
                          icon: Icons.delete,
                          onTap: () => _showDeletePostDialog(
                              _myPosts.elementAt(index), index),
                        ),
                      ],
                    ),
                separatorBuilder: (context, index) => Divider(),
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
                        style: SizeConfig.styleTitleBlack,
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
      },
    );
  }

  bool isPostActive(Post post) {
    return post.status == Status.active;
  }

  bool isPostArchivated(Post post) {
    return post.status == Status.archivated;
  }

  Widget buildMyFavoritPostListView() {
    if (_myFavoritPosts.length > 0) {
      return ListView.separated(
          itemBuilder: (context, index) => Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () =>
                        showPostDetailPage(_myFavoritPosts.elementAt(index)),
                    leading: CircleAvatar(
                      backgroundColor:
                          isPostActive(_myFavoritPosts.elementAt(index))
                              ? colorDeepPurple300
                              : colorGrey400,
                      child: Text((index + 1).toString()),
                      foregroundColor: colorWhite,
                    ),
                    title: Text(_myFavoritPosts.elementAt(index).title),
                    subtitle: Text(DateConverter.convertToString(
                        _myFavoritPosts.elementAt(index).created_at, context)),
                    trailing: Text(
                        _myFavoritPosts.elementAt(index).fee.toString() +
                            ' ' +
                            AppLocalizations.of(context).translate('fcfa')),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: AppLocalizations.of(context).translate('delete'),
                    color: colorRed,
                    icon: Icons.delete,
                    onTap: () => _showDeleteFavoritDialog(
                        _myFavoritPosts.elementAt(index).id, index),
                  ),
                ],
              ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: _myFavoritPosts.length);
    } else {
      return new Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2,
              vertical: SizeConfig.blockSizeVertical),
          child: Text(
            AppLocalizations.of(context).translate('no_favorit') +
                "\n\n" +
                AppLocalizations.of(context).translate('mark_favorit'),
            style: SizeConfig.styleTitleBlack,
          ),
        ),
      );
    }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString(USER_EMAIL);
    String _userName = prefs.getString(USER_NAME);
    if (_userEmail != null && _userEmail.isNotEmpty) {
      userEmail = _userEmail;
      userName = _userName == null ? userName : _userName;
      _loadMyFavorits();
      setState(() {});
    }
  }

  Future<List<Post>> _loadMyPosts() async {
    if (userEmail != null && _myPosts.isEmpty) {
      _myPosts = await _postService.fetchPostByUserEmail(userEmail);
    }

    return _myPosts;
  }

  Future<void> _loadMyFavorits() async {
    if (userEmail != null &&
        userEmail.isNotEmpty &&
        _myFavorits.isEmpty &&
        _myFavoritPosts.isEmpty) {
      _myFavorits = await _favoritService.fetchFavoritByUserEmail(userEmail);
      _myFavoritPosts.clear();
      for (Favorit favorit in _myFavorits) {
        Post post = await _postService.fetchPostById(favorit.postid);
        _myFavoritPosts.add(post);
      }
    }
    setState(() {});
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
                fillColor: colorRed,
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
    clearSharedPreferences();

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => new NavigationPage(
            HOMEPAGE), //new ProfileScreen(detailsUser: details),
      ),
    );
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/form/post_edit_form.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/status.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/image_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final ImageService _imageService = new ImageService();
  final GoogleSignIn _gSignIn = GoogleSignIn();
  TabController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String userName = 'Utilisateur-eMarket';
  String userEmail = 'eMarket@softsolutions.de';
  List<Post> myPosts = new List();
  List<Post> myPostFavorits = new List();
  List<Favorit> myFavorits = new List();

  @override
  void initState() {
    super.initState();
    _loadMyPosts();
    _loadMyFavorits();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
                      backgroundColor: colorDeepPurple300,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      userName,
                                      style: titleStyleWhite,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  showLogout(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                userEmail,
                                style: normalStyleWhite,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      expandedHeight: 105.0,
                      bottom: TabBar(
                        //isScrollable: true,
                        indicatorColor: colorDeepPurple500,
                        labelColor: colorWhite,
                        tabs: [
                          Tab(text: 'MES POSTS'),
                          Tab(text: 'MES FAVORITS'),
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
    if (myPosts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  "Vous n´avez pas encore vendu ou recherché d´objects. "
                  "\n\nTransformez les choses que vous n´utilisez tres peu ou jamais en argent!",
                  style: titleDetailStyle,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) => Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: colorWhite,
                child: ListTile(
                  onTap: () => showPostDetailPage(myPosts.elementAt(index)),
                  leading: CircleAvatar(
                    backgroundColor: colorDeepPurple300,
                    child: Text((index + 1).toString()),
                    foregroundColor: colorWhite,
                  ),
                  title: Text(myPosts.elementAt(index).title),
                  subtitle: Text(DateConverter.convertToString(
                      myPosts.elementAt(index).created_at)),
                  trailing:
                      Text(myPosts.elementAt(index).fee.toString() + " FCFA"),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Vendu',
                  color: Colors.green,
                  icon: Icons.done,
                  onTap: () => archivatePost(myPosts.elementAt(index), index),
                ),
                IconSlideAction(
                  caption: 'Modifier',
                  color: colorBlue,
                  icon: Icons.edit,
                  onTap: () => showPostEditForm(myPosts.elementAt(index)),
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Supprimer',
                  color: colorRed,
                  icon: Icons.delete,
                  onTap: () =>
                      _showDeletePostDialog(myPosts.elementAt(index).id, index),
                ),
              ],
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: myPosts.length);
  }

  Widget buildMyFavoritPostListView() {
    if (myPostFavorits.isEmpty) {
      return new Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Vous n´avez pas encore de favorits. "
            "\n\n Marquez un post avec l´étoile pour l´enregister dans vos favorits!",
            style: titleDetailStyle,
          ),
        ),
      );
    }

    return ListView.separated(
        itemBuilder: (context, index) => Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: colorWhite,
                child: ListTile(
                  onTap: () =>
                      showPostDetailPage(myPostFavorits.elementAt(index)),
                  leading: CircleAvatar(
                    backgroundColor: colorDeepPurple300,
                    child: Text((index + 1).toString()),
                    foregroundColor: colorWhite,
                  ),
                  title: Text(myPostFavorits.elementAt(index).title),
                  subtitle: Text(DateConverter.convertToString(
                      myPostFavorits.elementAt(index).created_at)),
                  trailing: Text(
                      myPostFavorits.elementAt(index).fee.toString() + " FCFA"),
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Supprimer',
                  color: colorRed,
                  icon: Icons.delete,
                  onTap: () => _showDeleteFavoritDialog(
                      myPostFavorits.elementAt(index).id, index),
                ),
              ],
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: myPostFavorits.length);
  }

  Future<void> archivatePost(Post post, int index) async {
    post.status = Status.archivated;
    Map<String, dynamic> postParams = post.toMapUpdate(post);
    Post updatedPost = await _postService.update(postParams);
    myPosts.removeAt(index);
    myPosts.add(updatedPost);
    setState(() {});
  }

  showPostDetailPage(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(post);
        },
      ),
    );
  }

  Future<void> _showDeleteFavoritDialog(int id, int index) async {
    return MyNotification.showConfirmationDialog(
        context,
        'Confirmation',
        'Voulez vous vraiment supprimer ce favorit?',
        () => {deleteFavoritPost(id, index), Navigator.of(context).pop()},
        () => Navigator.of(context).pop());
  }

  Future<void> _showDeletePostDialog(int id, int index) async {
    return MyNotification.showConfirmationDialog(
        context,
        'Confirmation',
        'Voulez vous vraiment supprimer cette annonce?',
        () => {deletePost(id, index), Navigator.of(context).pop()},
        () => Navigator.of(context).pop());
  }

  Future<void> deletePost(int id, int index) async {
    bool isImageDeleted = await _imageService.deleteByPostID(id);
    if (isImageDeleted) {
      bool isPostDeleted = await _postService.delete(id);
      if (isPostDeleted) {
        myPosts.removeAt(index);
      }
      setState(() {});
    }
  }

  Future<void> deleteFavoritPost(int postId, int index) async {
    for (int i = 0; i < myFavorits.length; i++) {
      if (myFavorits[i].postid == postId) {
        await _favoritService.delete(myFavorits[i].id);
        myPostFavorits.removeAt(index);
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

  Future<void> _loadMyPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString(USER_EMAIL);
    String _userName = prefs.getString(USER_NAME);
    if (_userEmail != null) {
      userEmail = _userEmail;
      userName = _userName == null ? userName : _userName;
      myPosts = await _postService.fetchPostByUserEmail(userEmail);
      setState(() {});
    }
  }

  Future<void> _loadMyFavorits() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(user.email);

      for (var i = 0; i < myFavorits.length; i++) {
        Post post = await _postService.fetchPostById(myFavorits[i].postid);
        myPostFavorits.add(post);
      }
      setState(() {});
    }
  }

  Widget showLogout() {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return CustomButton(
              fillColor: colorRed,
              icon: FontAwesomeIcons.signOutAlt,
              //icon: Icons.directions_run,
              splashColor: Colors.white,
              iconColor: Colors.white,
              text: 'Se deconnecter',
              textStyle:
                  TextStyle(color: Colors.white, fontSize: BUTTON_FONT_SIZE),
              onPressed: () => _logOut(),
            );
          }

          /// other way there is no user logged.
          return new Container();
        });
  }

  _logOut() async {
    await FirebaseAuth.instance.signOut();
    _gSignIn.signOut();
    clearSharedPreferences();
    print('Signed out');

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) =>
            new NavigationPage(0), //new ProfileScreen(detailsUser: details),
      ),
    );
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

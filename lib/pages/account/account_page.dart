import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/form/post_edit_form.dart';
import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/global.dart' as prefix0;
import 'package:emarket_app/services/image_service.dart';
import 'package:emarket_app/services/post_service.dart';
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
  final ImageService _imageService = new ImageService();
  final GoogleSignIn _gSignIn = GoogleSignIn();
  TabController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String userName = 'eMarket';
  String userEmail = 'eMarket@softsolutions.de';
  List<Post> myPosts = new List();
  List<Post> myFavorits = new List();

  @override
  void initState() {
    super.initState();
    _loadMyPosts();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: false,
                        backgroundColor: prefix0.colorDeepPurple300,
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
                          isScrollable: true,
                          indicatorColor: Colors.black,
                          labelColor: Colors.black,
                          tabs: [
                            Tab(text: 'POSTS'),
                            Tab(text: 'FAVORITS'),
                            Tab(text: 'CONFIGURATION'),
                          ],
                          controller: controller,
                        ),
                      )
                    ];
                  },
                  body: TabBarView(
                    controller: controller,
                    children: [
                      buildListView(),
                      Icon(Icons.star),
                      Icon(Icons.build),
                    ],
                  ),
                ),
              ),
            );
          }
          return Login(LoginSource.accountPage, null);
        });
  }

  Widget buildListView() {
    return ListView.separated(
        itemBuilder: (context, index) => Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: colorWhite,
                child: ListTile(
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
                  caption: 'Ouvrir',
                  color: prefix0.colorDeepPurple300,
                  icon: Icons.description,
                  onTap: () => showPostDetailPage(myPosts.elementAt(index)),
                ),
                IconSlideAction(
                  caption: 'Modifier',
                  color: colorBlue,
                  icon: Icons.edit,
                  onTap: () => showPostEditForm(myPosts.elementAt(index)),
                ),
                IconSlideAction(
                  caption: 'Supprimer',
                  color: colorRed,
                  icon: Icons.delete,
                  onTap: () => deletePost(myPosts.elementAt(index).id, index),
                ),
              ],
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: myPosts.length);
  }

  // This is the builder method that creates a new page
  showPostDetailPage(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(post);
        },
      ),
    );
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
    userEmail = _userEmail == null ? userEmail : _userEmail;
    userName = _userName == null ? userName : _userName;
    myPosts = await _postService.fetchPostByUserEmail(userEmail);
    setState(() {});
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
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new NavigationPage(0),
      ),
    );
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/custom_component/post_card_edit.dart';
import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/global.dart' as prefix0;
import 'package:emarket_app/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final GoogleSignIn _gSignIn = GoogleSignIn();
  TabController controller;

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
        itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: PostCardEdit(myPosts.elementAt(index)),
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: myPosts.length);
  }

  Future<void> _loadMyPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString(USER_EMAIL);
    userName = prefs.getString(USER_NAME);
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

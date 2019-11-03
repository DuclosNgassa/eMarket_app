import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/model/user_status.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final LoginSource page;
  final Post _post;

  Login(this.page, this._post);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserService _userService = new UserService();

  Future<FirebaseUser> _signIn(BuildContext context) async {

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    FirebaseUser userDetails =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);

    UserDetails details = new UserDetails(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) =>
            navigate(), //new ProfileScreen(detailsUser: details),
      ),
    );
    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                  'https://images.unsplash.com/photo-1518050947974-4be8c7469f0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
                  fit: BoxFit.fill,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  colorBlendMode: BlendMode.modulate),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                  width: 250.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Color(0xffffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.google,
                            color: Color(0xffCE107C),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Sign in with Google',
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                        ],
                      ),
                      onPressed: () => _signIn(context)
                          .then((FirebaseUser user) => _saveUser(user))
                          .catchError((e) => print(e)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  navigate() {
    switch (widget.page) {
      case LoginSource.postPage:
        {
          return new NavigationPage(POSTPAGE);
        }
        break;
      case LoginSource.accountPage:
        {
          return new NavigationPage(ACCOUNTPAGE);
        }
        break;
      case LoginSource.messagePage:
        {
          return new NavigationPage(MESSAGEPAGE);
        }
        break;
      case LoginSource.ownerPage:
        {
          return new PostDetailPage(widget._post);
        }
        break;
    }
  }

  Future<User> _saveUser(FirebaseUser firebaseUser) async {
    User existsUser = await _userService.fetchUserByEmail(firebaseUser.email);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_EMAIL, firebaseUser.email);
    prefs.setString(USER_NAME, firebaseUser.displayName);

    if(existsUser != null){
      return existsUser;
    }
    else {
      User user = new User();
      user = _mapFirebaseUserToUser(firebaseUser);

      Map<String, dynamic> userParams = user.toMap(user);
      User savedUser = await _userService.saveUser(userParams);

      return savedUser;
    }
  }

  User _mapFirebaseUserToUser(FirebaseUser firebaseUser) {
    User user = new User();
    user.name = firebaseUser.displayName;
    user.email = firebaseUser.email;
    user.created_at = DateTime.now();
    user.rating = 5;
    user.status = UserStatus.active;
    user.phone_number ="";

    return user;
  }
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);

  final String providerDetails;
}

import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/login_source.dart';
import 'package:emarket_app/model/enumeration/user_status.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final SharedPreferenceService _sharedPreferenceService = new SharedPreferenceService();
  final UserService _userService = new UserService();

  String _deviceToken = "";

  @override
  void initState() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.onTokenRefresh.listen(setDeviceToken);
    _firebaseMessaging.getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: colorDeepPurple300,
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: SizeConfig.blockSizeVertical),
                Container(
                  width: SizeConfig.screenWidth -
                      SizeConfig.blockSizeHorizontal * 10,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      shape: const StadiumBorder(),
                      color: colorDeepPurple500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.google,
                            color: colorRed,
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                          Text(
                            AppLocalizations.of(context)
                                .translate('log_in_with_google'),
                            style: SizeConfig.styleButtonWhite,
                          ),
                        ],
                      ),
                      onPressed: () => _signIn(context),
/*
                      onPressed: () => _signIn(context)
                          .then((FirebaseUser user) => _saveUser(user))
                          .catchError((e) => print(e)),
*/
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

  Future<void> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    FirebaseUser userDetails =
        (await _firebaseAuth.signInWithCredential(credential)).user;

    await setSharedPreferences(userDetails);

    await _saveUser(userDetails);


    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) =>
            navigate(),
      ),
    );
  }

  Future<void> setSharedPreferences(FirebaseUser userDetails) async {
    _sharedPreferenceService.save(USER_EMAIL, userDetails.email);
    _sharedPreferenceService.save(USER_NAME, userDetails.displayName);
  }

  Future<void> _saveUser(FirebaseUser firebaseUser) async {
    User existsUser = await _userService.fetchUserByEmail(firebaseUser.email);

    _deviceToken = await _sharedPreferenceService.read(DEVICE_TOKEN);

    if (existsUser != null) {
      if (_deviceToken != null && _deviceToken.isNotEmpty) {
        if (existsUser.device_token != _deviceToken) {
          // user uses a new device
          existsUser.device_token = _deviceToken;

          Map<String, dynamic> userParams = existsUser.toMapUpdate(existsUser);
          User updatedUser = await _userService.update(userParams);

          return updatedUser;
        }
      }
      return existsUser;
    } else {
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
    user.phone_number = "";
    user.device_token = _deviceToken;

    return user;
  }

  void setDeviceToken(String fcmToken) async {
    _deviceToken = fcmToken;
    if (_deviceToken.isNotEmpty) {
      _sharedPreferenceService.save(DEVICE_TOKEN, _deviceToken);
    }
    print('Device-Token-Login: $fcmToken');
  }
}
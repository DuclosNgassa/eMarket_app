import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/login_source.dart';
import 'package:emarket_app/model/enumeration/user_status.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/global.dart';
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
  final SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  final UserService _userService = new UserService();
  final FavoritService _favoritService = new FavoritService();

  List<Favorit> myFavorits = new List();

  FirebaseUser _firebaseUser;
  String _deviceToken = "";
  String _deviceid = "";

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
    GlobalStyling().init(context);

    return Scaffold(
      backgroundColor: GlobalColor.colorDeepPurple300,
      body: Center(
        child: Container(
          height: SizeConfig.blockSizeVertical * 7,
          width: SizeConfig.screenWidth * 0.9,
          child: RaisedButton(
            shape: const StadiumBorder(),
            color: GlobalColor.colorDeepPurple500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.google,
                  color: GlobalColor.colorRed,
                  size: SizeConfig.safeBlockHorizontal * 8,
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                Text(
                  AppLocalizations.of(context).translate('log_in_with_google'),
                  style: GlobalStyling.styleButtonWhite,
                ),
              ],
            ),
            onPressed: () => _signIn(context),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    _firebaseUser = (await _firebaseAuth.signInWithCredential(credential)).user;

    await setSharedPreferences(_firebaseUser);

    await _saveUser(_firebaseUser);

    await _loadMyFavorits();

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => _navigate(),
      ),
    );
  }

  _navigate() {
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
          return new PostDetailPage(widget._post, myFavorits);
        }
        break;
    }
  }

  Future<void> setSharedPreferences(FirebaseUser userDetails) async {
    _sharedPreferenceService.save(USER_EMAIL, userDetails.email);
    _sharedPreferenceService.save(USER_NAME, userDetails.displayName);
  }

  Future<void> _saveUser(FirebaseUser firebaseUser) async {
    User existsUser = await _userService.fetchUserByEmail(firebaseUser.email);

    if (existsUser != null) {
      _deviceToken = await _sharedPreferenceService.read(DEVICE_TOKEN);
      _deviceid = await _getDeviceid();
      if (_deviceToken != null && _deviceToken.isNotEmpty) {
        // user uses a new device and has no deviceid yet
        if (existsUser.device_token != _deviceToken &&
            (existsUser.deviceid == null || existsUser.deviceid.isEmpty)) {
          existsUser.device_token = _deviceToken;
          existsUser.deviceid = _deviceid;
          return await updateUser(existsUser);
        } else if (existsUser.device_token != _deviceToken) {
          // user uses a new device
          existsUser.device_token = _deviceToken;
          return await updateUser(existsUser);
        } else if (existsUser.deviceid == null || existsUser.deviceid.isEmpty) {
          // user has no deviceid yet
          existsUser.deviceid = _deviceid;
          return await updateUser(existsUser);
        }
      } else if (existsUser.deviceid == null || existsUser.deviceid.isEmpty) {
        // user has no deviceid yet
        existsUser.deviceid = _deviceid;
        return await updateUser(existsUser);
      }
      return existsUser;
    } else {
      User user = new User();
      user = _mapFirebaseUserToUser(firebaseUser);
      user.deviceid = await _getDeviceid();

      Map<String, dynamic> userParams = user.toMap(user);
      User savedUser = await _userService.saveUser(userParams);

      return savedUser;
    }
  }

  Future<User> updateUser(User existsUser) async {
    Map<String, dynamic> userParams = existsUser.toMapUpdate(existsUser);
    User updatedUser = await _userService.update(userParams);

    return updatedUser;
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

  Future<void> _loadMyFavorits() async {
    if (_firebaseUser != null &&
        _firebaseUser.email != null &&
        _firebaseUser.email.isNotEmpty) {
      myFavorits =
          await _favoritService.fetchFavoritByUserEmail(_firebaseUser.email);

      // setState(() {});
    }
  }

  Future<String> _getDeviceid() async {
    String deviceid = await _sharedPreferenceService.read(DEVICE_ID);
    return deviceid;
  }
}

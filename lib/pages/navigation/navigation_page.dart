import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:emarket_app/custom_component/custom_icon_message.dart';
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart' as myMessage;
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/pages/account/account_page.dart';
import 'package:emarket_app/pages/help/info_page.dart';
import 'package:emarket_app/pages/home/home_page.dart';
import 'package:emarket_app/pages/message/chat_page.dart';
import 'package:emarket_app/pages/message/message_page.dart';
import 'package:emarket_app/pages/post/post_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationPage extends StatefulWidget {
  int _selectedIndex = 0;

  NavigationPage(this._selectedIndex);

  @override
  _NavigationPageState createState() => new _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool showPictures = false;
  static bool isLogedIn = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final PostService _postService = new PostService();
  final MessageService _messageService = new MessageService();
  final SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<myMessage.Message> allConversation = new List<myMessage.Message>();
  final FavoritService _favoritService = new FavoritService();
  List<Favorit> myFavorits = new List();

  int _localSelectedIndex = 0;
  int _incomingMessage = 0;
  String userEmail;

  @override
  void initState() {
    _localSelectedIndex = widget._selectedIndex;
    if (_localSelectedIndex > 0) {
      isLogedIn = true;
    }
    countUnreadMessage();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    super.initState();
    _fireBaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return new Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      height: SizeConfig.screenHeight / 4,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              GlobalColor.colorDeepPurple400,
                              GlobalColor.colorDeepPurple300
                            ],
                            begin: const FractionalOffset(1.0, 1.0),
                            end: const FractionalOffset(0.2, 0.2),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.safeBlockVertical * 7),
                    constraints: BoxConstraints.expand(
                        height: SizeConfig.safeBlockVertical * 90),
                    child: _widgetOptions.elementAt(_localSelectedIndex),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
                AppLocalizations.of(context).translate('home')), //Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text(AppLocalizations.of(context).translate('add_advert')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context).translate('account')),
          ),
          BottomNavigationBarItem(
            icon: buildNewMessageIcon(),
            title: Text(AppLocalizations.of(context).translate('messages')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text(AppLocalizations.of(context).translate('infos')),
          ),
        ],
        currentIndex: _localSelectedIndex,
        selectedItemColor: GlobalColor.colorDeepPurple400,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  void _fireBaseCloudMessagingListeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage-Navigation-Page: $message");
        setState(() {
          _incomingMessage++;
        });

        if (message.containsKey('notification')) {
          final dynamic notification = message['data'];
          showNotification(notification);
        }
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch-Navigation-Page: $message");

        if (message.containsKey('notification')) {
          final dynamic notification = message['data'];

          // Handle notification message
          _navigateToChat(notification);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        if (message.containsKey('notification')) {
          // Handle notification message
          final dynamic notification = message['data'];

          // Handle notification message
          _navigateToChat(notification);
        }

        print("onResume-Navigation-Page: $message");
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _navigateToChat(dynamic notification) async {
    int postId = int.parse(notification['postId']);
    String sender = notification['sender'];
    String receiver = notification['receiver'];

    await _getMessageByPostIdAndUserEmail(postId, sender, receiver);
    Post post = await _postService.fetchPostById(postId);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(
            messages: allConversation,
            post: post,
            myFavorits: myFavorits,
          );
        },
      ),
    );
  }

  Future<void> _getMessageByPostIdAndUserEmail(
      int postId, String sender, String receiver) async {
    List<myMessage.Message> messageByPostIds =
        await _messageService.fetchMessageByPostId(postId);

    // get all conversation between sender and receiver
    for (myMessage.Message message in messageByPostIds) {
      if ((message.sender == sender && message.receiver == receiver) ||
          (message.sender == receiver && message.receiver == sender)) {
        allConversation.add(message);
      }
    }

    setState(() {});
  }

  void _onItemTapped(int index) {
    if (index == MESSAGEPAGE) {
      _incomingMessage = 0;
    }
    countUnreadMessage();

    setState(() {
      _localSelectedIndex = index;
    });
  }

  Widget buildNewMessageIcon() {
    final Widget icon = Icon(
      FontAwesomeIcons.comments,
    );

    if (_incomingMessage > 0 && _localSelectedIndex != MESSAGEPAGE) {
      return Stack(
        children: <Widget>[
          Container(
            child: icon,
          ),
          Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 2,
                  left: SizeConfig.blockSizeHorizontal * 3),
              child: CustomIconMessage(countNewMessage: _incomingMessage)),
        ],
      );
    }
    return icon;
  }

  showNotification(dynamic notification) async {
    String title = notification['title'];
    String post_title = notification['post_title'];
    String sender_name = notification['sender_name'];
    String body = notification['body'];

    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: AppLocalizations.of(context).translate('new_message') +
            " " +
            sender_name +
            " " +
            AppLocalizations.of(context).translate('about_advert') +
            " " +
            post_title);
  }

  countUnreadMessage() async {
    await _loadUser();

    if (userEmail != null && userEmail.isNotEmpty) {
      List<myMessage.Message> messages =
          await _messageService.fetchMessageByReceiver(userEmail);
      _incomingMessage = _messageService.countNewMessage(messages, userEmail);
      setState(() {});
    }
  }

  Future<void> _loadUser() async {
    String _userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    if (_userEmail != null && _userEmail.isNotEmpty) {
      userEmail = _userEmail;
      _loadMyFavorits();
      setState(() {});
    }
  }

  Future<void> _loadMyFavorits() async {
    if (userEmail != null && userEmail.isNotEmpty) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(userEmail);
    }
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    PostPage(),
    AccountPage(),
    MessagePage(),
    InfoPage(),
  ];
}

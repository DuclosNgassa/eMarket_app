import 'dart:async';
import 'dart:convert';

import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/status.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import '../../util/global.dart';

class ChatPage extends StatefulWidget {
  List<Message> messages;
  Post post;
  String receiverName;
  List<Favorit> myFavorits;

  ChatPage({this.messages, this.post, this.myFavorits});

  @override
  _ChatPageState createState() =>
      new _ChatPageState(this.messages, this.post, this.myFavorits);
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  final MessageService messageService = new MessageService();
  final UserService _userService = new UserService();

  final TextEditingController _textEditingController =
      new TextEditingController();

  String userEmail;
  String userName;
  User receiver;
  Post post;
  List<Favorit> myFavorits;

  List<Message> _messages = new List(); // new
  _ChatPageState(this._messages, this.post, this.myFavorits);

  @override
  void initState() {
    initChatMessage();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message.containsKey('notification')) {
          await setNewIncomingMessage();
          final dynamic notification = message['data'];
          // Handle notification message
          if (notification['postId'] == post.id.toString() &&
              notification['sender'] == receiver.email) {
            insertFirebaseMessagingInMessages(notification, message);
          }
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if (message.containsKey('notification')) {
          await setNewIncomingMessage();
          final dynamic notification = message['data'];

          // Handle notification message
          if (notification['postId'] == post.id &&
              notification['receiver'] == userEmail) {
            insertFirebaseMessagingInMessages(notification, message);
          }
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        if (message.containsKey('notification')) {
          await setNewIncomingMessage();

          final dynamic notification = message['data'];
          // Handle notification message
          if (notification['postId'] == post.id &&
              notification['receiver'] == userEmail) {
            insertFirebaseMessagingInMessages(notification, message);
          }
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
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
                    padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 5,
                      top: SizeConfig.blockSizeVertical * 5,
                    ),
                    constraints: BoxConstraints.expand(
                        height: SizeConfig.screenHeight / 6),
                    child: _buildTitle(post),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 10.5),
                        constraints: BoxConstraints.expand(
                            height: SizeConfig.safeBlockVertical * 85),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                child: buildChatListView(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        decoration: new BoxDecoration(
                            color: Theme.of(context).cardColor),
                        child: _buildTextComposer(), //modified
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future setNewIncomingMessage() async {
    _sharedPreferenceService.save(NEW_MESSAGE, true);
  }

  void insertFirebaseMessagingInMessages(
      notification, Map<String, dynamic> message) {
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    setState(() {
      Message fireBaseMessage = new Message(
          body: notification["body"],
          created_at: DateTime.now().subtract(Duration(hours: 2)),
          postid: post != null ? post.id : widget.messages[0].postid,
          receiver: userName,
          sender: receiver.email);

      _messages.insert(0, fireBaseMessage);
    });

    completer.complete(message);
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  ListView buildChatListView() {
    return new ListView.builder(
      reverse: true,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
        child: Slidable(
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.25,
          child: buildMessageItem(index),
        ),
      ),
      itemCount: _messages.length,
    );
  }

  Padding buildMessageItem(int index) {
    if (userEmail == _messages.elementAt(index).sender) {
      return Padding(
        padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 20),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: Container(
            color: GlobalColor.colorDeepPurple100,
            child: ListTile(
              title: Text(_messages.elementAt(index).body),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child:
                          Text(AppLocalizations.of(context).translate('me'))),
                  Text(DateConverter.convertToString(
                      _messages.elementAt(index).created_at, context)),
                ],
              ),
            ),
          ),
        ),
      );
    } else
      return Padding(
        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 20),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Container(
            color: GlobalColor.colorGrey300,
            child: ListTile(
              title: Text(_messages.elementAt(index).body),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Text(DateConverter.convertToString(
                        _messages.elementAt(index).created_at, context)),
                  ),
                  Text(receiver != null && receiver.name != null
                      ? receiver.name
                      : ""),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                controller: _textEditingController,
                maxLines: 3,
                decoration: new InputDecoration.collapsed(
                  hintText:
                      AppLocalizations.of(context).translate('send_message'),
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal),
              child: new IconButton(
                icon: new Icon(
                  Icons.send,
                  color: GlobalColor.colorDeepPurple300,
                ),
                onPressed: () => _handleSubmitted(_textEditingController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initChatMessage() async {
    userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    userName = await _sharedPreferenceService.read(USER_NAME);
    //_messages = widget.messages;

    if (_messages.isEmpty) {
      await _getReceiverByEmail(post.useremail);
    } else {
      _messages.sort((message1, message2) =>
          message2.created_at.compareTo(message1.created_at));

      for (Message message in widget.messages) {
        if (message.sender != userEmail) {
          await _getReceiverByEmail(message.sender);
          break;
        }

        if (message.receiver != userEmail) {
          await _getReceiverByEmail(message.receiver);
          break;
        }
      }
    }

    updateMessageRead(widget.messages, userEmail);

    setState(() {});
  }

  Widget _buildTitle(Post post) {
    return Container(
      child: RawMaterialButton(
        onPressed: () => _showPostDetailPage(post),
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('chat'),
                style: GlobalStyling.styleTitleWhite,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
                    child: new Text(
                      AppLocalizations.of(context).translate('advert') +
                          ' ' +
                          post.title,
                      style: GlobalStyling.styleSubtitleWhite,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: GlobalColor.colorWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    Message message = new Message(
        body: text,
        created_at: DateTime.now(),
        postid: post != null ? post.id : widget.messages[0].postid,
        receiver: receiver.email,
        sender: userEmail);

    Map<String, dynamic> messageParams = message.toMap(message);
    messageService.saveMessage(messageParams);

    _textEditingController.clear();

    message.created_at = message.created_at.subtract(Duration(hours: 2));
    setState(() {
      _messages.insert(0, message);
    });
    sendFirebaseMessage(message);
  }

  Future sendFirebaseMessage(Message _message) async {
    await http.post(
      GOOGLE_FCM_END_POINT,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_KEY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _message.body,
            'title': 'Message: ' + userName + ': ' + post.title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'postId': post.id,
            'sender': userEmail,
            'sender_name': userName,
            'receiver': receiver.email,
            'post_title': post.title,
            'body': _message.body,
            'title': 'Message: ' + userName + ': ' + post.title
          },
          'to': receiver.device_token,
        },
      ),
    );
  }

  _showPostDetailPage(Post postToShow) {
    if (post.status == Status.active) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PostDetailPage(postToShow, myFavorits);
          },
        ),
      );
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('no_longer_available'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
      setState(() {});
    }
  }

  Future<void> _getReceiverByEmail(String email) async {
    receiver = await _userService.fetchUserByEmail(email);
    setState(() {});
  }

  void updateMessageRead(List<Message> messages, String useremail) {
    messageService.updateMessageRead(messages, useremail);
  }
}

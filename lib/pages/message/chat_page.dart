import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../services/global.dart';

class ChatPage extends StatefulWidget {
  List<Message> messages;
  Post post;
  String receiverName;

  ChatPage({this.messages, this.post});

  @override
  _ChatPageState createState() => new _ChatPageState(this.messages, this.post);
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final TextEditingController _textEditingController =
      new TextEditingController();

  String userEmail;
  String userName;
  User receiver;

  List<Message> _messages = new List(); // new
  final TextEditingController _textController = new TextEditingController();
  MessageService messageService = new MessageService();
  UserService _userService = new UserService();

  _ChatPageState(List<Message> messages, Post post);

  @override
  void initState() {
    initChatMessage();
    _fireBaseCloudMessagingListeners();
    super.initState();
  }

  void _fireBaseCloudMessagingListeners() {

    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {

        if (message.containsKey('notification')) {
          // Handle notification message
          final dynamic notification = message['notification'];

          Message fireBaseMessage = new Message();
          fireBaseMessage.created_at = DateTime.now();
          fireBaseMessage.id = 1;
          fireBaseMessage.sender = "Sender";
          fireBaseMessage.receiver = "Receiver";
          fireBaseMessage.body = notification["body"];

          //fireBaseMessages.add(fireBaseMessage);

          print("Message: " + notification["body"]);
        }

        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
  }


  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: colorDeepPurple300,
        title: _buildTitle(widget.post),
        automaticallyImplyLeading: false,
      ),
      body: new Column(
        //modified
        children: <Widget>[
          new Flexible(
            child: buildChatListView(),
          ),
          new Divider(height: SizeConfig.blockSizeVertical),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(), //modified
          ),
        ],
      ),
    );
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
          actions: <Widget>[
            IconSlideAction(
                caption: 'Modifier',
                color: colorBlue,
                icon: Icons.edit,
                onTap: null //() => showPostEditForm(myPosts.elementAt(index)),
                )
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'Supprimer',
                color: colorRed,
                icon: Icons.delete,
                onTap:
                    null //() => deletePost(myPosts.elementAt(index).id, index),
                ),
          ],
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
            color: Colors.deepPurple[100],
            child: ListTile(
              title: Text(_messages.elementAt(index).body),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Text("Moi")),
                  Text(DateConverter.convertToString(
                      _messages.elementAt(index).created_at)),
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
            color: Colors.black26,
            child: ListTile(
              title: Text(_messages.elementAt(index).body),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Text(DateConverter.convertToString(
                        _messages.elementAt(index).created_at)),
                  ),
                  Text(receiver.name),
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
                controller: _textEditingController,
                decoration: new InputDecoration.collapsed(
                  hintText: "Envoyez un message",
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal),
              child: new IconButton(
                icon: new Icon(
                  Icons.send,
                  color: colorDeepPurple300,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = await prefs.getString(USER_EMAIL);
    userName = prefs.getString(USER_NAME);
    _messages = widget.messages;

    if (_messages.isEmpty) {
      await _getReceiverByEmail(widget.post.useremail);
    } else {
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

    setState(() {});
  }

  Widget _buildTitle(Post post) {
    return Container(
      child: RawMaterialButton(
        onPressed: () => _showPostDetailPage(widget.post),
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      "Chat",
                      style: SizeConfig.styleTitleWhite,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
                    child: new Text(
                      "Annonce: " + widget.post.title,
                      style: SizeConfig.styleSubtitleWhite,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: colorWhite,
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
        postid:
        widget.post != null ? widget.post.id : widget.messages[0].postid,
        receiver: receiver.email,
        sender: userEmail);

    Map<String, dynamic> messageParams = message.toMap(message);
    messageService.saveMessage(messageParams);

    _textEditingController.clear();

    setState(() {
      _messages.insert(0, message);
    });
    sendAndRetrieveMessage(message);
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(Message _message) async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

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
            'title': widget.post.title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': receiver.device_token,//await _firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

  _showPostDetailPage(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(post);
        },
      ),
    );
  }

  Future<void> _getReceiverByEmail(String email) async {
    receiver = await _userService.fetchUserByEmail(email);
    setState(() {});
  }
}

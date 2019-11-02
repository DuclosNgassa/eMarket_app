import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/chat_message.dart';
import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/global.dart';

class ChatPage extends StatefulWidget {
  List<Message> messages;

  ChatPage({this.messages});

  @override
  _ChatPageState createState() => new _ChatPageState(this.messages);
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  String userEmail;
  String userName;
  String receiver = null;
  final List<ChatMessage> _chatMessages = <ChatMessage>[]; // new
  final TextEditingController _textController = new TextEditingController();
MessageService messageService = new MessageService();

  _ChatPageState(List<Message> messages);

  @override
  void initState() {
    initChatMessage();
    super.initState();
  }

  @override
  void dispose() {
    for (ChatMessage chatMessage in _chatMessages)
      chatMessage.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("eMarket-Chat"),
      ),
      body: new Column(
        //modified
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
                reverse: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Slidable(
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.25,
                        child: buildMessageItem(index),
                        actions: <Widget>[
                          IconSlideAction(
                              caption: 'Modifier',
                              color: colorBlue,
                              icon: Icons.edit,
                              onTap:
                                  null //() => showPostEditForm(myPosts.elementAt(index)),
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
                //separatorBuilder: (context, index) => Divider(),
                itemCount: _chatMessages.length),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(), //modified
          ),
        ],
      ),
    );
  }

  Padding buildMessageItem(int index) {
    if(userEmail == _chatMessages.elementAt(index).message.sender) {
      return Padding(
        padding: const EdgeInsets.only(right: 50.0),
        child: Container(
          color: colorWhite,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: colorDeepPurple300,
              child: Text(_chatMessages
                  .elementAt(index)
                  .name[0].toUpperCase()),
              foregroundColor: colorWhite,
            ),
            title: Text(_chatMessages
                .elementAt(index)
                .message
                .body),
            subtitle: Text(DateConverter.convertToString(
                _chatMessages
                    .elementAt(index)
                    .message
                    .created_at)),
          ),
        ),
      );
    } else return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Container(
        color: colorWhite,
        child: ListTile(
          trailing: CircleAvatar(
            backgroundColor: colorDeepPurple300,
            child: Text(_chatMessages
                .elementAt(index)
                .name[0].toUpperCase()),
            foregroundColor: colorWhite,
          ),
          title: Text(_chatMessages
              .elementAt(index)
              .message
              .body),
          subtitle: Text(DateConverter.convertToString(
              _chatMessages
                  .elementAt(index)
                  .message
                  .created_at)),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () =>
                      _handleSubmitted(_textEditingController.text)),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    Message message = new Message(
        body: text,
        created_at: DateTime.now(),
        postid: _chatMessages.elementAt(0).message.postid,
        receiver: receiver,
        sender: userEmail);

    //TODO save message
    Map<String, dynamic> messageParams = message.toMap(message);
    messageService.saveMessage(messageParams);

    _textEditingController.clear();
    ChatMessage chatMessage = new ChatMessage(
      message: message,
      name: userName,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 700), vsync: this),
    );
    setState(() {
      _chatMessages.insert(0, chatMessage);
    });
    chatMessage.animationController.forward();
  }

  void initChatMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString(USER_EMAIL);
    userName = prefs.getString(USER_NAME);

    for (Message message in widget.messages) {
      if(receiver == null && message.sender != userEmail){
        receiver = message.sender;
      }

      if(receiver == null && message.receiver != userEmail){
        receiver = message.receiver;
      }

      ChatMessage chatMessage = new ChatMessage(
          message: message,
          name: message.sender,
          animationController: new AnimationController(
              duration: new Duration(milliseconds: 700), vsync: this));
      _chatMessages.add(chatMessage);

    }
    //_chatMessages.sort((message1 , message2) => message1.message.created_at.isAfter(message2.message.created_at) ? 0 : 1);

    setState(() {});
  }
}

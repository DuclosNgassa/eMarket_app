import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/custom_component/chat_message.dart';
import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../services/global.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  final List<ChatMessage> _messages = <ChatMessage>[]; // new
  final TextEditingController _textController = new TextEditingController();

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
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
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
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
    _textEditingController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Duclos",
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 700), vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }
}

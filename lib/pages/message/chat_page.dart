import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/global.dart';

class ChatPage extends StatefulWidget {
  List<Message> messages;
  Post post;

  ChatPage({this.messages, this.post});

  @override
  _ChatPageState createState() => new _ChatPageState(this.messages, this.post);
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  String userEmail;
  String userName;
  String receiver = null;
  List<Message> _messages = new List(); // new
  final TextEditingController _textController = new TextEditingController();
  MessageService messageService = new MessageService();

  _ChatPageState(List<Message> messages, Post post);

  @override
  void initState() {
    initChatMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: colorDeepPurple300,
        title: _buildTitle(widget.post),
      ),
      body: new Column(
        //modified
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              reverse: true,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(top: 10.0),
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

  Padding buildMessageItem(int index) {
    if (userEmail == _messages.elementAt(index).sender) {
      return Padding(
        padding: const EdgeInsets.only(right: 50.0),
        child: Container(
          color: colorWhite,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: colorDeepPurple300,
              child: Text(_messages.elementAt(index).sender[0].toUpperCase()),
              foregroundColor: colorWhite,
            ),
            title: Text(_messages.elementAt(index).body),
            subtitle: Text(DateConverter.convertToString(
                _messages.elementAt(index).created_at)),
          ),
        ),
      );
    } else
      return Padding(
        padding: const EdgeInsets.only(left: 50.0),
        child: Container(
          color: Colors.black26,
          child: ListTile(
            trailing: CircleAvatar(
              backgroundColor: colorDeepPurple300,
              child: Text(_messages.elementAt(index).sender[0].toUpperCase()),
              foregroundColor: colorWhite,
            ),
            title: Text(_messages.elementAt(index).body),
            subtitle: Text(DateConverter.convertToString(
                _messages.elementAt(index).created_at)),
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
                //onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  hintText: "Envoyez un message",
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textEditingController.text),
              ),
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
        postid:
            widget.post != null ? widget.post.id : widget.messages[0].postid,
        receiver: receiver,
        sender: userEmail);

    Map<String, dynamic> messageParams = message.toMap(message);
    messageService.saveMessage(messageParams);

    _textEditingController.clear();

    setState(() {
      _messages.insert(0, message);
    });
  }

  void initChatMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString(USER_EMAIL);
    userName = prefs.getString(USER_NAME);
    _messages = widget.messages;

    if (_messages.isEmpty) {
      receiver = widget.post.useremail;
    } else {
      for (Message message in widget.messages) {
        if (receiver == null && message.sender != userEmail) {
          receiver = message.sender;
          break;
        }

        if (receiver == null && message.receiver != userEmail) {
          receiver = message.receiver;
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
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "eMarket-Chat",
                    style: styleTitleWhite,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "Annonce: " + widget.post.title,
                      style: styleSubtitleWhite,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
}

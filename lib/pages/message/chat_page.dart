import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/util/size_config.dart';
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
          new Divider(height: SizeConfig.blockSizeVertical * 0.5),
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
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "Chat",
                    style: SizeConfig.styleTitleWhite,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical,
                        right: SizeConfig.blockSizeHorizontal),
                    child: new Text(
                      "Annonce: " + widget.post.title,
                      style: SizeConfig.styleSubtitleWhite,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.blockSizeHorizontal),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: colorWhite,
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

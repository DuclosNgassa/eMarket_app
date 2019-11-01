import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/post_message.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/services/global.dart' as prefix0;
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../services/global.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => new _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Message> messages = new List();
  List<PostMessage> postMessages = new List();
  MessageService _messageService = new MessageService();
  PostService _postService = new PostService();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            // this is your user instance
            /// is because there is user already logged
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:55.0, right: 8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text("Messages", style: styleTitleWhite,),
                    ],
                  ),
                ),
                new Container(
                  constraints: BoxConstraints.expand(height: itemHeight * 0.67),
                  child: buildMyMessageListView(),
                ),
              ],
            );
          }
          // other way there is no user logged.
          return new Login(LoginSource.messagePage, null);
        });
  }

  Widget buildMyMessageListView() {
    if (messages.isEmpty) {
      return new Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Vous n´avez pas encore de messages")),
      );
    }

    return ListView.separated(
        itemBuilder: (context, index) => Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: colorWhite,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorDeepPurple300,
                    child: Text((index + 1).toString()),
                    foregroundColor: colorWhite,
                  ),
                  title: Text(postMessages.elementAt(index).post.title),
                  subtitle: postMessages.elementAt(index).messages.length > 1
                      ? Text(postMessages
                              .elementAt(index)
                              .messages
                              .length
                              .toString() +
                          " Messages")
                      : Text(postMessages
                              .elementAt(index)
                              .messages
                              .length
                              .toString() +
                          " Message"),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Ouvrir',
                  color: colorDeepPurple300,
                  icon: Icons.visibility,
                  onTap: null,
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Supprimer',
                  color: colorRed,
                  icon: Icons.delete,
                  onTap: null,
                ),
              ],
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: postMessages.length);
  }

  Future<List<PostMessage>> _loadMessageByEmail() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      List<PostMessage> _postMessageList = new List();
      messages = await _messageService.fetchMessageByEmail(user.email);

      Set<int> postIds = new Set();

      for (int i = 0; i < messages.length; i++) {
        await postIds.add(messages[i].postid);
      }

      for (int i = 0; i < postIds.length; i++) {
        Post post = await _postService.fetchPostById(postIds.elementAt(i));
        List<Message> messageList = new List();

        int messagesLength = messages.length;

        for (int j = 0; j < messagesLength; j++) {
          if (postIds.elementAt(i) == messages.elementAt(j).postid) {
            messageList.add(messages.elementAt(j));
            //TODO dieser Durchlauf optimieren
            //messages.removeAt(j);
            //messagesLength--;
            //--j;
          }
        }

        PostMessage postMessage =
            new PostMessage(messages: messageList, post: post);
        _postMessageList.add(postMessage);
      }

      return _postMessageList;
    }
    return null;
  }

  Future<void> _loadMessages() async {
    postMessages = await _loadMessageByEmail();
    setState(() {});
  }
}

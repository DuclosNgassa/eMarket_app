import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/post_message.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/model/user_message.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/message/chat_page.dart';
import 'package:emarket_app/pages/message/user_message_page.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/size_config.dart';
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
  UserService _userService = new UserService();
  FirebaseUser firebaseUser = null;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            firebaseUser = snapshot.data;
            // this is your user instance
            /// is because there is user already logged
            return Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 3),
                        child: new Text(
                          AppLocalizations.of(context).translate('my') + ' ' +
                              AppLocalizations.of(context)
                                  .translate('messages'),
                          style: SizeConfig.styleTitleWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 8),
                  child: new Container(
                    constraints: BoxConstraints.expand(
                        height: SizeConfig.screenHeight * 0.70),
                    child: buildMyMessageListView(),
                  ),
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
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 3,
            vertical: SizeConfig.blockSizeVertical * 2,
          ),
          child: Text(
            AppLocalizations.of(context).translate('no_messages'),
          ),
        ),
      );
    }

    return ListView.separated(
        itemBuilder: (context, index) => Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: colorWhite,
                child: ListTile(
                  onTap: () => openUserMessage(postMessages.elementAt(index),
                      postMessages.elementAt(index).post.title),
                  leading: CircleAvatar(
                    backgroundColor: colorDeepPurple300,
                    child: Text((index + 1).toString()),
                    foregroundColor: colorWhite,
                  ),
                  title: Text(postMessages.elementAt(index).post.title),
                  subtitle: postMessages.elementAt(index).messages.length > 1
                      ? Text(
                          postMessages
                                  .elementAt(index)
                                  .messages
                                  .length
                                  .toString() +
                              " " +
                              AppLocalizations.of(context)
                                  .translate('messages'),
                        )
                      : Text(
                          postMessages
                                  .elementAt(index)
                                  .messages
                                  .length
                                  .toString() +
                              " " +
                              AppLocalizations.of(context).translate('message'),
                        ),
                ),
              ),
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
        postIds.add(messages[i].postid);
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

  void openUserMessage(PostMessage postMessage, String userName) async {
    //Aktueller User ist Bezitzer des Post, dann kann er alle Nachrichten zu dieser Post sehen
    if (firebaseUser.email == postMessage.post.useremail) {
      List<UserMessage> userMessage =
          await _mapPostMessageToUserMessage(postMessage);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return UserMessagePage(userMessage, postMessage.post);
          },
        ),
      );
    } else {
      List<Message> messagesSentOrReceived = new List<Message>();
      for (Message message in postMessage.messages) {
        if (message.sender == firebaseUser.email ||
            message.receiver == firebaseUser.email) {
          messagesSentOrReceived.add(message);
        }
      }

      messagesSentOrReceived.sort((message1, message2) =>
          message1.created_at.isAfter(message2.created_at) ? 0 : 1);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ChatPage(
              messages: messagesSentOrReceived,
              post: postMessage.post,
            );
          },
        ),
      );
    }
  }

  Future<List<UserMessage>> _mapPostMessageToUserMessage(
      PostMessage postMessage) async {
    List<UserMessage> userMessages = new List();

    Set<String> userEmails = new Set();
    for (int i = 0; i < postMessage.messages.length; i++) {
      userEmails.add(postMessage.messages[i].sender);
    }

    for (int i = 0; i < userEmails.length; i++) {
      User user = await _userService.fetchUserByEmail(userEmails.elementAt(i));
      List<Message> messages = new List();

      for (int j = 0; j < postMessage.messages.length; j++) {
        if (postMessage.messages[j].sender == user.email) {
          messages.add(postMessage.messages[j]);
        }
      }
      UserMessage userMessage = new UserMessage(
          post: postMessage.post, user: user, messages: messages);
      userMessages.add(userMessage);
    }

    return userMessages;
  }
}

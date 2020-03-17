import 'package:emarket_app/bloc/message_manager.dart';
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/custom_component/placeholder_item.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/login_source.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post_message.dart';
import 'package:emarket_app/model/post_message_wrapper.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/model/user_message.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/message/chat_page.dart';
import 'package:emarket_app/pages/message/user_message_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

import '../../util/global.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => new _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<PostMessage> _postMessages = new List();
  MessageService _messageService = new MessageService();
  UserService _userService = new UserService();
  final FavoritService _favoritService = new FavoritService();
  MessageManager _messageManager = new MessageManager();

  GlobalKey<RefreshIndicatorState> refreshKey;

  List<Favorit> myFavorits = new List();

  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  FirebaseUser firebaseUser;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            firebaseUser = snapshot.data;
            _loadMyFavorits();
            saveUserToPrefs(firebaseUser);
            // this is your user instance
            /// is because there is user already logged
            return Column(children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      height: SizeConfig.screenHeight / 6,
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 5),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical),
                          child: new Text(
                            AppLocalizations.of(context).translate('my') +
                                ' ' +
                                AppLocalizations.of(context)
                                    .translate('messages'),
                            style: GlobalStyling.styleTitleWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8),
                    child: new Container(
                      constraints: BoxConstraints.expand(
                          height: SizeConfig.screenHeight * 0.77),
                      child: buildMyMessageListView(),
                    ),
                  ),
                ],
              )
            ]);
          }
          // other way there is no user logged.
          return new Login(LoginSource.messagePage, null);
        });
  }

  Widget buildMyMessageListView() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await _invalidateMessageCache();
      },
      child: StreamBuilder<PostMessageWrapper>(
        stream: _messageManager.myPostMessageWrapper,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _postMessages = snapshot.data.postMessageList;
            if (snapshot.data.postMessageList.length > 0) {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    return Slidable(
                      actionPane: SlidableBehindActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        child: Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: GlobalColor.colorGrey200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              onTap: () => openUserMessage(
                                  _postMessages.elementAt(index),
                                  _postMessages.elementAt(index).post.title),
                              leading: CircleAvatar(
                                backgroundColor: GlobalColor.colorDeepPurple300,
                                child: Text((index + 1).toString()),
                                foregroundColor: GlobalColor.colorWhite,
                              ),
                              title: Text(
                                  _postMessages.elementAt(index).post.title),
                              subtitle: buildSubtitle(index, context),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: GlobalColor.colorDeepPurple300,
                                  size: SizeConfig.blockSizeHorizontal * 5),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _postMessages.length);
            } else {
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
          } else if (snapshot.hasError) {
            MyNotification.showInfoFlushbar(
                context,
                AppLocalizations.of(context).translate('error'),
                AppLocalizations.of(context).translate('error_loading'),
                Icon(
                  Icons.info_outline,
                  size: 28,
                  color: Colors.redAccent,
                ),
                Colors.redAccent,
                4);
          }
          return ListView.builder(
            itemCount: 10,
            // Important code
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey[400],
              highlightColor: Colors.white,
              child: ListItem(
                page: MESSAGEPAGE,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSubtitle(int index, BuildContext context) {
    if (firebaseUser != null) {
      int newMessage = _messageService.countNewMessage(
          _postMessages.elementAt(index).messages, firebaseUser.email);

      return newMessage > 1
          ? Text(
              newMessage.toString() +
                  ' ' +
                  AppLocalizations.of(context).translate('new_plural') +
                  " " +
                  AppLocalizations.of(context)
                      .translate('messages')
                      .toLowerCase(),
              style: GlobalStyling.styleSubtitleBlueAccent,
            )
          : newMessage == 1
              ? Text(
                  newMessage.toString() +
                      ' ' +
                      AppLocalizations.of(context).translate('new') +
                      " " +
                      AppLocalizations.of(context)
                          .translate('message')
                          .toLowerCase(),
                  style: GlobalStyling.styleSubtitleBlueAccent,
                )
              : null;
    }
  }

  void openUserMessage(PostMessage postMessage, String userName) async {
    //Aktueller User ist Bezitzer des Post, dann kann er alle Nachrichten zu dieser Post sehen
    if (firebaseUser != null &&
        firebaseUser.email == postMessage.post.useremail) {
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
        if (firebaseUser != null &&
            (message.sender == firebaseUser.email ||
                message.receiver == firebaseUser.email)) {
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
              myFavorits: myFavorits,
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

  Future<void> saveUserToPrefs(FirebaseUser firebaseUser) async {
    await _sharedPreferenceService.save(USER_EMAIL, firebaseUser.email);
    await _sharedPreferenceService.save(USER_NAME, firebaseUser.displayName);
  }

  Future<void> _loadMyFavorits() async {
    if (firebaseUser != null &&
        firebaseUser.email != null &&
        firebaseUser.email.isNotEmpty) {
      myFavorits =
          await _favoritService.fetchFavoritByUserEmail(firebaseUser.email);
    }
  }

  Future<void> _invalidateMessageCache() async {
    await _sharedPreferenceService
        .remove(MESSAGE_LIST_CACHE_TIME + firebaseUser.email);

    setState(() {});
  }
}

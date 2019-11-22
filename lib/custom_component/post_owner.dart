import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/message/chat_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';

class PostOwner extends StatefulWidget {

  PostOwner(
      {@required this.showAllUserPost,
      @required this.fillColor,
      @required this.splashColor,
      @required this.textStyle,
      @required this.post,
      this.user, @required this.postCount});

  final GestureTapCallback showAllUserPost;
  final Color fillColor;
  final Color splashColor;
  final TextStyle textStyle;
  final Post post;
  final User user;
  final int postCount;

  @override
  PostOwnerState createState() => PostOwnerState();
}

class PostOwnerState extends State<PostOwner> {
  final UserService _userService = new UserService();
  final MessageService _messageService = new MessageService();
  bool isLogedIn = false; //TODO save login as sharedPreferencies
  User _postOwner = new User();
  List<Message> messagesSentOrReceived = new List<Message>();
  String _userEmail;
  String _userName;

  @override
  void initState() {
    super.initState();
    _getUserByEmail();
    _getMessageByPostIdAndUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            isLogedIn = true;
            FirebaseUser user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return new Container(
              child: buildUserInformation(context),
            );
          }

          /// other way there is no user logged.
          return new Container(
            child: buildUserInformation(context),
          );
        });
  }

  Padding buildUserInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 10),
                child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        color: colorDeepPurple400,
                        child: Center(
                          child: Text(
                            _postOwner != null && _postOwner.name != null
                                ? _postOwner.name[0].toUpperCase()
                                : 'e',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                              _postOwner != null && _postOwner.name != null
                                  ? _postOwner.name
                                  : 'eMarket',
                              style: SizeConfig.styleTitleBlack),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text('Utilisateur privé', style: SizeConfig.styleGreyDetail,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.sentiment_satisfied),
                          Text('Satisfaction: TOP', style: SizeConfig.styleGreyDetail,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Container(
                            color: colorDeepPurple400,
                            height: 20,
                            width: 20,
                            child: Center(
                              child: Text(
                                widget.postCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          tooltip: 'Autres annonces',
                          onPressed: widget.showAllUserPost,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: buildContactInformation(context),
          ),
        ],
      ),
    );
  }

  Row buildContactInformation(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomButton(
            fillColor: colorDeepPurple400,
            icon: Icons.sms,
            splashColor: Colors.white,
            iconColor: Colors.white,
            text: 'Fais moi un SMS',
            textStyle:
                TextStyle(color: Colors.white, fontSize: SizeConfig.BUTTON_FONT_SIZE),
            onPressed: () => _sendSMS(context),
          ),
        ),
        SizedBox(
          width: 4.0,
        ),
        widget.post.phoneNumber != null
            ? Expanded(
                child: CustomButton(
                  fillColor: colorDeepPurple400,
                  icon: Icons.phone_iphone,
                  splashColor: Colors.white,
                  iconColor: Colors.white,
                  text: isLogedIn ? widget.post.phoneNumber : 'Appele moi',
                  textStyle: TextStyle(
                      color: Colors.white, fontSize: SizeConfig.BUTTON_FONT_SIZE),
                  onPressed: () => _callSaler(context),
                ),
              )
            : Container(),
        SizedBox(
          width: 10.0,
        ),
        Icon(
          Icons.share,
          color: colorDeepPurple300,
        ),
      ],
    );
  }

  _callSaler(BuildContext context) {
    if (isLogedIn) {
      launch("tel:" + widget.post.phoneNumber);
      print("Calling the saler......");
    } else {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => new Login(LoginSource.ownerPage,
              widget.post), //new ProfileScreen(detailsUser: details),
        ),
      );
    }
  }

  _sendSMS(BuildContext context) {
    if (isLogedIn) {
      if (_userEmail != widget.post.useremail) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ChatPage(messages: messagesSentOrReceived, post: widget.post);
            },
          ),
        );
      } else {
        MyNotification.showInfoFlushbar(
            context,
            "Info",
            "Cette annonce vous appartient. Vous ne pouvez pas vous envoyer des messsages à vous même!",
            Icon(
              Icons.info_outline,
              size: 28,
              color: Colors.blue.shade300,
            ),
            Colors.blue.shade300,
            8);

      }
    } else {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => new Login(LoginSource.ownerPage,
              widget.post), //new ProfileScreen(detailsUser: details),
        ),
      );
    }
  }

  Future<void> _getUserByEmail() async {
    _postOwner = await _userService.fetchUserByEmail(widget.post.useremail);
    setState(() {});
  }

  Future<void> _getMessageByPostIdAndUserEmail() async {
    await setUserDaten();

    //der eingelogte User ist nicht der Besitzer der Post, dann kann er eine Nachricht an den Bezitzer der Post senden
    if (_userEmail != widget.post.useremail) {
      List<Message> messages =
          await _messageService.fetchMessageByPostId(widget.post.id);

      for (Message message in messages) {
        if (message.sender == _userEmail || message.receiver == _userEmail) {
          messagesSentOrReceived.add(message);
        }
      }

      messagesSentOrReceived.sort((message1, message2) =>
          message1.created_at.isAfter(message2.created_at) ? 0 : 1);
      setState(() {});
    }
  }

  void setUserDaten() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString(USER_EMAIL);
    _userName = prefs.getString(USER_NAME);

    setState(() {});
  }

}

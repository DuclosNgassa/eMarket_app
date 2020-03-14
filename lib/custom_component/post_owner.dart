import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/global/global_url.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/login_source.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/pages/message/chat_page.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';

class PostOwner extends StatefulWidget {
  PostOwner(
      {@required this.showAllUserPost,
      @required this.fillColor,
      @required this.splashColor,
      @required this.textStyle,
      @required this.post,
      @required this.user,
      @required this.postCount});

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
  final MessageService _messageService = new MessageService();
  final SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  bool isLogedIn = false; //TODO save login as sharedPreferencies
  List<Message> messagesSentOrReceived = new List<Message>();
  String _userEmail;

  @override
  void initState() {
    super.initState();
    _getMessageByPostIdAndUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            isLogedIn = true;
            //FirebaseUser user = snapshot.data; // this is your user instance
            // is because there is user already logged
            return new Container(
              child: buildUserInformation(context),
            );
          }
          // other way there is no user logged.
          return new Container(
            child: buildUserInformation(context),
          );
        });
  }

  Padding buildUserInformation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 1.5,
                    right: SizeConfig.blockSizeHorizontal * 2),
                child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal * 10,
                        color: GlobalColor.colorDeepPurple400,
                        child: Center(
                          child: Text(
                            widget.user != null && widget.user.name != null
                                ? widget.user.name[0].toUpperCase()
                                : 'e',
                            style: GlobalStyling.styleTitleWhite,
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
                      padding:
                          EdgeInsets.only(bottom: SizeConfig.blockSizeVertical),
                      child: Row(
                        children: <Widget>[
                          Text(
                              widget.user != null && widget.user.name != null
                                  ? widget.user.name
                                  : 'eMarket',
                              style: GlobalStyling.styleTitleBlack),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.blockSizeVertical),
                      child: Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)
                                .translate('privat_user'),
                            style: GlobalStyling.styleGreyDetail,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.blockSizeVertical),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _buildRating(widget.post.rating),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: widget.showAllUserPost,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: Container(
                              color: GlobalColor.colorDeepPurple400,
                              height: SizeConfig.blockSizeVertical * 3,
                              width: SizeConfig.blockSizeHorizontal * 5,
                              child: Center(
                                child: Text(
                                  widget.postCount.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Icon(Icons.arrow_forward_ios),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
            child: buildContactInformation(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRating(int rating) {
    List<Widget> widgetList = new List();
    Widget icon =
        Icon(Icons.sentiment_satisfied, color: GlobalColor.colorGrey400);

    Widget satisfaction = Expanded(
      child: Text(
        "Satisfaction: TOP",
        style: GlobalStyling.styleGreyDetail,
      ),
    );

    widgetList.add(icon);
    widgetList.add(satisfaction);

    for (var i = 0; i < MAX_RATING; i++) {
      Icon icon = Icon(
        Icons.star,
        color: i < rating ? GlobalColor.colorBlue : GlobalColor.colorGrey300,
        size: SizeConfig.BUTTON_FONT_SIZE,
      );

      widgetList.add(icon);
    }

    return widgetList;
  }

  Row buildContactInformation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: _sendSMS,
          icon: Icon(
            FontAwesomeIcons.commentDots,
            size: SizeConfig.blockSizeHorizontal * 10,
            color: GlobalColor.colorDeepPurple400,
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 3,
        ),
        widget.post.phoneNumber != null && widget.post.phoneNumber.isNotEmpty
            ? Expanded(
                child: CustomButton(
                  fillColor: GlobalColor.colorDeepPurple400,
                  icon: Icons.phone_iphone,
                  splashColor: Colors.white,
                  iconColor: Colors.white,
                  text: isLogedIn
                      ? widget.post.phoneNumber
                      : AppLocalizations.of(context).translate('call_me'),
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.BUTTON_FONT_SIZE),
                  onPressed: _callSaler,
                ),
              )
            : Container(),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 3,
        ),
        IconButton(
          onPressed: shareToSystem,
          icon: Icon(
            Icons.share,
            size: SizeConfig.blockSizeHorizontal * 10,
            color: GlobalColor.colorDeepPurple400,
          ),
          tooltip: AppLocalizations.of(context).translate('share'),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 3,
        ),
      ],
    );
  }

  Future<void> shareToSystem() async {
    var response = await FlutterShareMe().shareToSystem(
        msg: AppLocalizations.of(context).translate('show_advert') +
            ' *' +
            widget.post.title +
            '* . ' +
            AppLocalizations.of(context).translate('interested') +
            '. \n' +
            APP_URL);
    if (response == 'success') {
      print('navigate success');
    }
  }

  _callSaler() {
    if (isLogedIn) {
      launch("tel:" + widget.post.phoneNumber);
    } else {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => new Login(LoginSource.ownerPage, widget.post),
        ),
      );
    }
  }

  _sendSMS() {
    if (isLogedIn) {
      if (_userEmail != widget.post.useremail) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ChatPage(
                  messages: messagesSentOrReceived, post: widget.post);
            },
          ),
        );
      } else {
        MyNotification.showInfoFlushbar(
            context,
            AppLocalizations.of(context).translate('info'),
            AppLocalizations.of(context).translate('cannot_send_self_message'),
            Icon(
              Icons.info_outline,
              size: 28,
              color: Colors.blue.shade300,
            ),
            Colors.blue.shade300,
            2);
      }
    } else {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => new Login(LoginSource.ownerPage, widget.post),
        ),
      );
    }
  }

  Future<void> _getMessageByPostIdAndUserEmail() async {
    await setUserDaten();

    //der eingelogte User ist nicht der Besitzer der Post, dann kann er eine Nachricht an den Bezitzer der Post senden
    if (_isUserLoggedIn() && _userEmail != widget.post.useremail) {
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
    _userEmail = await _sharedPreferenceService.read(USER_EMAIL);

    setState(() {});
  }

  bool _isUserLoggedIn() {
    return _userEmail != null;
  }
}

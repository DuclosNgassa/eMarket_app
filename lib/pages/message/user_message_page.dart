import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/status.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user_message.dart';
import 'package:emarket_app/pages/message/chat_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserMessagePage extends StatefulWidget {
  final List<UserMessage> userMessage;
  final Post post;

  UserMessagePage(this.userMessage, this.post);

  @override
  _UserMessagePageState createState() => _UserMessagePageState();
}

class _UserMessagePageState extends State<UserMessagePage> {
  final MessageService _messageService = new MessageService();
  final SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  final FavoritService _favoritService = new FavoritService();
  List<Favorit> myFavorits = new List();

  String loggedUseremail;
  List<UserMessage> userMessageWithoutLoggedUser = new List();
  List<Message> allSentMessages = new List();

  @override
  void initState() {
    super.initState();
    getUserEmailFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Container(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: SizeConfig.screenHeight / 4,
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
                Container(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 5,
                    top: SizeConfig.blockSizeVertical * 5,
                  ),
                  constraints: BoxConstraints.expand(
                      height: SizeConfig.screenHeight / 6),
                  child: _buildTitle(),
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.125),
                  constraints: BoxConstraints.expand(
                      height: SizeConfig.safeBlockVertical * 85),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2),
                            constraints: BoxConstraints.expand(
                                height: SizeConfig.screenHeight * 0.845),
                            child: buildMyMessageListView(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTitle() {
    return Container(
      child: new RawMaterialButton(
        onPressed: () => _showPostDetailPage(widget.post),
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    AppLocalizations.of(context).translate('my') +
                        ' ' +
                        AppLocalizations.of(context).translate('messages'),
                    style: GlobalStyling.styleTitleWhite,
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
                    child: Text(
                      AppLocalizations.of(context).translate('advert') +
                          ' ' +
                          widget.userMessage.elementAt(0).post.title,
                      style: GlobalStyling.styleSubtitleWhite,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: GlobalColor.colorWhite,
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

  _showPostDetailPage(Post post) {
    if (post.status == Status.active) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PostDetailPage(post, myFavorits);
          },
        ),
      );
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('no_longer_available'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
      setState(() {});
    }
  }

  Widget buildMyMessageListView() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              child: Card(
                elevation: 8.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: GlobalColor.colorGrey200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () =>
                        openChat(userMessageWithoutLoggedUser.elementAt(index)),
                    leading: CircleAvatar(
                      backgroundColor: GlobalColor.colorDeepPurple300,
                      child: Text((index + 1).toString()),
                      foregroundColor: GlobalColor.colorWhite,
                    ),
                    title: Text(userMessageWithoutLoggedUser
                        .elementAt(index)
                        .user
                        .name),
                    subtitle: buildSubtitle(index, context),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: GlobalColor.colorDeepPurple300,
                      size: SizeConfig.blockSizeHorizontal * 5,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: AppLocalizations.of(context).translate('open'),
                color: GlobalColor.colorDeepPurple300,
                icon: Icons.visibility,
                onTap: () =>
                    openChat(userMessageWithoutLoggedUser.elementAt(index)),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: AppLocalizations.of(context).translate('delete'),
                color: GlobalColor.colorRed,
                icon: Icons.delete,
                onTap: null,
              ),
            ],
          );
        },
        itemCount: userMessageWithoutLoggedUser.length);
  }

  Widget buildSubtitle(int index, BuildContext context) {
    int newMessage = _messageService.countNewMessage(
        userMessageWithoutLoggedUser.elementAt(index).messages,
        widget.post.useremail);

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

  bool isLoggedUser(int index) =>
      widget.userMessage.elementAt(index).user.email == loggedUseremail;

  Future<void> getUserEmailFromPrefs() async {
    loggedUseremail = await _sharedPreferenceService.read(USER_EMAIL);
    await _loadMyFavorits();

    for (int i = 0; i < widget.userMessage.length; i++) {
      if (!isLoggedUser(i)) {
        userMessageWithoutLoggedUser.add(widget.userMessage.elementAt(i));
      } else {
        allSentMessages = widget.userMessage.elementAt(i).messages;
      }
    }
    setState(() {});
  }

  void openChat(UserMessage userMessage) async {
    List<Message> allMessages = new List();
    List<Message> receivedMessages = userMessage.messages;
    List<Message> sentMessages = new List();

    for (int i = 0; i < allSentMessages.length; i++) {
      if (allSentMessages.elementAt(i).receiver ==
          receivedMessages.elementAt(0).sender) {
        sentMessages.add(allSentMessages.elementAt(i));
      }
    }

    allMessages.addAll(receivedMessages);
    allMessages.addAll(sentMessages);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(
            messages: allMessages,
            post: userMessage.post,
            myFavorits: myFavorits,
          );
        },
      ),
    );
  }

  Future<void> _loadMyFavorits() async {
    if (loggedUseremail != null && loggedUseremail.isNotEmpty) {
      myFavorits =
          await _favoritService.fetchFavoritByUserEmail(loggedUseremail);
    }
  }
}

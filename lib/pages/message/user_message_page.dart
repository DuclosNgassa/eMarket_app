import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user_message.dart';
import 'package:emarket_app/pages/message/chat_page.dart';
import 'package:emarket_app/pages/post/post_detail_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMessagePage extends StatefulWidget {
  final List<UserMessage> userMessage;
  final Post post;

  UserMessagePage(this.userMessage, this.post);

  @override
  _UserMessagePageState createState() => _UserMessagePageState();
}

class _UserMessagePageState extends State<UserMessagePage> {
  MessageService _messageService = new MessageService();

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
                          colors: [colorDeepPurple400, colorDeepPurple300],
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
                    child: Text(
                      AppLocalizations.of(context).translate('advert') +
                          ' ' +
                          widget.userMessage.elementAt(0).post.title,
                      style: SizeConfig.styleSubtitleWhite,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: colorWhite,
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(widget.post);
        },
      ),
    );
  }

  Widget buildMyMessageListView() {
    return ListView.separated(
        itemBuilder: (context, index) => Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: colorTransparent,
                child: ListTile(
                  onTap: () =>
                      openChat(userMessageWithoutLoggedUser.elementAt(index)),
                  leading: CircleAvatar(
                    backgroundColor: colorDeepPurple300,
                    child: Text((index + 1).toString()),
                    foregroundColor: colorWhite,
                  ),
                  title: Text(
                      userMessageWithoutLoggedUser.elementAt(index).user.name),
                  subtitle: buildSubtitle(index, context),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: AppLocalizations.of(context).translate('open'),
                  color: colorDeepPurple300,
                  icon: Icons.visibility,
                  onTap: () =>
                      openChat(userMessageWithoutLoggedUser.elementAt(index)),
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: AppLocalizations.of(context).translate('delete'),
                  color: colorRed,
                  icon: Icons.delete,
                  onTap: null,
                ),
              ],
            ),
        separatorBuilder: (context, index) => Divider(),
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
            style: SizeConfig.styleSubtitleBlueAccent,
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
                style: SizeConfig.styleSubtitleBlueAccent,
              )
            : null;
  }

  bool isLoggedUser(int index) =>
      widget.userMessage.elementAt(index).user.email == loggedUseremail;

  Future<void> getUserEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedUseremail = prefs.getString(USER_EMAIL);

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
          );
        },
      ),
    );
  }
}

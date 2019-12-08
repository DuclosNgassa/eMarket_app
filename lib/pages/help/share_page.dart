import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/global.dart';

class SharePage extends StatefulWidget {
  @override
  _SharePageState createState() => new _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  String userEmail;
  String userName;

  final TextEditingController _textController = new TextEditingController();
  UserService _userService = new UserService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: colorDeepPurple300,
        title: _buildTitle(),
        automaticallyImplyLeading: false,
      ),
      body: buildListTile(),
    );
  }

  _buildTitle() {
    return Text(AppLocalizations.of(context).translate('share'));
  }

  Widget buildListTile() {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: SizeConfig.screenHeight * 0.54,
            child: Image.asset(
              "images/sharesocial.gif",
            ),
          ),
          ListTile(
            onTap: () => shareToWhatsapp(),
            leading: Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.green,
            ),
            title: Text("Whatsapp"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey400,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => shareToFacebook(),
            leading: Icon(
              FontAwesomeIcons.facebook,
              color: colorBlue,
            ),
            title: Text("Facebook"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey400,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => shareToSystem(),
            leading: Icon(
              Icons.share,
              color: Colors.purple,
            ),
            title: Text(AppLocalizations.of(context).translate('others')),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey400,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> shareToWhatsapp() {
    FlutterShareMe().shareToWhatsApp(
        base64ImageUrl: "http://www.whatsapp.de", msg: "shareToWhatsapp");
  }

  Future<void> shareToFacebook() {
    FlutterShareMe().shareToFacebook(
        url: 'https://github.com/lizhuoyuan', msg: "shareToFacebook");
  }

  Future<void> shareToSystem() async {
    var response = await FlutterShareMe().shareToSystem(msg: "shareToSystem");
    if (response == 'success') {
      print('navigate success');
    }
  }

  Future<void> shareToTwitter() async {
    var response = await FlutterShareMe().shareToTwitter(
        url: 'https://github.com/lizhuoyuan', msg: "shareToTwitter");
    if (response == 'success') {
      print('navigate success');
    }
  }
}

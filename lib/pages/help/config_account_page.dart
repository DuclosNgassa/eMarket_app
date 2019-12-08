import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

import '../../services/global.dart';

class ConfigAccountPage extends StatefulWidget {

  @override
  _ConfigAccountPageState createState() => new _ConfigAccountPageState();
}

class _ConfigAccountPageState extends State<ConfigAccountPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  String userEmail;
  String userName;
  User receiver;

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
      body: new Column(
        //modified
        children: <Widget>[
          new Container(
            child: Text("Header-ConfigAccountPage"),
          ),
          new Divider(height: SizeConfig.blockSizeVertical),
          new Container(
            child: Text("Body-ConfigAccountPage"), //modified
          ),
          new Container(
            child: Text("Footer-ConfigAccountPage"), //modified
          ),
        ],
      ),
    );
  }

  Future<void> _getUserByEmail(String email) async {
    receiver = await _userService.fetchUserByEmail(email);
    setState(() {});
  }

  _buildTitle() {
    return Text(AppLocalizations.of(context).translate('title'));
  }
}

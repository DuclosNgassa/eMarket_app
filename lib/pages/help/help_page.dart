import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/pages/contact/contact_page.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

import '../../services/global.dart';
import 'faq_page.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => new _HelpPageState();
}

class _HelpPageState extends State<HelpPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  String userEmail;
  String userName;

  final TextEditingController _textController = new TextEditingController();

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
    return Text(AppLocalizations.of(context).translate('how_it_works'));
  }

  Widget buildListTile() {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: SizeConfig.screenHeight * 0.6,
            child: Image.asset(
              "gif/help.gif",
            ),
          ),
          ListTile(
            onTap: () => showFaqPage(),
            leading: Icon(
              Icons.help_outline,
              color: colorDeepPurple300,
            ),
            title: Text(AppLocalizations.of(context).translate('how_it_works')),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => showContactPage(),
            leading: Icon(
              Icons.message,
              color: colorBlue,
            ),
            title: Text(AppLocalizations.of(context).translate('contact_us')),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
        ],
      ),
    );
  }

  showFaqPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FaqPage();
        },
      ),
    );
  }

  showContactPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ContactPage();
        },
      ),
    );
  }

}

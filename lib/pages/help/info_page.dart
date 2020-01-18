import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/pages/help/privacy_policy_page.dart';
import 'package:emarket_app/pages/help/share_page.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/global.dart';
import 'about_us_page.dart';
import 'help_page.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => new _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser firebaseUser = null;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                child: new Text(
                  AppLocalizations.of(context).translate('infos'),
                  style: SizeConfig.styleTitleWhite,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 8),
          child: new Container(
            constraints:
                BoxConstraints.expand(height: SizeConfig.screenHeight * 0.70),
            child: buildListTile(),
          ),
        ),
      ],
    );
  }

  Widget buildListTile() {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: SizeConfig.screenHeight * 0.25,
            child: Image.asset(
              "gif/info.gif",
            ),
          ),
          ListTile(
            onTap: () => showHelpPage(),
            leading: Icon(
              Icons.help,
              color: colorBlue,
            ),
            title: Text(AppLocalizations.of(context).translate('how_it_works')),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          Divider(
            height: SizeConfig.blockSizeVertical,
          ),
          ListTile(
            onTap: () => showSharePage(),
            leading: Icon(
              Icons.favorite,
              color: colorRed,
            ),
            title:
                Text(AppLocalizations.of(context).translate('inform_friends')),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          Divider(
            height: SizeConfig.blockSizeVertical,
          ),
          ListTile(
            onTap: () => showAboutUsPage(),
            leading: Icon(
              Icons.sentiment_satisfied,
              color: colorDeepPurple300,
            ),
            title: Text(AppLocalizations.of(context).translate('who_are_we')),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => showPrivacyPolicyPage(),
            leading: Icon(
              Icons.account_balance,
              color: colorDeepPurple300,
            ),
            title:
                Text(AppLocalizations.of(context).translate('privacy_policy')),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  // This is the builder method that creates a new page
  showHelpPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HelpPage();
        },
      ),
    );
  }

  // This is the builder method that creates a new page
  showSharePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SharePage();
        },
      ),
    );
  }

  showAboutUsPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AboutUsPage();
        },
      ),
    );
  }

  showPrivacyPolicyPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PrivacyPolicyPage();
        },
      ),
    );
  }
}

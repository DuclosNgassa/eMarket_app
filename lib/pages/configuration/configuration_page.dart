import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/pages/configuration/share_page.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/global.dart';
import 'config_account_page.dart';
import 'help_page.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => new _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser firebaseUser = null;

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
                          "Configuration",
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
                    child: buildListTile(),
                  ),
                ),
              ],
            );
          }
          // other way there is no user logged.
          return new Login(LoginSource.configurationPage, null);
        });
  }

  Widget buildListTile() {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () => showConfigAccountPage(),
            leading: Icon(
              Icons.vpn_key,
              color: colorDeepPurple300,
            ),
            title: Text("Mon compte"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 7,
          ),
          Divider(),
          ListTile(
            onTap: () => showHelpPage(),
            leading: Icon(
              Icons.help,
              color: colorBlue,
            ),
            title: Text("Aide"),
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
            title: Text("Informer les amis"),
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
  showConfigAccountPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ConfigAccountPage();
        },
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

}

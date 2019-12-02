import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

import '../../services/global.dart';

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
    return Text("Aide");
  }

  Widget buildListTile() {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: SizeConfig.screenHeight * 0.5,
            child: Image.asset(
              "images/help.gif",
            ),
          ),
/*
          Container(
            height: SizeConfig.screenHeight * 0.5,
            child: Icon(
              Icons.info_outline,
              color: colorDeepPurple300,
              size: SizeConfig.safeBlockHorizontal * 60,
            ),
          ),
*/
          ListTile(
            //onTap: () => showConfigAccountPage(),
            leading: Icon(
              Icons.help_outline,
              color: colorDeepPurple300,
            ),
            title: Text("Comment ça marche"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          Divider(),
          ListTile(
            //onTap: () => showHelpPage(),
            leading: Icon(
              Icons.message,
              color: colorBlue,
            ),
            title: Text("Nous contacter"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorGrey300,
            ),
          ),
          Divider(
            height: SizeConfig.blockSizeVertical,
          ),
        ],
      ),
    );
  }

// This is the builder method that creates a new page
/*
  showConfigAccountPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ConfigAccountPage();
        },
      ),
    );
  }
*/

// This is the builder method that creates a new page
/*
  showHelpPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HelpPage();
        },
      ),
    );
  }
*/

// This is the builder method that creates a new page
/*
  showSharePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SharePage();
        },
      ),
    );
  }
*/
}

import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/global.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

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
    return Text(AppLocalizations.of(context).translate('about_us'));
  }

  Widget buildListTile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: SizeConfig.screenHeight * 0.54,
            child: Image.asset(
              "images/softdesign.png",
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Center(
            child: Text(
              AppLocalizations.of(context).translate('about_us_text'),
              style: SizeConfig.styleNormalBlack,
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Container(
            child: RaisedButton(
              shape: const StadiumBorder(),
              color: colorDeepPurple400,
              child: Text(
                AppLocalizations.of(context).translate('visit_us'),
                style: SizeConfig.styleSubtitleWhite,
              ),
              onPressed: () => launch(SITE_WEB),
            ),
          ),
        ],
      ),
    );
  }
}

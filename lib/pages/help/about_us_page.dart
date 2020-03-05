import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/global/global_url.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: GlobalColor.colorDeepPurple300,
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
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: SizeConfig.screenHeight * 0.54,
            child: Image.asset(
              "assets/images/kmerconsulting.png",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
            child: Text(
              AppLocalizations.of(context).translate('about_us_text'),
              style: GlobalStyling.styleNormalBlack,
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Container(
            child: RaisedButton(
              shape: const StadiumBorder(),
              color: GlobalColor.colorDeepPurple400,
              child: Text(
                AppLocalizations.of(context).translate('visit_us'),
                style: GlobalStyling.styleSubtitleWhite,
              ),
              onPressed: () => launch(SITE_WEB),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/pages/contact/contact_page.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => new _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('how_it_works')),
        backgroundColor: GlobalColor.colorDeepPurple400,
      ),
      body: buildListTile(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildListTile() {
    return Column(
      children: <Widget>[
        Expanded(
          child: buildListFaq(),
        ),
        Divider(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Container(
          width: SizeConfig.screenWidth * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomButton(
              fillColor: GlobalColor.colorDeepPurple400,
              splashColor: Colors.white,
              iconColor: Colors.white,
              text: AppLocalizations.of(context).translate('other_questions') +
                  ' ' +
                  AppLocalizations.of(context).translate('contact_us'),
              textStyle: GlobalStyling.styleButtonWhite,
              onPressed: () => showContactPage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListFaq() {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq1'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp1'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq2'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp2'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq3'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp3'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq4'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp4'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq5'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp5'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq6'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp6'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
      ],
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

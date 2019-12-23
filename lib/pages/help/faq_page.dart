import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/contact/contact_page.dart';
import 'package:emarket_app/services/categorie_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

import '../../services/global.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => new _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  CategorieService _categorieService = new CategorieService();
  List<Categorie> categories = new List();
  List<CategorieTile> categoriesTiles = new List();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('how_it_works')),
        backgroundColor: colorDeepPurple400,
      ),
      body: buildListTile(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategorie();
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
              fillColor: colorDeepPurple400,
              splashColor: Colors.white,
              iconColor: Colors.white,
              text: AppLocalizations.of(context).translate('other_questions') + ' ' + AppLocalizations.of(context).translate('contact_us'),
              textStyle: SizeConfig.styleButtonWhite,
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
            style: SizeConfig.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context).translate('resp1'),
                style: SizeConfig.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq2'),
            style: SizeConfig.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp2'),
                style: SizeConfig.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq3'),
            style: SizeConfig.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp3'),
                style: SizeConfig.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq4'),
            style: SizeConfig.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp4'),
                style: SizeConfig.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq5'),
            style: SizeConfig.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp5'),
                style: SizeConfig.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq6'),
            style: SizeConfig.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('resp6'),
                style: SizeConfig.styleNormalBlack,
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

  Future<void> _loadCategorie() async {
    categories = await _categorieService.fetchCategories();
    categoriesTiles =
        await _categorieService.mapCategorieToCategorieTile(categories);
    setState(() {});
  }
}

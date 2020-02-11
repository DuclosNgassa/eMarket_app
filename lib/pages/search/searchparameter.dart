import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

import '../../form/searchparameter_form.dart';

class SearchParameterPage extends StatefulWidget {

  @override
  _SearchParameterPageState createState() => new _SearchParameterPageState();
}

class _SearchParameterPageState extends State<SearchParameterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    String allTranslated = AppLocalizations.of(context).translate('all');
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('search')),
        backgroundColor: colorDeepPurple300,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [SearchParameterForm(context, allTranslated)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

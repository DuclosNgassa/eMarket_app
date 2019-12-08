import 'package:emarket_app/form/contact_form.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => new _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('contact_us')),
        backgroundColor: colorDeepPurple300,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 5),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [ContactForm(context)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

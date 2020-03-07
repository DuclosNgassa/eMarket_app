import 'dart:async';

import 'package:emarket_app/custom_component/custom_linear_gradient.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/pages/navigation/navigation_page.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((status) {
      _navigateToHome();
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});

    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => NavigationPage(HOMEPAGE)));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomLinearGradient(
              myChild: new Container(),
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 40,
                  height: SizeConfig.blockSizeHorizontal * 40,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0)
                  ]),
                  child: AspectRatio(
                    aspectRatio: 0.5,
                    child: Image.asset(
                      "assets/icons/emarket-512.png",
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.5,
              child: Shimmer.fromColors(
                period: Duration(milliseconds: 2000),
                baseColor: Colors.white,
                highlightColor: Colors.deepPurple,
                child: Container(
                  padding: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 6),
                  child: Text(
                      AppLocalizations.of(context)
                          .translate('the_market_of_good_and_service'),
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 7,
                        fontFamily: 'Pacifico',
                        shadows: <Shadow>[
                          Shadow(
                              blurRadius: 18.0,
                              color: Colors.black87,
                              offset: Offset.fromDirection(120, 12))
                        ]),
                  ),
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.58,
              child: Shimmer.fromColors(
                period: Duration(milliseconds: 2000),
                baseColor: Colors.white,
                highlightColor: Colors.deepPurple,
                child: Container(
                  padding: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 6),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('on_your_phone'),
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 7,
                        fontFamily: 'Pacifico',
                        shadows: <Shadow>[
                          Shadow(
                              blurRadius: 18.0,
                              color: Colors.black87,
                              offset: Offset.fromDirection(120, 12))
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:emarket_app/custom_component/custom_linear_gradient.dart';
import 'package:emarket_app/global/global_styling.dart';
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
    await Future.delayed(Duration(milliseconds: 2500), () {});

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
            Shimmer.fromColors(
              period: Duration(milliseconds: 1500),
              baseColor: Colors.white,
              highlightColor: Colors.deepPurple,
              child: Container(
                padding:
                    EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 6),
                child: Text(
                  "eMarket",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 15,
                      fontFamily: 'Pacifico',
                      shadows: <Shadow>[
                        Shadow(
                            blurRadius: 18.0,
                            color: Colors.black87,
                            offset: Offset.fromDirection(120, 12))
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

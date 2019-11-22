import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static double BUTTON_FONT_SIZE;

  static TextStyle styleTitleBlack;
  static TextStyle styleCity;
  static TextStyle stylePrice;
  static TextStyle styleTitleWhite;
  static TextStyle styleNormalWhite;
  static TextStyle styleButtonWhite;
  static TextStyle styleForm;
  static TextStyle styleRadioButton;
  static TextStyle styleNormalBlack;
  static TextStyle styleGreyDetail;
  static TextStyle styleSubtitleWhite;
  static TextStyle styleSubtitleBlack;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    BUTTON_FONT_SIZE = blockSizeHorizontal * 3;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    styleTitleBlack = new TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: SizeConfig.safeBlockHorizontal * 4);

    styleCity = new TextStyle(
        color: Colors.black45, fontSize: SizeConfig.safeBlockHorizontal * 3);

    stylePrice = new TextStyle(
        color: colorDeepPurple500,
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.safeBlockHorizontal * 4);

    styleTitleWhite = new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.safeBlockHorizontal * 5);

    styleNormalWhite = new TextStyle(
      color: Colors.white,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleButtonWhite = new TextStyle(
      color: Colors.white,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleForm = new TextStyle(
      color: Colors.black54,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleRadioButton = new TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleNormalBlack = new TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleGreyDetail = new TextStyle(
      color: Colors.black45,
      fontSize: SizeConfig.safeBlockHorizontal * 3,
    );

    styleSubtitleWhite = new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleSubtitleBlack = new TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );
  }
}

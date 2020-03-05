import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'global_color.dart';

class GlobalStyling {
  static double BUTTON_FONT_SIZE;

  static TextStyle styleTitleBlack;
  static TextStyle styleTitleBlackCard;
  static TextStyle styleCity;
  static TextStyle stylePrice;
  static TextStyle stylePriceCard;
  static TextStyle styleTitleWhite;
  static TextStyle styleNormalWhite;
  static TextStyle styleNormalBlack;
  static TextStyle styleNormalBlackBold;
  static TextStyle styleNormalBlackCard;
  static TextStyle styleNormalBlack3;
  static TextStyle styleButtonWhite;
  static TextStyle styleFormGrey;
  static TextStyle baseTextStyle;
  static TextStyle headerTextStyle;
  static TextStyle regularTextStyle;
  static TextStyle subHeaderTextStyle;

  static const TextStyle styleFormBlack = const TextStyle(
    color: Colors.black,
  );

  static TextStyle styleRadioButton;
  static TextStyle styleGreyDetail;
  static TextStyle styleSubtitleWhite;
  static TextStyle styleSubtitleBlueAccent;
  static TextStyle styleSubtitleBlack;

  void init(BuildContext context) {
    SizeConfig().init(context);

    styleTitleBlack = new TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: SizeConfig.safeBlockHorizontal * 4);

    styleTitleBlackCard = new TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: SizeConfig.safeBlockHorizontal * 3);

    styleCity = new TextStyle(
        color: Colors.black45, fontSize: SizeConfig.safeBlockHorizontal * 3);

    stylePrice = new TextStyle(
        color: GlobalColor.colorDeepPurple500,
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.safeBlockHorizontal * 4);

    stylePriceCard = new TextStyle(
        color: GlobalColor.colorDeepPurple500,
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.safeBlockHorizontal * 3);

    styleTitleWhite = new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.safeBlockHorizontal * 5);

    styleNormalWhite = new TextStyle(
      color: Colors.white,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleNormalBlack = new TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleNormalBlackBold = new TextStyle(
        color: Colors.black,
        fontSize: SizeConfig.safeBlockHorizontal * 4,
        fontWeight: FontWeight.bold);

    styleNormalBlackCard = new TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockHorizontal * 3,
    );

    styleNormalBlack3 = new TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockHorizontal * 3,
    );

    styleButtonWhite = new TextStyle(
      color: Colors.white,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleFormGrey = new TextStyle(
      color: Colors.black54,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
    );

    styleRadioButton = new TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockHorizontal * 3,
    );

    styleGreyDetail = new TextStyle(
      color: Colors.black45,
      fontSize: SizeConfig.safeBlockHorizontal * 4,
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

    styleSubtitleBlueAccent = new TextStyle(
      color: Colors.blueAccent,
      fontStyle: FontStyle.italic,
      fontSize: SizeConfig.safeBlockHorizontal * 3,
    );

    baseTextStyle = TextStyle(fontFamily: 'Poppins');

    headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600);

    regularTextStyle = baseTextStyle.copyWith(
        color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w400);

    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 16.0);
  }
}

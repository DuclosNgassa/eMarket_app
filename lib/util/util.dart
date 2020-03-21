import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/icon_data.dart';

import 'global.dart';

class Util {
  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static Future<bool> readShowPictures(
      SharedPreferenceService _sharedPreferenceService) async {
    String showPictureString =
        await _sharedPreferenceService.read(SHOW_PICTURES);
    if (showPictureString == SHOW_PICTURES_NO) {
      return false;
    }
    return true;
  }

  static saveShowPictures(bool showPictures,
      SharedPreferenceService _sharedPreferenceService) async {
    if (showPictures) {
      await _sharedPreferenceService.save(SHOW_PICTURES, SHOW_PICTURES_YES);
    } else {
      await _sharedPreferenceService.save(SHOW_PICTURES, SHOW_PICTURES_NO);
    }
  }

  static IconData getCategoryIcon(int categorieId, String icon) {
    switch (categorieId) {
      case EVENT:
      case BOOKS:
      case DONATION_EXCHANGE:
      case FOOD:
      case JOB:
      case COURSES_TRAINING:
      case GAS_CYLINDER:
        {
          return IconDataSolid(int.parse(icon));
        }
        break;
    }
    return IconData(int.parse(icon), fontFamily: 'MaterialIcons');
  }

  static List<Post> sortPostDescending(List<Post> posts) {
    posts.sort((post1, post2) => post2.updated_at.compareTo(post1.updated_at));

    return posts;
  }

  static List<Favorit> sortFavoritDescending(List<Favorit> favorits) {
    favorits.sort((favorit1, favorit2) => favorit2.created_at.compareTo(favorit1.created_at));

    return favorits;
  }

}

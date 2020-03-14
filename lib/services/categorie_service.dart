import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/global/global_url.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/categorie.dart';
import '../model/categorie_tile.dart';

class CategorieService {
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  Future<List<Categorie>> fetchCategories() async {
    String cacheTimeString =
        await _sharedPreferenceService.read(CATEGORIE_LIST_CACHE_TIME);

    if (cacheTimeString != null) {
      DateTime cacheTime = DateTime.parse(cacheTimeString);
      DateTime actualDateTime = DateTime.now();

      if (actualDateTime.difference(cacheTime) > Duration(days: 1)) {
        return fetchCategoriesFromServer();
      } else {
        return fetchCategoriesFromCache();
      }
    } else {
      return fetchCategoriesFromServer();
    }
  }

  Future<List<Categorie>> fetchCategoriesFromServer() async {
    final response = await http.Client().get(URL_CATEGORIES);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final categories = mapResponse["data"].cast<Map<String, dynamic>>();
        final categorieList = await categories.map<Categorie>((json) {
          return Categorie.fromJson(json);
        }).toList();

        //Cache translated categories
        String jsonCategorie = jsonEncode(categorieList);
        _sharedPreferenceService.save(CATEGORIE_LIST, jsonCategorie);

        DateTime cacheTime = DateTime.now();
        _sharedPreferenceService.save(
            CATEGORIE_LIST_CACHE_TIME, cacheTime.toIso8601String());

        return categorieList;
      } else {
        return [];
      }
    } else {
      return fetchCategoriesFromCache();
    }
  }

  Future<List<Categorie>> fetchCategoriesFromCache() async {
    String listCategoryFromSharePrefs =
        await _sharedPreferenceService.read(CATEGORIE_LIST);
    if (listCategoryFromSharePrefs != null) {
      Iterable iterablePost = jsonDecode(listCategoryFromSharePrefs);
      final categorieList = await iterablePost.map<Categorie>((categorie) {
        return Categorie.fromJsonPref(categorie);
      }).toList();
      return categorieList;
    } else {
      return fetchCategoriesFromServer();
    }
  }

  Future<List<CategorieTile>> mapCategorieToCategorieTile(
      List<Categorie> categories) async {
    List<CategorieTile> categorieTiles = new List();
    List<Categorie> parentCategories = new List();

    for (var item in categories) {
      if (item.parentid == null) {
        parentCategories.add(item);
      }
    }

    for (var parent in parentCategories) {
      CategorieTile parentTile = new CategorieTile(parent.title, parent.id);
      parentTile.children = new List<CategorieTile>();
      parentTile.icon = parent.icon;
      for (var child in categories) {
        if (child.parentid == parentTile.id) {
          CategorieTile childTile = new CategorieTile(child.title, child.id);
          childTile.parentid = parentTile.id;
          parentTile.children.add(childTile);
        }
      }

      parentTile.children
          .sort((child1, child2) => child1.title.compareTo(child2.title));

      categorieTiles.add(parentTile);
    }

    return categorieTiles;
  }

  Future<Categorie> fetchCategorieByID(int id) async {
    final response = await http.Client().get('$URL_CATEGORIES_BY_ID$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToCategorie(responseBody);
    } else {
      throw Exception(
          'Failed to save a Categorie. Error: ${response.toString()}');
    }
  }

  Categorie convertResponseToCategorie(Map<String, dynamic> json) {
    if (json["data"] == null) {
      return null;
    }

    return Categorie(
      id: json["data"]["id"],
      title: json["data"]["title"],
      parentid: json["data"]["parentid"],
      icon: json["data"]["icon"],
    );
  }

  Categorie translateCategory(Categorie categorie, BuildContext context) {
    Categorie translatedcategorie = categorie;
    translatedcategorie.title =
        AppLocalizations.of(context).translate(categorie.title);
    return translatedcategorie;
  }

  List<Categorie> translateCategories(
      List<Categorie> categories, BuildContext context) {
    List<Categorie> translatedcategories = new List();
    categories.forEach((categorie) =>
        translatedcategories.add(translateCategory(categorie, context)));

    return translatedcategories;
  }
}

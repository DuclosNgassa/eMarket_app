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

class CategoryService {
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  Future<List<Category>> fetchCategories() async {
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

  Future<List<Category>> fetchCategoriesFromServer() async {
    final response = await http.Client().get(URL_CATEGORIES);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final categories = mapResponse["data"].cast<Map<String, dynamic>>();
        final categorieList = await categories.map<Category>((json) {
          return Category.fromJson(json);
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

  Future<List<Category>> fetchCategoriesFromCache() async {
    String listCategoryFromSharePrefs =
        await _sharedPreferenceService.read(CATEGORIE_LIST);
    if (listCategoryFromSharePrefs != null) {
      Iterable iterablePost = jsonDecode(listCategoryFromSharePrefs);
      final categorieList = await iterablePost.map<Category>((categorie) {
        return Category.fromJsonPref(categorie);
      }).toList();
      return categorieList;
    } else {
      return fetchCategoriesFromServer();
    }
  }

  Future<List<CategorieTile>> mapCategorieToCategorieTile(
      List<Category> categories) async {
    List<CategorieTile> categorieTiles = new List();
    List<Category> parentCategories = new List();

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

  Future<Category> fetchCategorieByID(int id) async {
    final response = await http.Client().get('$URL_CATEGORIES_BY_ID$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToCategorie(responseBody);
    } else {
      throw Exception(
          'Failed to save a Categorie. Error: ${response.toString()}');
    }
  }

  Category convertResponseToCategorie(Map<String, dynamic> json) {
    if (json["data"] == null) {
      return null;
    }

    return Category(
      id: json["data"]["id"],
      title: json["data"]["title"],
      parentid: json["data"]["parentid"],
      icon: json["data"]["icon"],
    );
  }

  Category translateCategory(Category categorie, BuildContext context) {
    Category translatedcategorie = categorie;
    translatedcategorie.title =
        AppLocalizations.of(context).translate(categorie.title);
    return translatedcategorie;
  }

  List<Category> translateCategories(
      List<Category> categories, BuildContext context) {
    List<Category> translatedcategories = new List();
    categories.forEach((categorie) =>
        translatedcategories.add(translateCategory(categorie, context)));

    return translatedcategories;
  }
}

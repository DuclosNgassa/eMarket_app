import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/categorie.dart';
import '../model/categorie_tile.dart';
import '../services/global.dart';

class CategorieService {
  Future<List<Categorie>> fetchCategories() async {
    final response = await http.Client().get(URL_CATEGORIES);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final categories = mapResponse["data"].cast<Map<String, dynamic>>();
        final categorieList = await categories.map<Categorie>((json) {
          return Categorie.fromJson(json);
        }).toList();
        return categorieList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Categories from the internet');
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

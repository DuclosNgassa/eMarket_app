import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/categorie.dart';
import '../model/categorie_tile.dart';
import '../services/global.dart';

class CategorieService {
  Future<List<Categorie>> fetchCategories(http.Client client) async {
    final response = await client.get(URL_CATEGORIES);
    if (response.statusCode == 200) {
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

      categorieTiles.add(parentTile);
    }
    return categorieTiles;
  }
}

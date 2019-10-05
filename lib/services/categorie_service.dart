import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/categorie.dart';
import '../services/global.dart';

class CategorieService{

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

}
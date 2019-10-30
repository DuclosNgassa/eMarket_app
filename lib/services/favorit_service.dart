import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/user.dart';
import 'package:http/http.dart' as http;

import '../services/global.dart';

class FavoritService {

  Future<Favorit> saveFavorit(Map<String, dynamic> params) async {
    final response = await http.post(Uri.encodeFull(URL_FAVORITS), body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToFavorit(responseBody);
    } else {
      throw Exception('Failed to save a Favorit. Error: ${response.toString()}');
    }
  }

  Future<List<Favorit>> fetchFavorits() async {
    final response = await http.Client().get(URL_FAVORITS);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final favoritList = await users.map<Favorit>((json) {
          return Favorit.fromJson(json);
        }).toList();
        return favoritList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Favorits from the internet');
    }
  }

  Future<Favorit> fetchFavoritByUserEmail(String email) async {
    final response = await http.Client().get('$URL_FAVORITS_BY_EMAIL$email');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        return convertResponseToFavorit(mapResponse);
      } else {
        return null;
      }
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load Favorits from the internet');
    }
  }

  Future<Favorit> update(Map<String, dynamic> params) async {
    final response = await http.Client().put('$URL_FAVORITS/${params["id"]}', body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToFavorit(responseBody);
    } else {
      throw Exception('Failed to update a Favorit. Error: ${response.toString()}');
    }
  }

  Future<bool> delete(int id) async {
    final response = await http.Client().delete('$URL_FAVORITS/$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      if(responseBody["result"] == "ok"){
        return true;
      }
    } else {
      throw Exception('Failed to delete a Favorit. Error: ${response.toString()}');
    }
  }


  Favorit convertResponseToFavorit(Map<String, dynamic> json) {
    if(json["data"] == null){
      return null;
    }
    return Favorit(
      id: json["data"]["id"],
      useremail: json["data"]["useremail"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      postid: json["data"]["postid"],
    );
  }

}

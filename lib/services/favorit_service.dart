import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/global/global_url.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/util.dart';
import 'package:http/http.dart' as http;

import '../util/global.dart';

class FavoritService {
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  PostService _postService = new PostService();

  Future<Favorit> save(Map<String, dynamic> params) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.post(Uri.encodeFull(URL_FAVORITS),
        headers: headers, body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToFavorit(responseBody);
    } else {
      throw Exception(
          'Failed to save a Favorit. Error: ${response.toString()}');
    }
  }

  Future<List<Favorit>> fetchFavorits() async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().get(URL_FAVORITS, headers: headers);
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

  Future<List<Favorit>> fetchFavoritByUserEmail(String email) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response =
        await http.get('$URL_FAVORITS_BY_EMAIL$email', headers: headers);
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
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load Favorits from the internet');
    }
  }

  Future<List<Post>> loadMyFavoritFromCache(String userEmail) async {
    String EMAIL_MY_FAVORIT_LIST = MY_FAVORIT_LIST + userEmail;

    String listPostFromSharePrefs =
        await _sharedPreferenceService.read(EMAIL_MY_FAVORIT_LIST);
    if (listPostFromSharePrefs != null) {
      Iterable iterablePost = jsonDecode(listPostFromSharePrefs);
      final postList = await iterablePost.map<Post>((post) {
        return Post.fromJsonPref(post);
      }).toList();
      return postList;
    } else {
      return loadMyFavoritFromServer(userEmail);
    }
  }

  Future<List<Post>> loadMyFavoritFromServer(String userEmail) async {
    String EMAIL_MY_FAVORIT_LIST = MY_FAVORIT_LIST + userEmail;
    String EMAIL_MY_FAVORIT_LIST_CACHE_TIME =
        MY_FAVORIT_LIST_CACHE_TIME + userEmail;

    List<Post> _myFavoritPosts = new List();
    List<Favorit> _myFavorits = await fetchFavoritByUserEmail(userEmail);
    List<Favorit> _mySortedFavorits = Util.sortFavoritDescending(_myFavorits);
    //_myFavoritPosts.clear();
    for (Favorit favorit in _mySortedFavorits) {
      Post post = await _postService.fetchPostById(favorit.postid);
      _myFavoritPosts.add(post);
    }
    if (_myFavoritPosts.isNotEmpty) {
      // Cache _myFavoritPosts
      String jsonFavorits = jsonEncode(_myFavoritPosts);
      _sharedPreferenceService.save(EMAIL_MY_FAVORIT_LIST, jsonFavorits);
      DateTime cacheTime = DateTime.now();
      _sharedPreferenceService.save(
          EMAIL_MY_FAVORIT_LIST_CACHE_TIME, cacheTime.toIso8601String());
    }
    return _myFavoritPosts;
  }

  Future<Favorit> update(Map<String, dynamic> params) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client()
        .put('$URL_FAVORITS/${params["id"]}', headers: headers, body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToFavorit(responseBody);
    } else {
      throw Exception(
          'Failed to update a Favorit. Error: ${response.toString()}');
    }
  }

  Future<bool> delete(int id) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response =
        await http.Client().delete('$URL_FAVORITS/$id', headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      if (responseBody["result"] == "ok") {
        return true;
      }
    } else {
      throw Exception(
          'Failed to delete a Favorit. Error: ${response.toString()}');
    }
  }

  Favorit convertResponseToFavorit(Map<String, dynamic> json) {
    if (json["data"] == null) {
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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../services/global.dart';
import 'sharedpreferences_service.dart';

class PostService {
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  Future<Post> save(Map<String, dynamic> params) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.post(Uri.encodeFull(URL_POSTS),
        headers: headers, body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToPost(responseBody);
    } else {
      throw Exception('Failed to save a Post. Error: ${response.toString()}');
    }
  }

  Future<List<Post>> fetchPosts() async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().get(URL_POSTS, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final posts = mapResponse["data"].cast<Map<String, dynamic>>();
        final postList = await posts.map<Post>((json) {
          return Post.fromJson(json);
        }).toList();
        return postList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Posts from the internet');
    }
  }

  Future<List<Post>> fetchActivePosts() async {
    String cacheTimeString =
        await _sharedPreferenceService.read(POST_LIST_CACHE_TIME);

    if (cacheTimeString != null) {
      DateTime cacheTime = DateTime.parse(cacheTimeString);
      DateTime actualDateTime = DateTime.now();

      if (actualDateTime.difference(cacheTime) > Duration(minutes: 3)) {
        return fetchActivePostFromServer();
      } else {
        return _fetchActivePostFromCache();
      }
    } else {
      return fetchActivePostFromServer();
    }
  }

  Future<List<Post>> _fetchActivePostFromCache() async {
    String listPostFromSharePrefs =
        await _sharedPreferenceService.read(POST_LIST);
    if (listPostFromSharePrefs != null) {
      Iterable iterablePost = jsonDecode(listPostFromSharePrefs);
      final postList = await iterablePost.map<Post>((post) {
        return Post.fromJsonPref(post);
      }).toList();
      return postList;
    } else {
      return fetchActivePostFromServer();
    }
  }

  Future<List<Post>> fetchActivePostFromCacheWithoutServerCall() async {
    String listPostFromSharePrefs =
        await _sharedPreferenceService.read(POST_LIST);
    if (listPostFromSharePrefs != null) {
      Iterable iterablePost = jsonDecode(listPostFromSharePrefs);
      final postList = await iterablePost.map<Post>((post) {
        return Post.fromJsonPref(post);
      }).toList();
      return postList;
    } else {
      return null;
    }
  }

  Future<List<Post>> fetchActivePostFromServer() async {
    final response = await http.Client().get(URL_POST_ACTIVE);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final posts = mapResponse["data"].cast<Map<String, dynamic>>();
        final postList = await posts.map<Post>((json) {
          return Post.fromJson(json);
        }).toList();
        //fetch image to display
        for (var post in postList) {
          await post.getImageUrl();
        }
        List<Post> sortedpostList = sortDescending(postList);
        //save posts in cache
        String jsonPosts = jsonEncode(postList);
        _sharedPreferenceService.save(POST_LIST, jsonPosts);
        DateTime cacheTime = DateTime.now();
        _sharedPreferenceService.save(
            POST_LIST_CACHE_TIME, cacheTime.toIso8601String());
        return sortedpostList;
      } else {
        return _fetchActivePostFromCache();
      }
    } else {
      throw Exception('Failed to load Posts from the internet');
    }
  }

  Future<Post> fetchPostById(int id) async {
    final response = await http.Client().get('$URL_POST_BY_ID$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToPost(responseBody);
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load Posts from the internet');
    }
  }

  Future<List<Post>> fetchPostByUserEmail(String email) async {
    String EMAIL_POST_LIST_CACHE_TIME = MY_POST_LIST_CACHE_TIME + email;
    String cacheTimeString =
        await _sharedPreferenceService.read(EMAIL_POST_LIST_CACHE_TIME);
    if (cacheTimeString != null) {
      DateTime cacheTime = DateTime.parse(cacheTimeString);
      DateTime actualDateTime = DateTime.now();

      if (actualDateTime.difference(cacheTime) > Duration(minutes: 3)) {
        return _loadMyPostFromServer(email);
      } else {
        return _loadMyPostFromCache(email);
      }
    } else {
      return _loadMyPostFromServer(email);
    }
  }

  Future<List<Post>> _loadMyPostFromServer(String email) async {
    String EMAIL_MY_POST_LIST = MY_POST_LIST + email;
    String EMAIL_POST_LIST_CACHE_TIME = MY_POST_LIST_CACHE_TIME + email;

    final response = await http.Client().get('$URL_POST_BY_USEREMAIL$email');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final posts = mapResponse["data"].cast<Map<String, dynamic>>();
        final List<Post> postList = await posts.map<Post>((json) {
          return Post.fromJson(json);
        }).toList();

        //Sort the postlist descending
        List<Post> sortedpostList = sortDescending(postList);
        //save posts in cache
        String jsonPosts = jsonEncode(postList);
        _sharedPreferenceService.save(EMAIL_MY_POST_LIST, jsonPosts);
        DateTime cacheTime = DateTime.now();
        _sharedPreferenceService.save(
            EMAIL_POST_LIST_CACHE_TIME, cacheTime.toIso8601String());
        return sortedpostList;
      } else {
        return _loadMyPostFromCache(email);
      }
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load Posts from the internet');
    }
  }

  Future<List<Post>> _loadMyPostFromCache(String email) async {
    String EMAIL_MY_POST_LIST = MY_POST_LIST + email;
    String listPostFromSharePrefs =
        await _sharedPreferenceService.read(EMAIL_MY_POST_LIST);
    if (listPostFromSharePrefs != null) {
      Iterable iterablePost = jsonDecode(listPostFromSharePrefs);
      final postList = await iterablePost.map<Post>((post) {
        return Post.fromJsonPref(post);
      }).toList();
      return postList;
    } else {
      return _loadMyPostFromServer(email);
    }
  }

  Future<List<Post>> fetchPostByCategory(int categoryId) async {
    List<Post> postCategories = new List();
    List<Post> postList = await fetchActivePostFromCacheWithoutServerCall();
    if (postList != null && postList.isNotEmpty) {
      for (Post post in postList) {
        if (post.categorieid == categoryId) {
          postCategories.add(post);
        }
      }
      return postList;
    } else {
      final response =
          await http.Client().get('$URL_POST_BY_CATEGORY$categoryId');
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        if (mapResponse["result"] == "ok") {
          final posts = mapResponse["data"].cast<Map<String, dynamic>>();
          final postList = await posts.map<Post>((json) {
            return Post.fromJson(json);
          }).toList();
          return postList;
        } else {
          throw Exception(
              'Failed to load Posts by categoryId from the internet');
        }
      } else if (response.statusCode == HttpStatus.notFound) {
        return null;
      } else {
        throw Exception('Failed to load Posts by categoryId from the internet');
      }
    }
  }

  Future<Post> update(Map<String, dynamic> params) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client()
        .put('$URL_POSTS/${params["id"]}', headers: headers, body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToPostUpdate(responseBody);
    } else {
      throw Exception('Failed to update a Post. Error: ${response.toString()}');
    }
  }

  Future<Post> updateView(int id) async {
    final response = await http.Client().put('$URL_POST_VIEW$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToPostUpdateView(responseBody);
    } else {
      throw Exception('Failed to update a Post. Error: ${response.toString()}');
    }
  }

  Future<bool> delete(int id) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response =
        await http.Client().delete('$URL_POSTS/$id', headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      if (responseBody["result"] == "ok") {
        return true;
      }
    } else {
      throw Exception('Failed to delete a Post. Error: ${response.toString()}');
    }
  }

  List<Post> sortDescending(List<Post> posts) {
    posts.sort((post1, post2) => post2.updated_at.compareTo(post1.updated_at));

    return posts;
  }

  Post convertResponseToPost(Map<String, dynamic> json) {
    if (json["data"] == null) {
      return null;
    }

    return Post(
      id: json["data"]["id"],
      title: json["data"]["title"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      updated_at: DateTime.parse(json["data"]["updated_at"]),
      post_typ: Post.convertStringToPostTyp(json["data"]["post_typ"]),
      description: json["data"]["description"],
      fee: int.parse(json["data"]["fee"]),
      fee_typ: Post.convertStringToFeeTyp(json["data"]["fee_typ"]),
      city: json["data"]["city"],
      quarter: json["data"]["quarter"],
      status: Post.convertStringToStatus(json["data"]["status"]),
      rating: json["data"]["rating"],
      useremail: json["data"]["useremail"],
      phoneNumber: json["data"]["phone_number"],
      categorieid: json["data"]["categorieid"],
      count_view: json["data"]["count_view"],
    );
  }

  Post convertResponseToPostUpdateView(Map<String, dynamic> json) {
    if (json["data"] == null) {
      return null;
    }

    return Post(
      id: json["data"]["id"],
      title: json["data"]["title"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      updated_at: DateTime.parse(json["data"]["updated_at"]),
      post_typ: Post.convertStringToPostTyp(json["data"]["post_typ"]),
      description: json["data"]["description"],
      fee: int.parse(json["data"]["fee"]),
      fee_typ: Post.convertStringToFeeTyp(json["data"]["fee_typ"]),
      city: json["data"]["city"],
      quarter: json["data"]["quarter"],
      status: Post.convertStringToStatus(json["data"]["status"]),
      rating: json["data"]["rating"],
      useremail: json["data"]["useremail"],
      phoneNumber: json["data"]["phone_number"],
      categorieid: json["data"]["categorieid"],
      count_view: json["data"]["count_view"],
    );
  }

  Post convertResponseToPostUpdate(Map<String, dynamic> json) {
    if (json["data"] == null) {
      return null;
    }

    return Post(
      id: json["data"]["id"],
      title: json["data"]["title"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      updated_at: DateTime.parse(json["data"]["updated_at"]),
      post_typ: Post.convertStringToPostTyp(json["data"]["post_typ"]),
      description: json["data"]["description"],
      fee: int.parse(json["data"]["fee"]),
      fee_typ: Post.convertStringToFeeTyp(json["data"]["fee_typ"]),
      city: json["data"]["city"],
      quarter: json["data"]["quarter"],
      status: Post.convertStringToStatus(json["data"]["status"]),
      rating: int.parse(json["data"]["rating"]),
      useremail: json["data"]["useremail"],
      phoneNumber: json["data"]["phone_number"],
      categorieid: int.parse(json["data"]["categorieid"]),
      count_view: int.parse(json["data"]["count_view"]),
    );
  }
}

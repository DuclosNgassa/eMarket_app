import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../services/global.dart';
import 'authentication_service.dart';

class PostService {

  AuthenticationService _authenticationService = new AuthenticationService();

  Future<Post> save(Map<String, dynamic> params) async {
    final response = await http.post(Uri.encodeFull(URL_POSTS), body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToPost(responseBody);
    } else {
      throw Exception('Failed to save a Post. Error: ${response.toString()}');
    }
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.Client().get(URL_POSTS);
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
    final response = await http.Client().get(URL_POST_ACTIVE);
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
    final response = await http.Client().get('$URL_POST_BY_USEREMAIL$email');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final posts = mapResponse["data"].cast<Map<String, dynamic>>();
        final postList = await posts.map<Post>((json) {
          return Post.fromJson(json);
        }).toList();
        return postList;
      } else {
        throw Exception('Failed to load Posts from the internet');
      }
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load Posts from the internet');
    }
  }

  Future<Post> update(Map<String, dynamic> params) async {
    Map<String, String> headers = Map();
    headers['auth-token'] = await _authenticationService.getAuthenticationToken();

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
    final response = await http.Client().delete('$URL_POSTS/$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      if (responseBody["result"] == "ok") {
        return true;
      }
    } else {
      throw Exception('Failed to delete a Post. Error: ${response.toString()}');
    }
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
      quarter: json["data"]["quartier"],
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
      quarter: json["data"]["quartier"],
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
      quarter: json["data"]["quartier"],
      status: Post.convertStringToStatus(json["data"]["status"]),
      rating: int.parse(json["data"]["rating"]),
      useremail: json["data"]["useremail"],
      phoneNumber: json["data"]["phone_number"],
      categorieid: int.parse(json["data"]["categorieid"]),
      count_view: int.parse(json["data"]["count_view"]),
    );
  }
}

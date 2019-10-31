import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../services/global.dart';

class PostService {
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
    final response =
        await http.Client().put('$URL_POSTS/${params["id"]}', body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToPost(responseBody);
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
      categorieid: json["data"]["categorieid"],
    );
  }
}

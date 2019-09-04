import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/feetyp.dart';
import '../model/post.dart';
import '../model/posttyp.dart';
import '../model/status.dart';
import '../services/global.dart';

class PostService {
  Future<List<Post>> fetchPosts(http.Client client) async {
    final response = await client.get(URL_POSTS);
    if (response.statusCode == 200) {
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

  Future<Post> savePost(Map<String, dynamic> params) async {
    final response = await http.post(Uri.encodeFull(URL_POSTS),
        //headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: params);
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return convertResponseToPost(responseBody);
    } else {
      throw Exception('Failed to save a Post. Error: ${response.toString()}');
    }
  }

  Post convertResponseToPost(Map<String, dynamic> json) {
    return Post(
      id: json["data"]["id"],
      title: json["data"]["title"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      post_typ: convertToPostTyp(json["data"]["post_typ"]),
      description: json["data"]["description"],
      fee: int.parse(json["data"]["fee"]),
      fee_typ: convertToFeeTyp(json["data"]["fee_typ"]),
      city: json["data"]["city"],
      quarter: json["data"]["quartier"],
      status: convertToStatus(json["data"]["status"]),
      rating: json["data"]["rating"],
      userid: json["data"]["userid"],
      categorieid: json["data"]["categorieid"],
    );
  }

  PostTyp convertToPostTyp(String value) {
    switch (value) {
      case 'offer':
        {
          return PostTyp.offer;
        }
        break;
      case 'search':
        {
          return PostTyp.search;
        }
        break;
      case 'all':
        {
          return PostTyp.all;
        }
        break;
    }
  }

  Status convertToStatus(String value) {
    switch (value) {
      case 'done':
        {
          return Status.done;
        }
        break;
      case 'created':
        {
          return Status.created;
        }
        break;
    }
  }

  FeeTyp convertToFeeTyp(String value) {
    switch (value) {
      case 'negotiable':
        {
          return FeeTyp.negotiable;
        }
        break;
      case 'fixed':
        {
          return FeeTyp.fixed;
        }
        break;
      case 'gift':
        {
          return FeeTyp.gift;
        }
        break;
    }
  }
}

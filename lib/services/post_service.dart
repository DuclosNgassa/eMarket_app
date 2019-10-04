import 'dart:async';
import 'dart:convert';

import 'package:emarket_app/model/image.dart';
import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../services/global.dart';
import '../services/image_service.dart';

class PostService {

  ImageService _imageService = new ImageService();

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
      post_typ: Post.convertStringToPostTyp(json["data"]["post_typ"]),
      description: json["data"]["description"],
      fee: int.parse(json["data"]["fee"]),
      fee_typ: Post.convertStringToFeeTyp(json["data"]["fee_typ"]),
      city: json["data"]["city"],
      quarter: json["data"]["quartier"],
      status: Post.convertStringToStatus(json["data"]["status"]),
      rating: json["data"]["rating"],
      userid: json["data"]["userid"],
      categorieid: json["data"]["categorieid"],
    );
  }

  Future<List<Image>> fetchImages(http.Client client, int postId) async {
    return _imageService.fetchImagesByPostID(client, postId);
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/model/post_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../services/global.dart';
import '../services/image_service.dart';

class PostService {
  ImageService _imageService = new ImageService();

  Future<List<Post>> fetchPosts() async {
    final response = await http.Client().get(URL_POSTS);
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
    final response = await http.post(Uri.encodeFull(URL_POSTS), body: params);
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
      useremail: json["data"]["useremail"],
      categorieid: json["data"]["categorieid"],
    );
  }

  Future<List<PostImage>> fetchPostImages(int postId) async {
    return _imageService.fetchImagesByPostID(postId);
  }

  Future<List<CachedNetworkImage>> fetchImages(int postId) async {
    List<CachedNetworkImage> imageLists = new List();
    List<PostImage> postImages = await fetchPostImages(postId);

    await postImages.forEach(
      (postImage) => imageLists.add(
        CachedNetworkImage(
          imageUrl: postImage.image_url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );

    return imageLists;
  }
}

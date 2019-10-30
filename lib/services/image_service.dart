import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/post_image.dart';
import '../services/global.dart';

class ImageService{

  Future<PostImage> saveImage(Map<String, dynamic> params) async {
    final response = await http.post(URL_IMAGES, body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToImage(responseBody);
    } else {
      throw Exception('Failed to save a image. Error: ${response.toString()}');
    }
  }

  Future<List<PostImage>> fetchImages() async {
    final response = await http.Client().get(URL_IMAGES);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final images = mapResponse["data"].cast<Map<String, dynamic>>();
        final imageList = await images.map<PostImage>((json) {
          return PostImage.fromJson(json);
        }).toList();
        return imageList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Images from the internet');
    }
  }
  
  Future<List<PostImage>> fetchImagesByPostID(int postId) async {
    final response = await http.Client().get('$URL_IMAGES_BY_POSTID$postId');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final images = mapResponse["data"].cast<Map<String, dynamic>>();
        final imageList = await images.map<PostImage>((json) {
          return PostImage.fromJson(json);
        }).toList();
        return imageList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Images from the internet');
    }
  }

  Future<List<CachedNetworkImage>> fetchCachedNetworkImageByPostId(int postId) async {
    List<CachedNetworkImage> imageLists = new List();
    List<PostImage> postImages = await fetchImagesByPostID(postId);

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

  Future<bool> deleteByPostID(int postId) async {
    final response = await http.Client().delete('$URL_IMAGES_BY_POSTID$postId');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      if (responseBody["result"] == "ok") {
        return true;
      }
    } else {
      throw Exception('Failed to delete image. Error: ${response.toString()}');
    }
  }

  Map<String, dynamic> toMap(PostImage image){
    Map<String, dynamic> params = Map<String, dynamic>();
    params["image_url"] = image.image_url;
    params["created_at"] = image.created_at.toString();
    params["postid"] = image.postid.toString();

    return params;
  }

  PostImage convertResponseToImage(Map<String, dynamic> json) {
    if(json["data"] == null){
      return null;
    }

    return PostImage(
      id: json["data"]["id"],
      image_url: json["data"]["image_url"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      postid: json["data"]["postid"],
    );
  }

}
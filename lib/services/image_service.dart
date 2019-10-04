import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/image.dart';
import '../services/global.dart';

class ImageService{

  Future<List<Image>> fetchImages(http.Client client) async {
    final response = await client.get(URL_IMAGES);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final images = mapResponse["data"].cast<Map<String, dynamic>>();
        final imageList = await images.map<Image>((json) {
          return Image.fromJson(json);
        }).toList();
        return imageList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Images from the internet');
    }
  }
  
  Future<List<Image>> fetchImagesByPostID(http.Client client, int postId) async {
    final response = await client.get('$URL_IMAGES_BY_POSTID$postId');
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final images = mapResponse["data"].cast<Map<String, dynamic>>();
        final imageList = await images.map<Image>((json) {
          return Image.fromJson(json);
        }).toList();
        return imageList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Images from the internet');
    }
  }

  Future<Image> saveImage(http.Client client,  Map<String, dynamic> params) async {
    final response = await client.post(URL_IMAGES, body: params);
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return Image.fromJson(responseBody);
    } else {
      throw Exception('Failed to save a Image. Error: ${response.toString()}');
    }
  }

  Map<String, dynamic> toMap(Image image){
    Map<String, dynamic> params = Map<String, dynamic>();
    params["image_url"] = image.image_url;
    params["created_at"] = image.created_at.toString();
    params["postid"] = image.postid.toString();

    return params;
  }
}
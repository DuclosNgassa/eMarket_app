import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/model/user.dart';
import 'package:http/http.dart' as http;

import '../services/global.dart';

class UserService {
  Future<List<User>> fetchUsers() async {
    final response = await http.Client().get(URL_USERS);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final imageList = await users.map<User>((json) {
          return User.fromJson(json);
        }).toList();
        return imageList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Users from the internet');
    }
  }

  Future<User> fetchUserByEmail(String email) async {
    final response = await http.Client().get('$URL_USERS_BY_EMAIL$email');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        return convertResponseToUser(mapResponse);
      } else {
        throw Exception('Failed to load Users from the internet');
      }
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load Users from the internet');
    }
  }

  Future<User> saveUser(Map<String, dynamic> params) async {
    final response = await http.post(Uri.encodeFull(URL_USERS), body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToUser(responseBody);
    } else {
      throw Exception('Failed to save a User. Error: ${response.toString()}');
    }
  }

  User convertResponseToUser(Map<String, dynamic> json) {
    return User(
      id: json["data"]["id"],
      name: json["data"]["name"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      email: json["data"]["email"],
      phone_number: json["data"]["phone_number"],
      status: User.convertStringToStatus(json["data"]["user_status"]),
      rating: json["data"]["rating"],
    );
  }

}

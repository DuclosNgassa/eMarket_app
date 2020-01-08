import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/services/authentication_service.dart';
import 'package:http/http.dart' as http;

import '../services/global.dart';

class UserService {

  AuthenticationService _authenticationService = new AuthenticationService();

  Future<User> saveUser(Map<String, dynamic> params) async {
    final response = await http.post(Uri.encodeFull(URL_USERS), body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToUser(responseBody);
    } else {
      throw Exception('Failed to save a User. Error: ${response.toString()}');
    }
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.Client().get(URL_USERS);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final userList = await users.map<User>((json) {
          return User.fromJson(json);
        }).toList();
        return userList;
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
        return null;
      }
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load Users from the internet');
    }
  }

  Future<User> update(Map<String, dynamic> params) async {
    final response =
    await http.Client().put('$URL_USERS/${params["id"]}', body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToUserUpdate(responseBody);
    } else {
      throw Exception('Failed to update a Post. Error: ${response.toString()}');
    }
  }

  Future<User> convertResponseToUser(Map<String, dynamic> json) async {
    if(json["data"] == null){
      return null;
    }
    await _authenticationService.saveAuthenticationToken(json["token"]);
    return User(
      id: json["data"]["id"],
      name: json["data"]["name"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      email: json["data"]["email"],
      phone_number: json["data"]["phone_number"],
      device_token: json["data"]["device_token"],
      status: User.convertStringToStatus(json["data"]["user_status"]),
      rating: json["data"]["rating"],
    );
  }

  Future<User> convertResponseToUserUpdate(Map<String, dynamic> json) async {
    if(json["data"] == null){
      return null;
    }
    await _authenticationService.saveAuthenticationToken(json["token"]);

    return User(
      id: json["data"]["id"],
      name: json["data"]["name"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      email: json["data"]["email"],
      phone_number: json["data"]["phone_number"],
      device_token: json["data"]["device_token"],
      status: User.convertStringToStatus(json["data"]["user_status"]),
      rating: int.parse(json["data"]["rating"]),
    );
  }

}

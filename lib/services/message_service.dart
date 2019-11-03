import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/user.dart';
import 'package:http/http.dart' as http;

import '../services/global.dart';

class MessageService {

  Future<Message> saveMessage(Map<String, dynamic> params) async {
    final response = await http.post(Uri.encodeFull(URL_MESSAGES), body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToMessage(responseBody);
    } else {
      throw Exception('Failed to save a Message. Error: ${response.toString()}');
    }
  }

  Future<List<Message>> fetchMessages() async {
    final response = await http.Client().get(URL_MESSAGES);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await users.map<Message>((json) {
          return Message.fromJson(json);
        }).toList();
        return messageList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Messages from the internet');
    }
  }

  Future<List<Message>> fetchMessageByEmail(String email) async {
    final response = await http.Client().get('$URL_MESSAGES_BY_EMAIL$email');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await users.map<Message>((json) {
          return Message.fromJson(json);
        }).toList();
        return messageList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load Messages by sender from the internet');
    }
  }

  Future<List<Message>> fetchMessageByPostId(int postId) async {
    final response = await http.Client().get('$URL_MESSAGES_BY_POSTID$postId');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await users.map<Message>((json) {
          return Message.fromJson(json);
        }).toList();
        return messageList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load Messages by sender from the internet');
    }
  }

  Future<List<Message>> fetchMessageBySender(String sender) async {
    final response = await http.Client().get('$URL_MESSAGES_BY_SENDER$sender');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await users.map<Message>((json) {
          return Message.fromJson(json);
        }).toList();
        return messageList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load Messages by sender from the internet');
    }
  }

  Future<List<Message>> fetchMessageByReceiver(String receiver) async {
    final response = await http.Client().get('$URL_MESSAGES_BY_RECEIVER$receiver');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await users.map<Message>((json) {
          return Message.fromJson(json);
        }).toList();
        return messageList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load Messages by receiver from the internet');
    }
  }

  Future<Message> update(Map<String, dynamic> params) async {
    final response = await http.Client().put('$URL_MESSAGES/${params["id"]}', body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToMessage(responseBody);
    } else {
      throw Exception('Failed to update a Message. Error: ${response.toString()}');
    }
  }

  Future<bool> delete(int id) async {
    final response = await http.Client().delete('$URL_MESSAGES/$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      if(responseBody["result"] == "ok"){
        return true;
      }
    } else {
      throw Exception('Failed to delete a Message. Error: ${response.toString()}');
    }
  }

  Message convertResponseToMessage(Map<String, dynamic> json) {
    if(json["data"] == null){
      return null;
    }
    return Message(
      id: json["data"]["id"],
      sender: json["data"]["sender"],
      receiver: json["data"]["receiver"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      postid: json["data"]["postid"],
      body: json["data"]["body"],
    );
  }

}

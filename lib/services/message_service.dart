import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:http/http.dart' as http;

import '../services/global.dart';

class MessageService {

  SharedPreferenceService _sharedPreferenceService = new SharedPreferenceService();

  Future<Message> saveMessage(Map<String, dynamic> params) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.post(Uri.encodeFull(URL_MESSAGES), headers: headers, body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToMessage(responseBody);
    } else {
      throw Exception('Failed to save a Message. Error: ${response.toString()}');
    }
  }

  Future<List<Message>> fetchMessages() async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().get(URL_MESSAGES, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final messages = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await messages.map<Message>((json) {
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
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().get('$URL_MESSAGES_BY_EMAIL$email', headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final messages = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await messages.map<Message>((json) {
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
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().get('$URL_MESSAGES_BY_POSTID$postId', headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final messages = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await messages.map<Message>((json) {
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
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().get('$URL_MESSAGES_BY_SENDER$sender', headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final messages = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await messages.map<Message>((json) {
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
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().get('$URL_MESSAGES_BY_RECEIVER$receiver', headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final messages = mapResponse["data"].cast<Map<String, dynamic>>();
        final messageList = await messages.map<Message>((json) {
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
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().put('$URL_MESSAGES/${params["id"]}', headers: headers, body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToMessageUpdate(responseBody);
    } else {
      throw Exception('Failed to update a Message. Error: ${response.toString()}');
    }
  }

  Future<bool> delete(int id) async {
    Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    final response = await http.Client().delete('$URL_MESSAGES/$id', headers: headers);
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
      read: json["data"]["read"],
    );
  }

  Message convertResponseToMessageUpdate(Map<String, dynamic> json) {
    if(json["data"] == null){
      return null;
    }
    return Message(
      id: json["data"]["id"],
      sender: json["data"]["sender"],
      receiver: json["data"]["receiver"],
      created_at: DateTime.parse(json["data"]["created_at"]),
      postid: int.parse(json["data"]["postid"]),
      body: json["data"]["body"],
      read: int.parse(json["data"]["read"]),
    );
  }

  int countNewMessage(List<Message> messages, String userEmail) {
    int numberOfNewMessage = 0;

    messages.forEach((message) =>
    message.read == 0 && message.receiver == userEmail
        ? numberOfNewMessage++
        : numberOfNewMessage = numberOfNewMessage);

    return numberOfNewMessage;
  }


  bool isMessageRead(Message message, String userEmail){
    return message.receiver == userEmail && message.read == 0;
  }

  Message updateMessageAsRead(Message message){
    Message updatedMessage = message;
    updatedMessage.read = 1;
    return updatedMessage;
  }

  List<Message> getMessageRead(List<Message> messages, String userEmail){
    List<Message> messageReads = new List();
    for(Message message in messages) {
      if(isMessageRead(message, userEmail)){
        messageReads.add(updateMessageAsRead(message));
      }
    }

    return messageReads;
  }

  void updateMessageRead(List<Message> messages, String userEmail) async {
    List<Message> messageToUpdate = new List();
    messageToUpdate = getMessageRead(messages, userEmail);

    for(Message message in messageToUpdate){
      Map<String, dynamic> messageParams = message.toMapUpdate(message);
      await update(messageParams);
    }
  }

}

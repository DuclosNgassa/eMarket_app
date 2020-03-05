import 'dart:convert';

import 'package:emarket_app/model/post.dart';

import 'message.dart';

class PostMessage {
  Post post;
  List<Message> messages;
  DateTime recentMessageDate;

  PostMessage({
    this.post,
    this.messages,
    this.recentMessageDate,
  });

  factory PostMessage.fromJson(Map<String, dynamic> json) {
    return PostMessage(
      post: json["post"],
      messages: json["messages"],
      recentMessageDate: DateTime.parse(json["recentMessageDate"]),
    );
  }

  Map<String, dynamic> toJson() => {
        'post': post.toJson(),
        'messages': jsonEncode(messages),
        'recentMessageDate': recentMessageDate.toString(),
      };
}

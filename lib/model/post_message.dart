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
}

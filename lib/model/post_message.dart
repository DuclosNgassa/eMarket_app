import 'package:emarket_app/model/post.dart';

import 'message.dart';

class PostMessage {
  Post post;
  List<Message> messages;

  PostMessage({
    this.post,
    this.messages,
  });
}

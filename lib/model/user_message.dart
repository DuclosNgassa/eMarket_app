import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/user.dart';

import 'message.dart';

class UserMessage {
  Post post;
  User user;
  List<Message> messages;

  UserMessage({
    this.post,
    this.user,
    this.messages,
  });
}

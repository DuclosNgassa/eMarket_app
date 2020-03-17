import 'package:emarket_app/model/message.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/post_message.dart';
import 'package:emarket_app/model/post_message_wrapper.dart';
import 'package:emarket_app/services/message_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';

class MessageManager {
  MessageService _messageService = new MessageService();
  PostService _postService = new PostService();

  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  Stream<PostMessageWrapper> get myPostMessageWrapper async* {
    PostMessageWrapper postMessageWrapper = new PostMessageWrapper();

    postMessageWrapper = await _loadMessages();

    yield postMessageWrapper;
  }

  Future<PostMessageWrapper> _loadMessages() async {
    PostMessageWrapper postMessageWrapper = new PostMessageWrapper();
    String userEmail = await _sharedPreferenceService.read(USER_EMAIL);

    List<Message> messages = await _loadMessageByEmail(userEmail);
    List<PostMessage> postMessages = await _buildPostMessage(messages);

    postMessages.sort((postMessage1, postMessage2) =>
        postMessage1.recentMessageDate.isAfter(postMessage2.recentMessageDate)
            ? 0
            : 1);

    postMessageWrapper.messageList = messages;
    postMessageWrapper.postMessageList = postMessages;

    return postMessageWrapper;
  }

  Future<List<Message>> _loadMessageByEmail(String userEmail) async {
    if (userEmail != null && userEmail.isNotEmpty) {
      List<Message> messageList =
          await _messageService.fetchMessageByEmail(userEmail);
      return messageList;
    }
  }

  Future<List<PostMessage>> _buildPostMessage(
      List<Message> messagesList) async {
    List<PostMessage> _postMessageList = new List();

    Set<int> postIds = new Set();

    for (int i = 0; i < messagesList.length; i++) {
      postIds.add(messagesList[i].postid);
    }

    for (int i = 0; i < postIds.length; i++) {
      Post post = await _postService.fetchPostById(postIds.elementAt(i));
      List<Message> messageList = new List();

      int messagesListLength = messagesList.length;

      for (int j = 0; j < messagesListLength; j++) {
        if (postIds.elementAt(i) == messagesList.elementAt(j).postid) {
          messageList.add(messagesList.elementAt(j));
          //TODO dieser Durchlauf optimieren
          //messagesList.removeAt(j);
          //messagesListLength--;
          //--j;
        }
      }

      messageList
          .sort((m1, m2) => m1.created_at.isAfter(m2.created_at) ? 0 : 1);
      PostMessage postMessage = new PostMessage(
          messages: messageList,
          post: post,
          recentMessageDate: messageList.elementAt(0).created_at);
      _postMessageList.add(postMessage);
    }

    return _postMessageList;
  }
}

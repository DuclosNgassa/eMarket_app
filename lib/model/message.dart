class Message {
  int id;
  String sender;
  String receiver;
  DateTime created_at;
  int postid;
  String body;
  int read;

  Message(
      {this.id,
      this.sender,
      this.receiver,
      this.created_at,
      this.postid,
      this.body,
      this.read = 0});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      sender: json["sender"],
      receiver: json["receiver"],
      created_at: DateTime.parse(json["created_at"]),
      postid: json["postid"],
      body: json["body"],
      read: json["read"],
    );
  }

  //To use when retrieving message from sharedpreference
  factory Message.fromJsonPref(Map<String, dynamic> json) {
    return Message(
      id: int.parse(json["id"]),
      sender: json["sender"],
      receiver: json["receiver"],
      created_at: DateTime.parse(json["created_at"]),
      postid: int.parse(json["postid"]),
      body: json["body"],
      read: int.parse(json["read"]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'sender': sender,
        'receiver': receiver,
        'created_at': created_at.toString(),
        'postid': postid.toString(),
        'body': body.toString(),
        'read': read.toString(),
      };

  Map<String, dynamic> toMap(Message message) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["sender"] = message.sender;
    params["created_at"] = message.created_at.toString();
    params["receiver"] = message.receiver;
    params["postid"] = message.postid.toString();
    params["body"] = message.body;
    params["read"] = message.read.toString();

    return params;
  }

  Map<String, dynamic> toMapUpdate(Message message) {
    Map<String, dynamic> params = toMap(message);
    params["id"] = message.id.toString();

    return params;
  }
}

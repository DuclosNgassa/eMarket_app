class Message {
  int id;
  String sender;
  String receiver;
  DateTime created_at;
  int postid;
  String body;

  Message(
      {this.id,
      this.sender,
      this.receiver,
      this.created_at,
      this.postid,
      this.body});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      sender: json["sender"],
      receiver: json["receiver"],
      created_at: DateTime.parse(json["created_at"]),
      postid: json["postid"],
      body: json["body"],
    );
  }


  Map<String, dynamic> toMap(Message message) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["sender"] = message.sender;
    params["created_at"] = message.created_at.toString();
    params["receiver"] = message.receiver;
    params["postid"] = message.postid.toString();
    params["body"] = message.body;

    return params;
  }

}

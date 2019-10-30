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
}

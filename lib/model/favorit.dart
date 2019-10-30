class Favorit {
  int id;
  String useremail;
  DateTime created_at;
  int postid;

  Favorit(
      {this.id,
      this.useremail,
      this.created_at,
      this.postid});

  factory Favorit.fromJson(Map<String, dynamic> json) {
    return Favorit(
      id: json["id"],
      useremail: json["useremail"],
      created_at: DateTime.parse(json["created_at"]),
      postid: json["postid"],
    );
  }
}

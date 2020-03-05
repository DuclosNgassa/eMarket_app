class Favorit {
  int id;
  String useremail;
  DateTime created_at;
  int postid;

  Favorit({this.id, this.useremail, this.created_at, this.postid});

  factory Favorit.fromJson(Map<String, dynamic> json) {
    return Favorit(
      id: json["id"],
      useremail: json["useremail"],
      created_at: DateTime.parse(json["created_at"]),
      postid: json["postid"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'useremail': useremail,
        'created_at': created_at.toString(),
        'postid': postid.toString(),
      };

  Map<String, dynamic> toMap(Favorit favorit) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["created_at"] = favorit.created_at.toString();
    params["useremail"] = favorit.useremail;
    params["postid"] = favorit.postid.toString();

    return params;
  }
}

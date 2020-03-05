class PostImage {
  int id;
  String image_url;
  DateTime created_at;
  int postid;

  PostImage({this.id, this.image_url, this.created_at, this.postid});

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      id: json["id"],
      image_url: json["image_url"],
      created_at: DateTime.parse(json["created_at"]),
      postid: json["postid"],
    );
  }

  factory PostImage.fromJsonPref(Map<String, dynamic> json) {
    return PostImage(
      id: int.parse(json["id"]),
      image_url: json["image_url"],
      created_at: DateTime.parse(json["created_at"]),
      postid: int.parse(json["postid"]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'image_url': image_url,
        'created_at': created_at.toString(),
        'postid': postid.toString()
      };
}

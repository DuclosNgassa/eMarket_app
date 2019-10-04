

class Image {
  int id;
  String image_url;
  DateTime created_at;
  int postid;

  Image(
      {this.id,
      this.image_url,
      this.created_at,
      this.postid});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      image_url: json["image_url"],
      created_at: json["created_at"],
      postid: json["postid"],
    );
  }
}

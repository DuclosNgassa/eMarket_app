class Categorie {
  int id;
  String title;
  int parentid;
  String icon;

  Categorie(
      {this.id,
      this.title,
      this.parentid, this.icon});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json["id"],
      title: json["title"],
      parentid: json["parentid"],
      icon: json["icon"],
    );
  }
}

class Categorie {
  int id;
  String title;
  int parentid;
  String icon;

  Categorie({this.id, this.title, this.parentid, this.icon});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json["id"],
      title: json["title"],
      parentid: json["parentid"],
      icon: json["icon"],
    );
  }

  //To use when retrieving category from sharedpreference
  factory Categorie.fromJsonPref(Map<String, dynamic> json) {
    return Categorie(
      id: int.parse(json["id"]),
      title: json["title"],
      parentid: json["parentid"] == "null" ? null : int.parse(json["parentid"]),
      icon: json["icon"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'title': title,
        'parentid': parentid.toString(),
        'icon': icon,
      };
}

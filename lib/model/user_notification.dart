class UserNotification {
  int id;
  String title;
  String message;
  String useremail;
  DateTime created_at;

  UserNotification(
      {this.id, this.title, this.message, this.useremail, this.created_at});


  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json["id"],
      title: json["title"],
      message: json["message"],
      useremail: json["useremail"],
      created_at: DateTime.parse(json["created_at"]),
    );
  }

  Map<String, dynamic> toMap(UserNotification userNotification) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["title"] = userNotification.title.toString();
    params["message"] = userNotification.message.toString();
    params["useremail"] = userNotification.useremail;
    params["created_at"] = userNotification.created_at.toString();

    return params;
  }

}

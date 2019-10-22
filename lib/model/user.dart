import 'package:emarket_app/model/user_status.dart';

class User {
  int id;
  String name;
  DateTime created_at;
  String phone_number = '';
  String email = '';
  int rating = 5; //max 10 Bewerztungssystem
  UserStatus status;

  User(
      {this.id,
      this.name,
      this.created_at,
      this.phone_number,
      this.email,
      this.rating,
      this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      phone_number: json["phone_number"],
      email: json["email"],
      created_at: DateTime.parse(json["created_at"]),
      rating: json["rating"],
      status: json["user_status"],
    );
  }

  Map<String, dynamic> toMap(User user) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["name"] = user.name;
    params["created_at"] = user.created_at.toString();
    params["phone_number"] = user.phone_number;
    params["email"] = user.email;
    params["rating"] = user.rating.toString();
    params["user_status"] = convertStatusToString(user.status);

    return params;
  }

  static String convertStatusToString(UserStatus value) {
    switch (value) {
      case UserStatus.active:
        {
          return 'active';
        }
        break;
      case UserStatus.blocked:
        {
          return 'blocked';
        }
        break;
    }
  }

  static UserStatus convertStringToStatus(String value) {
    switch (value) {
      case 'active':
        {
          return UserStatus.active;
        }
        break;
      case 'blocked':
        {
          return UserStatus.blocked;
        }
        break;
    }
  }
}

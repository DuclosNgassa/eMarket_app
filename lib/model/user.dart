import 'package:emarket_app/model/enumeration/user_status.dart';

class User {
  int id;
  String name;
  DateTime created_at;
  String phone_number = '';
  String device_token = '';
  String deviceid = '';
  String email = '';
  int rating = 5; //max 10 Bewertungssystem
  UserStatus status;

  User(
      {this.id,
      this.name,
      this.created_at,
      this.phone_number,
      this.device_token,
      this.deviceid,
      this.email,
      this.rating,
      this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      created_at: DateTime.parse(json["created_at"]),
      phone_number: json["phone_number"],
      device_token: json["device_token"],
      deviceid: json["deviceid"],
      email: json["email"],
      rating: json["rating"],
      status: convertStringToStatus(json["user_status"]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name,
        'created_at': created_at.toString(),
        'phone_number': phone_number,
        'device_token': device_token,
        'deviceid': deviceid,
        'email': email,
        'rating': rating,
        'status': convertStatusToString(status),
      };

  Map<String, dynamic> toMapUpdate(User user) {
    Map<String, dynamic> params = toMap(user);
    params["id"] = user.id.toString();

    return params;
  }

  Map<String, dynamic> toMap(User user) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["name"] = user.name;
    params["created_at"] = user.created_at.toString();
    params["phone_number"] = user.phone_number;
    params["device_token"] = user.device_token;
    params["deviceid"] = user.deviceid;
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
    return 'blocked';
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
    return UserStatus.blocked;
  }
}

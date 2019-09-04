import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/feetyp.dart';
import '../model/posttyp.dart';
import '../model/status.dart';

class Post {
  int id;
  String title;
  DateTime created_at;
  PostTyp post_typ; // 'offer', 'search', 'all'
  String description;
  int fee;
  FeeTyp fee_typ; //Negotiable / fixed price / gift
  String city;
  String quarter; // where the article available is
  Status status; // done, created
  int rating = 5;
  int userid;
  int categorieid;
  String imageUrl;

  Post(
      {this.id,
      this.title,
      this.created_at,
      this.post_typ,
      this.description,
      this.fee,
      this.fee_typ,
      this.city,
      this.quarter,
      this.status,
      this.rating,
      this.userid,
      this.categorieid});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      title: json["title"],
      created_at: DateTime.parse(json["created_at"]),
      post_typ: json["post_typ"], // TODO Convert to enum
      description: json["description"],
      fee: json["fee"],
      fee_typ: json["fee_typ"], // TODO Convert to enum
      city: json["city"],
      quarter: json["quartier"],
      status: json["status"], // TODO Convert to enum
      rating: json["rating"],
      userid: json["userid"],
      categorieid: json["categorieid"],
    );
  }

  Map<String, dynamic> toMap(Post post) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["title"] = post.title;
    params["created_at"] = post.created_at.toString();
    params["post_typ"] = "offer";
    params["description"] = post.description;
    params["fee"] = post.fee.toString();
    params["fee_typ"] = "fixed";
    params["city"] = post.city;
    params["quartier"] = post.quarter;
    params["status"] = "created";
    params["rating"] = post.rating.toString();
    params["userid"] = post.userid.toString();
    params["categorieid"] = post.categorieid.toString();

    return params;
  }

  Map<String, dynamic> toJson() =>
      {
  'title' : title,
  'created_at' : created_at.toString(),
  'post_typ' : "gift",
  'description' : description,
  'fee' : fee.toString(),
  'fee_typ' : "fixed",
  'city' : city,
  'quarter' : quarter,
  'status' : "created",
  'rating' : rating.toString(),
  'userid' : userid.toString(),
  'categorieid' : categorieid.toString(),

};

  Future getImageUrl() async {
    if (imageUrl != null) {
      return;
    }

    HttpClient http = HttpClient();
    try {
      // Use darts Uri builder
      var uri = Uri.http('dog.ceo', '/api/breeds/image/random');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      // The dog.ceo API returns a JSON object with a property
      // called 'message', which actually is the URL.
      imageUrl = json.decode(responseBody)['message'];
    } catch (exception) {
      print(exception);
    }
  }

}

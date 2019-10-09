import 'dart:async';

import 'package:emarket_app/model/image.dart';
import 'package:http/http.dart' as http;

import '../model/feetyp.dart';
import '../model/posttyp.dart';
import '../model/status.dart';
import '../services/post_service.dart';

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
    Post post = Post(
      id: json["id"],
      title: json["title"],
      created_at: DateTime.parse(json["created_at"]),
      post_typ: Post.convertStringToPostTyp(json["post_typ"]),
      description: json["description"],
      fee: int.parse(json["fee"]),
      fee_typ: Post.convertStringToFeeTyp(json["fee_typ"]),
      city: json["city"],
      quarter: json["quartier"],
      status: Post.convertStringToStatus(json["status"]),
      rating: json["rating"],
      userid: json["userid"],
      categorieid: json["categorieid"],
    );

    return post;
  }

  Map<String, dynamic> toMap(Post post) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["title"] = post.title;
    params["created_at"] = post.created_at.toString();
    params["post_typ"] = convertPostTypToString(post.post_typ);
    params["description"] = post.description;
    params["fee"] = post.fee.toString();
    params["fee_typ"] = convertFeeTypToString(post.fee_typ);
    params["city"] = post.city;
    params["quartier"] = post.quarter;
    params["status"] = convertStatusToString(post.status);
    params["rating"] = post.rating.toString();
    params["userid"] = post.userid.toString();
    params["categorieid"] = post.categorieid.toString();

    return params;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'created_at': created_at.toString(),
        'post_typ': convertPostTypToString(post_typ),
        'description': description,
        'fee': fee.toString(),
        'fee_typ': convertFeeTypToString(fee_typ),
        'city': city,
        'quarter': quarter,
        'status': convertStatusToString(status),
        'rating': rating.toString(),
        'userid': userid.toString(),
        'categorieid': categorieid.toString(),
      };

  Future getImageUrl() async {
    if (imageUrl != null) {
      return;
    }

    PostService postService = new PostService();

    try {
      List<Image> imageList =
          await postService.fetchImages(http.Client(), this.id);
      imageUrl = imageList.elementAt(0).image_url;
    } catch (exception) {
      print(exception);
    }
  }

  static PostTyp convertStringToPostTyp(String value) {
    switch (value) {
      case 'offer':
        {
          return PostTyp.offer;
        }
        break;
      case 'search':
        {
          return PostTyp.search;
        }
        break;
      case 'all':
        {
          return PostTyp.all;
        }
        break;
    }
  }

  static String convertPostTypToString(PostTyp value) {
    switch (value) {
      case PostTyp.offer:
        {
          return 'offer';
        }
        break;
      case PostTyp.search:
        {
          return 'search';
        }
        break;
      case PostTyp.all:
        {
          return 'all';
        }
        break;
    }
  }

  static Status convertStringToStatus(String value) {
    switch (value) {
      case 'done':
        {
          return Status.done;
        }
        break;
      case 'created':
        {
          return Status.created;
        }
        break;
    }
  }

  static String convertStatusToString(Status value) {
    switch (value) {
      case Status.done:
        {
          return 'done';
        }
        break;
      case Status.created:
        {
          return 'created';
        }
        break;
    }
  }

  static FeeTyp convertStringToFeeTyp(String value) {
    switch (value) {
      case 'negotiable':
        {
          return FeeTyp.negotiable;
        }
        break;
      case 'fixed':
        {
          return FeeTyp.fixed;
        }
        break;
      case 'gift':
        {
          return FeeTyp.gift;
        }
        break;
    }
  }

  static String convertFeeTypToString(FeeTyp value) {
    switch (value) {
      case FeeTyp.negotiable:
        {
          return 'negotiable';
        }
        break;
      case FeeTyp.fixed:
        {
          return 'fixed';
        }
        break;
      case FeeTyp.gift:
        {
          return 'gift';
        }
        break;
    }
  }
}

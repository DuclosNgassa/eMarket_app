import 'dart:async';

import 'package:emarket_app/model/post_image.dart';

import '../model/feetyp.dart';
import '../model/posttyp.dart';
import '../model/status.dart';
import '../services/post_service.dart';

class Post {
  int id;
  String title;
  DateTime created_at;
  DateTime updated_at;
  PostTyp post_typ; // 'offer', 'search', 'all'
  String description;
  int fee;
  FeeTyp fee_typ; //Negotiable / fixed price / gift
  String city;
  String quarter; // where the article available is
  Status status; // done, created
  int rating = 5;
  String useremail;
  int categorieid;
  String imageUrl;
  String phoneNumber;

  Post(
      {this.id,
      this.title,
      this.created_at,
      this.updated_at,
      this.post_typ,
      this.description,
      this.fee,
      this.fee_typ,
      this.city,
      this.quarter,
      this.status,
      this.rating,
      this.useremail,
      this.categorieid,
      this.phoneNumber});

  factory Post.fromJson(Map<String, dynamic> json) {
    Post post = Post(
      id: json["id"],
      title: json["title"],
      created_at: DateTime.parse(json["created_at"]),
      updated_at: DateTime.parse(json["updated_at"]),
      post_typ: Post.convertStringToPostTyp(json["post_typ"]),
      description: json["description"],
      fee: int.parse(json["fee"]),
      fee_typ: Post.convertStringToFeeTyp(json["fee_typ"]),
      city: json["city"],
      quarter: json["quartier"],
      status: Post.convertStringToStatus(json["status"]),
      rating: json["rating"],
      useremail: json["useremail"],
      categorieid: json["categorieid"],
      phoneNumber: json["phone_number"],
    );

    return post;
  }

  Map<String, dynamic> toMap(Post post) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["title"] = post.title;
    params["created_at"] = post.created_at.toString();
    params["updated_at"] = DateTime.now().toString();
    params["post_typ"] = convertPostTypToString(post.post_typ);
    params["description"] = post.description;
    params["fee"] = post.fee.toString();
    params["fee_typ"] = convertFeeTypToString(post.fee_typ);
    params["city"] = post.city;
    params["quartier"] = post.quarter;
    params["status"] = convertStatusToString(post.status);
    params["rating"] = post.rating.toString();
    params["useremail"] = post.useremail;
    params["categorieid"] = post.categorieid.toString();
    params["phone_number"] = post.phoneNumber;

    return params;
  }

  Map<String, dynamic> toMapUpdate(Post post) {
    Map<String, dynamic> params = toMap(post);
    params["id"] = post.id.toString();

    return params;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'created_at': created_at.toString(),
        'updated_at': updated_at.toString(),
        'post_typ': convertPostTypToString(post_typ),
        'description': description,
        'fee': fee.toString(),
        'fee_typ': convertFeeTypToString(fee_typ),
        'city': city,
        'quarter': quarter,
        'status': convertStatusToString(status),
        'rating': rating.toString(),
        'useremail': useremail,
        'categorieid': categorieid.toString(),
        'phone_number': phoneNumber,
      };

  Future getImageUrl() async {
    if (imageUrl != null) {
      return;
    }

    PostService postService = new PostService();

    try {
      List<PostImage> imageList = await postService.fetchPostImages(this.id);
      if (imageList.length > 0) {
        imageUrl = imageList.elementAt(0).image_url;
      } else {
        imageUrl =
            "http://192.168.2.120:3000/images/scaled_image_picker7760936399678163578-1567804687023.jpg";
      }
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

  static String convertPostTypToStringForDisplay(PostTyp value) {
    switch (value) {
      case PostTyp.offer:
        {
          return 'Offre';
        }
        break;
      case PostTyp.search:
        {
          return 'Recherche';
        }
        break;
      case PostTyp.all:
        {
          return 'Tout';
        }
        break;
    }
  }

  static Status convertStringToStatus(String value) {
    switch (value) {
      case 'created':
        {
          return Status.created;
        }
        break;
      case 'active':
        {
          return Status.active;
        }
        break;
      case 'archivated':
        {
          return Status.archivated;
        }
        break;
      case 'deleted':
        {
          return Status.deleted;
        }
        break;
    }
  }

  static String convertStatusToString(Status value) {
    switch (value) {
      case Status.created:
        {
          return 'created';
        }
        break;
      case Status.active:
        {
          return 'active';
        }
        break;
      case Status.archivated:
        {
          return 'archivated';
        }
        break;
      case Status.deleted:
        {
          return 'deleted';
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

  static String convertFeeTypToDisplay(FeeTyp value) {
    switch (value) {
      case FeeTyp.negotiable:
        {
          return 'Prix négociable';
        }
        break;
      case FeeTyp.fixed:
        {
          return 'Prix fixe';
        }
        break;
      case FeeTyp.gift:
        {
          return 'Offert gratuitemen';
        }
        break;
    }
  }
}

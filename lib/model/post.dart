import 'dart:async';

import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/post_image.dart';
import 'package:emarket_app/services/image_service.dart';
import 'package:flutter/cupertino.dart';

import '../model/enumeration/posttyp.dart';
import 'enumeration/feetyp.dart';
import 'enumeration/status.dart';

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
  int count_view;

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
      this.phoneNumber,
      this.count_view,
      this.imageUrl});

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
      quarter: json["quarter"],
      status: Post.convertStringToStatus(json["status"]),
      rating: json["rating"],
      useremail: json["useremail"],
      categorieid: json["categorieid"],
      phoneNumber: json["phone_number"],
      count_view: json["count_view"],
    );

    return post;
  }

  //To use when retrieving post from sharedpreference
  factory Post.fromJsonPref(Map<String, dynamic> json) {
    Post post = Post(
      id: int.parse(json["id"]),
      title: json["title"],
      created_at: DateTime.parse(json["created_at"]),
      updated_at: DateTime.parse(json["updated_at"]),
      post_typ: Post.convertStringToPostTyp(json["post_typ"]),
      description: json["description"],
      fee: int.parse(json["fee"]),
      fee_typ: Post.convertStringToFeeTyp(json["fee_typ"]),
      city: json["city"],
      quarter: json["quarter"],
      status: Post.convertStringToStatus(json["status"]),
      rating: int.parse(json["rating"]),
      useremail: json["useremail"],
      categorieid: int.parse(json["categorieid"]),
      phoneNumber: json["phone_number"],
      count_view: int.parse(json["count_view"]),
      imageUrl: json["imageUrl"],
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
    params["quarter"] = post.quarter;
    params["status"] = convertStatusToString(post.status);
    params["rating"] = post.rating.toString();
    params["useremail"] = post.useremail;
    params["categorieid"] = post.categorieid.toString();
    params["phone_number"] = post.phoneNumber;
    params["count_view"] = post.count_view.toString();

    return params;
  }

  Map<String, dynamic> toMapUpdate(Post post) {
    Map<String, dynamic> params = toMap(post);
    params["id"] = post.id.toString();

    return params;
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
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
        'count_view': count_view.toString(),
        'imageUrl': imageUrl,
      };

  Future getImageUrl() async {
    if (imageUrl != null) {
      return;
    }

    ImageService _imageService = new ImageService();

    try {
      List<PostImage> imageList = await _imageService.fetchImagesByPostID(this.id);
      if (imageList.length > 0) {
        imageUrl = imageList.elementAt(0).image_url;
      } else {
        imageUrl ="";
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
    return PostTyp.offer;
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
    return 'offer';
  }

  static String convertPostTypToStringForDisplay(PostTyp value, BuildContext context) {
    switch (value) {
      case PostTyp.offer:
        {
          return AppLocalizations.of(context).translate('offer');
        }
        break;
      case PostTyp.search:
        {
          return AppLocalizations.of(context).translate('search');
        }
        break;
      case PostTyp.all:
        {
          return AppLocalizations.of(context).translate('all');
        }
        break;
    }
    return AppLocalizations.of(context).translate('offer');
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
    return Status.created;
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
    return 'created';
  }

  static FeeTyp convertStringToFeeTyp(String value) {
    value = value.toLowerCase();
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
    return FeeTyp.negotiable;
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
    return 'negotiable';
  }

  static String convertFeeTypToDisplay(FeeTyp value, BuildContext context) {
    switch (value) {
      case FeeTyp.negotiable:
        {
          return AppLocalizations.of(context).translate('price_negotiable');
        }
        break;
      case FeeTyp.fixed:
        {
          return AppLocalizations.of(context).translate('price_fixe');
        }
        break;
      case FeeTyp.gift:
        {
          return AppLocalizations.of(context).translate('gift');
        }
        break;
    }
    return AppLocalizations.of(context).translate('price_negotiable');
  }
}

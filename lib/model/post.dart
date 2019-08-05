import '../model/posttyp.dart';
import '../model/feetyp.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class Post {
  String title;
  DateTime createdAt;
  String phoneAuthor = '';
  String emailAuthor = '';
  String category = '';
  PostTyp typ;
  String description;
  int fee;
  FeeTyp feeTyp; //Negotiable / fixed price / gift
  List<String> images;
  String city;
  String quarter; // where the article available is
  String imageUrl;
  int rating = 10;

  Post(
      this.title,
      this.createdAt,
      this.phoneAuthor,
      this.emailAuthor,
      this.category,
      this.typ,
      this.description,
      this.fee,
      this.feeTyp,
      this.city,
      this.quarter,
      this.rating);

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

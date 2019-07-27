import '../model/posttyp.dart';

class Post {
  String title;
  DateTime createdAt;
  String phoneAuthor = '';
  String emailAuthor = '';
  String category = '';
  PostTyp typ;
  String description;
  int fee;
  String feeTyp; //Negotiable / fixed price / gift
  List<String> images;
  String city; // where the article available is
}
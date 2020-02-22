import 'package:emarket_app/model/enumeration/feetyp.dart';

import '../model/enumeration/posttyp.dart';

class SearchParameter {
  String title;
  int category;
  int feeMin;
  int feeMax;
  String city;
  String quarter;
  PostTyp postTyp;
  FeeTyp feeTyp;
}
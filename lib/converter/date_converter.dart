import 'package:intl/intl.dart';

class DateConverter{

  DateTime convertToDate(String input) {
    try {
      return DateFormat.yMd().parseStrict(input);
    } catch (e) {
      print('An error occured while converting Date: ' + e);
      return null;
    }
  }

}
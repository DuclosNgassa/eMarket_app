import 'package:intl/intl.dart';

class DateConverter {
  DateTime convertToDate(String input) {
    try {
      return DateFormat.yMd().parseStrict(input);
    } catch (e) {
      print('An error occured while converting Date: ' + e);
      return null;
    }
  }

  static String convertToString(DateTime dateTime) {
    if (dateTime.day == DateTime.now().day &&
        dateTime.year == DateTime.now().year) {
      return "Aujourd'hui, " + convertToHour(dateTime);
    } else if (dateTime.day + 1 == DateTime.now().day &&
        dateTime.year == DateTime.now().year) {
      return "Hier, " + convertToHour(dateTime);
    }

    return dateTime.day.toString() +
        "." +
        dateTime.month.toString() +
        "." +
        dateTime.year.toString();
  }

  static String convertToHour(DateTime dateTime) {
    return dateTime.add(Duration(hours: 2)).hour.toString() + ":" + dateTime.minute.toString();
  }
}

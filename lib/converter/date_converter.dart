import 'package:emarket_app/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateConverter {
  DateTime convertToDate(String input) {
    try {
      return DateFormat.yMd().parseStrict(input);
    } catch (e) {
      return null;
    }
  }

  static String convertToString(DateTime dateTime, BuildContext context) {
    if (dateTime.day == DateTime.now().day &&
        dateTime.year == DateTime.now().year) {
      return AppLocalizations.of(context).translate('today') + ", " + convertToHour(dateTime);
    } else if (dateTime.day + 1 == DateTime.now().day &&
        dateTime.year == DateTime.now().year) {
      return AppLocalizations.of(context).translate('yesterday') + ", " + convertToHour(dateTime);
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

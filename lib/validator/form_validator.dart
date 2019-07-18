import '../converter/date_converter.dart';

class FormValidator{

  bool isValidDob(String dob){
    DateConverter dateConverter = new DateConverter();
    if(dob.isEmpty) return true;
    var d = dateConverter.convertToDate(dob);
    return d != null && d.isBefore(DateTime.now());
  }

  bool isEmptyText(String name){
    return name.isEmpty ? true : false;
  }

  bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

}
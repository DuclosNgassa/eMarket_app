import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';

class SharedPreferenceService {

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = Map();
    headers['auth-token'] = await read(AUTHENTICATION_TOKEN);
    return headers;
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clearForLogOut() async{
    remove(USER_EMAIL);
    remove(USER_NAME);
  }
}

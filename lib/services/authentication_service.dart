import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';

class AuthenticationService {
  void saveAuthenticationToken(String authenticationToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AUTHENTICATION_TOKEN, authenticationToken);
  }

  Future<String> getAuthenticationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(AUTHENTICATION_TOKEN);

    return authToken;
  }
}

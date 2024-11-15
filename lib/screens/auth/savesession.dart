import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSession(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user_email', email);
}

Future<String?> getUserSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email');
}

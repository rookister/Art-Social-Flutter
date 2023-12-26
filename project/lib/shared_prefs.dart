import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences{

saveUserData(Map<String, dynamic>? userData) async {
  if(userData!=null){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(userData));
  }
}

Future<Map<String, dynamic>?> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userDataString = prefs.getString('user_data');
  
  if (userDataString != null) {
    return await json.decode(userDataString) as Map<String, dynamic>;
} 
  else {
    return null;
  }
}

removeUserData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_data');
}

saveTheme(bool theme) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('theme', theme);
}

Future<bool> getTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? theme = prefs.getBool('theme');
  if (theme != null) {
    return theme;
} 
  else {
    return true;
  }
}

}

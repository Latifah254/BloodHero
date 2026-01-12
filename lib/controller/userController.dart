import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static const String baseUrl =
      "http://192.168.100.238/bloodhero_api";

  static Future<bool> login(
    String email, String password) async {

    final response = await http.post(
      Uri.parse("$baseUrl/api_login.php"),
      body: {
        "email": email,
        "password": password,
      },
    );

  print("LOGIN DIPANGGIL");
  print("STATUS CODE: ${response.statusCode}");
  print("RESPONSE BODY: ${response.body}");

    final data = json.decode(response.body);

    if (data["status"] == "success"){
      await saveSession(email);
      return true;
    }
    return false;  
  }

  static Future<bool> register(
    String name, String email, String password) async {

  final response = await http.post(
    Uri.parse("$baseUrl/api_register.php"),
    body: {
      "name": name,
      "email": email,
      "password": password,
    },
  );

  print("REGISTER DIPANGGIL");
  print("STATUS CODE: ${response.statusCode}");
  print("RESPONSE BODY: ${response.body}");

  final data = json.decode(response.body);
  return data['status'] == "success";
  }

  static Future<void> saveSession(String email) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", true);
    await prefs.setString("email", email);
  }

  static Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  
}

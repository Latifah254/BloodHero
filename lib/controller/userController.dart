import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static const baseUrl = "http://10.168.158.36/bloodhero_api";

  static Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api_login.php"),
        body: {"email": email, "password": password},
      );

      final data = jsonDecode(res.body);
      if (data["status"] == "success") {
        final prefs = await SharedPreferences.getInstance();
        final user = data["user"];

        prefs.setBool("isLogin", true);
        prefs.setInt("user_id", int.parse(user["id"].toString()));
        prefs.setString("name", user["name"]);
        prefs.setString("email", user["email"]);
        prefs.setString("blood_type", user["blood_type"]);
        prefs.setString("birth_date", user["birth_date"]);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> register(
      String name,
      String email,
      String password,
      String bloodType,
      String birthDate) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api_register.php"),
      body: {
        "name": name,
        "email": email,
        "password": password,
        "blood_type": bloodType,
        "birth_date": birthDate,
      },
    );
    final data = jsonDecode(res.body);
    return data["status"] == "success";
  }

  static Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, String>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString("name") ?? "",
      "email": prefs.getString("email") ?? "",
      "blood_type": prefs.getString("blood_type") ?? "",
      "birth_date": prefs.getString("birth_date") ?? "",
      "photo": prefs.getString("photo") ?? "",
    };
  }

  static Future<void> savePhoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("photo", path);
  }
}

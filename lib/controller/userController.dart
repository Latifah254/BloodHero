import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static const baseUrl = "http://10.247.72.36/bloodhero_api";

  static Future<bool> login(
    String email, 
    String password
  ) async {
  try {
    final res = await http.post(
      Uri.parse("$baseUrl/api_login.php"),
      body: {
        "email": email.trim(),
        "password": password,
      },
    );

    debugPrint("RAW LOGIN RESPONSE: ${res.body}");

    final data = jsonDecode(res.body);

    if (data["status"] == "success") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogin", true);
      await prefs.setInt("user_id", int.parse(data["user"]["id"].toString()));
      await prefs.setString("name", data["user"]["name"]);
      await prefs.setString("email", data["user"]["email"]);
      await prefs.setString("blood_type", data["user"]["blood_type"]?? "-");
      await prefs.setString("birth_date", data["user"]["birth_date"]?? "-");
      return true;
    }

    return false;
  } catch (e) {
    return false;
  }
}

  static Future<bool> register(
    String name,
    String email,
    String password,
    String bloodType,
    String birthDate,
  ) async {
    try {
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
    } catch (_) {
      return false;
    }
  }

  static Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name") ?? "";
  }

  static Future<void> savePhoto(String originalPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = originalPath.split('/').last;
    final newPath = "${dir.path}/$fileName";

    final newFile = await File(originalPath).copy(newPath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("photo_path", newFile.path);
  }

  static Future<String?> getPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("photo_path");
  }

  static Future<void> saveDonorStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("donor_status", status);
  }

  static Future<String> getDonorStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("donor_status") ?? "Pendonor Aktif";
  }
  
}

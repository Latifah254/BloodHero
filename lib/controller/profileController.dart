import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/user.dart';


class ProfileController {
  static const String baseUrl =
      "http://10.168.158.36/bloodhero_api";

  static Future<User?> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");

    if (email == null) return null;

    final response = await http.post(
      Uri.parse("$baseUrl/api_profile.php"),
      body: {"email": email},
    );

    final data = json.decode(response.body);
    if (data["status"] == "success") {
      return User.fromJson(data["data"]);
    }
    return null;
  }
}

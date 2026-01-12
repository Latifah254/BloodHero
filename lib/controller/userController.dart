import 'dart:convert';
import 'package:http/http.dart' as http;

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
    return data['status'] == "success";
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

}

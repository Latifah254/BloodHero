import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donor.dart';

class DonorController {
  static const String baseUrl =
      "http://192.168.100.238/bloodhero_api";

  static Future<List<Donor>> fetchDonors() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api_get_donor_history.php"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Donor.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data donor");
    }
  }
}

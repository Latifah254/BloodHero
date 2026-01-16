import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorController {
  static const String baseUrl =
      "http://10.168.158.36/bloodhero_api";

  static Future<List<DonorHistory>> fetchDonors() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api_get_donor_history.php")
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      final List list = data ['data'];
      return list.map((e) => DonorHistory.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}

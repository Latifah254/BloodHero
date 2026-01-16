import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorHistoryController {
  static const String baseUrl =
      "http://10.168.158.36/bloodhero_api";

  static Future<List<DonorHistory>> fetchHistory() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api_donor_history.php"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => DonorHistory.fromJson(e))
            .toList();
      }
    }
    return [];
  }
}

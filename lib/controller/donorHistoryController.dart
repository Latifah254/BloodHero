import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorHistoryController {
  static const String baseUrl =
      "http://10.168.158.36/bloodhero_api";

  static Future<List<DonorHistory>> fetchHistory(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api_donor_history.php?user_id=$userId"),
    );

    
    final data = jsonDecode(response.body);

    return (data as List)
          .map((e) => DonorHistory.fromJson(e))
          .toList();
  }

  static Future<bool> addDonor({
    required int userId,
    required String bloodType,
    required String donorDate,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api_add_donor.php"),
      body: {
        "user_id": userId.toString(),
        "blood_type": bloodType,
        "donor_date": donorDate,
      },
    );

    final result = jsonDecode(response.body);
    return result['status'] == 'success';
  }
}
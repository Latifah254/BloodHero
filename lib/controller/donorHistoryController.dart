import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorHistoryController {
  static const String 
    baseUrl = "http://10.168.158.36/bloodhero_api";

  static Future<bool> addDonor({
    required int userId,
    required String donorDate,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api_add_donor.php"),
      body: {
        "user_id": userId.toString(),
        "donor_date": donorDate,
      },
    );

    try {
      final data = jsonDecode(response.body);
      return data["status"] == "success";
    } catch (_) {
      return false;
    }
  }

  static Future<List<DonorHistory>> fetchHistory(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api_donor_history.php?user_id=$userId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Server error");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => DonorHistory.fromJson(e)).toList();
  }

  static DateTime? getLastDonorDate(List<DonorHistory> history) {
    if (history.isEmpty) return null;

    history.sort((a, b) =>
      DateTime.parse(b.donorDate).compareTo(
        DateTime.parse(a.donorDate),
      ),
  );
    return DateTime.parse(history.first.donorDate);
  }

}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorHistoryController {
  static const String baseUrl = "http://10.247.72.36/bloodhero_api";
  static const int minDays = 90;

  static Future<List<DonorHistory>> fetchHistory(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api_donor_history.php?user_id=$userId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil data");
    }

    final data = jsonDecode(response.body) as List;
    return data.map((e) => DonorHistory.fromJson(e)).toList();
  }

  static bool canAddDonor(
    List<DonorHistory> history,
    DateTime inputDate,
  ) {
    if (history.isEmpty) return true;

  
    history.sort((a, b) =>
        DateTime.parse(b.donorDate).compareTo(
          DateTime.parse(a.donorDate),
        ));

    final lastDonorDate = DateTime.parse(history.first.donorDate);

    
    if (inputDate.isAfter(DateTime.now())) return false;

    
    if (inputDate.isBefore(lastDonorDate)) return true;

    
    final nextAllowed =
        lastDonorDate.add(const Duration(days: minDays));

    return inputDate.isAfter(nextAllowed) ||
        inputDate.isAtSameMomentAs(nextAllowed);
  }

  static DateTime? getNextDonorDate(List<DonorHistory> history) {
    if (history.isEmpty) return null;

    history.sort((a, b) =>
        DateTime.parse(b.donorDate).compareTo(
          DateTime.parse(a.donorDate),
        ));

    final lastDate = DateTime.parse(history.first.donorDate);
    return lastDate.add(const Duration(days: minDays));
  }

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

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }

    final jsonData = json.decode(response.body);
    return jsonData["status"] == "success";
  }
}
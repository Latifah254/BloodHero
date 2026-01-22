import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorHistoryController {
  static const String baseUrl = "http://10.247.72.36/bloodhero_api";
  static const int minDays = 90;

  // ================= GET HISTORY =================
  static Future<List<DonorHistory>> fetchHistory(int userId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api_donor_history.php"),
      body: {
        "user_id": userId.toString(),
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Server error");
    }

    final jsonData = json.decode(res.body);

    if (jsonData['status'] != 'success') {
      return [];
    }

    return (jsonData['data'] as List)
        .map((e) => DonorHistory.fromJson(e))
        .toList();
  }

  // ================= ADD HISTORY =================
  static Future<bool> addDonor({
    required int userId,
    required DateTime donorDate,
  }) async {
    final formatted =
        "${donorDate.year}-${donorDate.month.toString().padLeft(2, '0')}-${donorDate.day.toString().padLeft(2, '0')}";

    final res = await http.post(
      Uri.parse("$baseUrl/api_add_donor.php"),
      body: {
        "user_id": userId.toString(),
        "donor_date": formatted,
      },
    );

    print("ADD DONOR RESPONSE: ${res.body}");

    if (res.statusCode != 200) return false;

    final jsonData = json.decode(res.body);
    return jsonData['status'] == 'success';
  }

  // ================= LOGIC =================
  static bool canAddDonor(
    List<DonorHistory> history,
    DateTime inputDate,
  ) {
    if (history.isEmpty) return true;

    history.sort(
      (a, b) => DateTime.parse(b.donorDate)
          .compareTo(DateTime.parse(a.donorDate)),
    );

    final last = DateTime.parse(history.first.donorDate);
    final nextAllowed = last.add(const Duration(days: minDays));

    return inputDate.isAfter(nextAllowed) ||
        inputDate.isAtSameMomentAs(nextAllowed);
  }

  static DateTime? getNextDonorDate(List<DonorHistory> history) {
    if (history.isEmpty) return null;

    history.sort(
      (a, b) => DateTime.parse(b.donorDate)
          .compareTo(DateTime.parse(a.donorDate)),
    );

    return DateTime.parse(history.first.donorDate)
        .add(const Duration(days: minDays));
  }

  // ================= STAT =================
  static int getTotalDonor(List<DonorHistory> history) => history.length;
  static int getTotalMl(List<DonorHistory> history) => history.length * 450;

  static int getBadgeCount(List<DonorHistory> history) {
    final total = history.length;
    if (total >= 10) return 4;
    if (total >= 5) return 3;
    if (total >= 3) return 2;
    if (total >= 1) return 1;
    return 0;
  }
}
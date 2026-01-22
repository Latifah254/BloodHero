import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donorHistory.dart';

class DonorHistoryController {
  static const String baseUrl = "http://10.247.72.36/bloodhero_api";
  static const int minDays = 90;

  static Future<List<DonorHistory>> fetchHistory(int userId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api_history.php"),
      body: {"user_id": userId.toString()},
    );

    final jsonData = json.decode(res.body);
    if (jsonData['status'] != 'success') return [];

    return (jsonData['data'] as List)
        .map((e) => DonorHistory.fromJson(e))
        .toList();
  }

  static bool canAddDonor(List<DonorHistory> history, DateTime inputDate) {
    if (history.isEmpty) return true;

    final sorted = [...history]
      ..sort((a, b) => DateTime.parse(b.donorDate)
          .compareTo(DateTime.parse(a.donorDate)));

    final last = DateTime.parse(sorted.first.donorDate);
    final nextAllowed = last.add(const Duration(days: minDays));

    return inputDate.isAfter(nextAllowed) ||
        inputDate.isAtSameMomentAs(nextAllowed);
  }

  static DateTime? getNextDonorDate(List<DonorHistory> history) {
    if (history.isEmpty) return null;

    final sorted = [...history]
      ..sort((a, b) => DateTime.parse(b.donorDate)
          .compareTo(DateTime.parse(a.donorDate)));

    return DateTime.parse(sorted.first.donorDate)
        .add(const Duration(days: minDays));
  }

  static Future<bool> addDonor({
    required int userId,
    required String donorDate,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api_add_donor.php"),
      body: {
        "user_id": userId.toString(),
        "donor_date": donorDate,
      },
    );

    final jsonData = json.decode(res.body);
    return jsonData['status'] == 'success';
  }

  static int getTotalDonor(List<DonorHistory> history) {
    return history.length;
  }

  static int getTotalMl(List<DonorHistory> history) {
    return history.length * 450;
  }

  static int getBadgeCount(List<DonorHistory> history) {
    final total = history.length;
    if (total >= 10) return 4;
    if (total >= 5) return 3;
    if (total >= 3) return 2;
    if (total >= 1) return 1;
    return 0;
  }

  static int getDaysRemaining(List<DonorHistory> history) {
    if (history.isEmpty) return 0;

    final sorted = [...history]
      ..sort((a, b) => DateTime.parse(b.donorDate)
          .compareTo(DateTime.parse(a.donorDate)));

    final last = DateTime.parse(sorted.first.donorDate);
    final nextAllowed = last.add(const Duration(days: minDays));

    final diff = nextAllowed.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }
}
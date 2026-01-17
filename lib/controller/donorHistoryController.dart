import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorHistoryController {
  static const String baseUrl =
      "http://10.168.158.36/bloodhero_api";

  static Future<bool> addDonor(
    int userId,
    String bloodType,
    String donorDate,
  ) async {
    try{
      final response = await http.post(
      Uri.parse("$baseUrl/api_add_donor.php"),
      body: {
        "blood_type": bloodType,
        "donor_date": donorDate,
      },
    ).timeout(const Duration(seconds: 10));

    final result = jsonDecode(response.body);
    return result['status'] == 'success';
  } catch (e) {
    debugPrint ("ERROR addDonor: $e");
    return false;
  }

    }
    

  static Future<List<DonorHistory>> fetchHistory(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api_donor_history.php?user_id=$userId"),
    );

    
    final data = jsonDecode(response.body);

    return (data as List)
          .map((e) => DonorHistory.fromJson(e))
          .toList();
  }

  
}
import 'dart:convert';
import 'package:bloodhero_app/models/donor.dart';

class DonorController {
  static Future<List<Donor>> fetchDonors() async {
    await Future.delayed(const Duration(seconds: 1));

    final response = '''
    [
      {"nama":"Andi","gol_darah":"A","lokasi":"Jakarta"},
      {"nama":"Budi","gol_darah":"B","lokasi":"Bandung"},
      {"nama":"Citra","gol_darah":"O","lokasi":"Surabaya"}
    ]
    ''';

    final data = jsonDecode(response) as List;
    return data.map((e) => Donor.fromJson(e)).toList();
  }
}

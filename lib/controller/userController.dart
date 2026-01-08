import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class UserController {
  // Cek kondisi jika user login 
  Future<bool> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    return isLoggedIn;
  }

  // Registrasi User
  Future<Map<String, dynamic>> registerUser({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.registerUrl),
        body: {
          'nama': nama,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Connection error: $e'};
    }
  }

  // Login User
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.loginUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        
        if (result['status'] == 'success') {
          //Menyimpan sesi
          await _saveSession(result['data']);
        }
        
        return result;
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Connection error: $e'};
    }
  }

  // Menyimpan sesi pada SharedPreferences
  Future<void> _saveSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyUserId, userData['id']);
    await prefs.setString(AppConstants.keyUserName, userData['nama']);
    await prefs.setString(AppConstants.keyUserEmail, userData['email']);
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    
    if (userData['golongan_darah'] != null) {
      await prefs.setString(
        AppConstants.keyGolonganDarah, 
        userData['golongan_darah']
      );
    }
  }

  
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt(AppConstants.keyUserId),
      'nama': prefs.getString(AppConstants.keyUserName),
      'email': prefs.getString(AppConstants.keyUserEmail),
      'golongan_darah': prefs.getString(AppConstants.keyGolonganDarah),
    };
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
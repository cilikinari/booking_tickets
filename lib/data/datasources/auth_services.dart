import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static String get baseUrl {
    if (kIsWeb) {
      // Browser tidak mendukung dart:io Platform
      return 'http://127.0.0.1:3000/api/v1';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api/v1';
    }

    return 'http://127.0.0.1:3000/api/v1';
  }

  // API Login
  static Future<String> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token']; 
        return token;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Email atau password salah');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // API Register
  static Future<bool> register(String name, String email, String password, String phone) async {
    final url = Uri.parse('$baseUrl/register'); 

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      // Status 201 Created atau 200 OK
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true; 
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mendaftar');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // API Get Profile (Membongkar JWT Token)
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Token JWT tidak valid');

      String normalized = base64Url.normalize(parts[1]);
      String decodedPayload = utf8.decode(base64Url.decode(normalized));
      Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);

      final userId = payloadMap['id'] ?? payloadMap['user_id'] ?? payloadMap['sub'];

      if (userId == null) {
        throw Exception('User ID tidak ditemukan di dalam token');
      }

      final url = Uri.parse('$baseUrl/user/$userId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? data; 
      } else {
        throw Exception('Gagal mengambil data profil');
      }
    } catch (e) {
      throw Exception('Error server: $e');
    }
  }
}
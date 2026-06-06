import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class AuthServices {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } 
    else {
      return 'http://127.0.0.1:3000/api/v1';
    }
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
}
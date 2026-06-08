import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule.dart';
import '../models/studio.dart';
import '../models/cinema.dart';
import 'auth_services.dart'; 

class BookingService {

  Future<List<Schedule>> fetchAllSchedules() async {
    final url = Uri.parse('${AuthServices.baseUrl}/schedule');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> jsonList;
        if (decodedData is List) {
          jsonList = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          jsonList = decodedData['data'] ?? [];
        } else {
          jsonList = [];
        }
        return jsonList.map((jsonItem) => Schedule.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat jadwal: $e');
    }
  }

  Future<List<Studio>> fetchAllStudios() async {
    final url = Uri.parse('${AuthServices.baseUrl}/studio');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> jsonList;
        if (decodedData is List) {
          jsonList = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          jsonList = decodedData['data'] ?? [];
        } else {
          jsonList = [];
        }
        return jsonList.map((item) => Studio.fromJson(item)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat studio: $e');
    }
  }

  Future<List<Cinema>> fetchAllCinemas() async {
    final url = Uri.parse('${AuthServices.baseUrl}/cinema');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> jsonList;
        if (decodedData is List) {
          jsonList = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          jsonList = decodedData['data'] ?? [];
        } else {
          jsonList = [];
        }
        return jsonList.map((item) => Cinema.fromJson(item)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat cinema: $e');
    }
  }
}
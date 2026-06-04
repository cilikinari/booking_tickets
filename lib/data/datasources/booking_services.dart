import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule.dart';
import '../models/studio.dart';
import '../models/cinema.dart';

class BookingService {
  static const String _baseUrl = 'http://localhost:3000/api/v1';

  // 1. FUNGSI AMBIL SEMUA JADWAL
  Future<List<Schedule>> fetchAllSchedules() async {
    final url = Uri.parse('$_baseUrl/schedule');
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

  // 2. FUNGSI AMBIL JADWAL BY ID
  Future<Schedule> fetchScheduleById(int id) async {
    final url = Uri.parse('$_baseUrl/schedule/$id');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        final mapData = (decodedData is Map && decodedData.containsKey('data'))
            ? decodedData['data']
            : decodedData;
        return Schedule.fromJson(mapData);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat jadwal berdasarkan ID: $e');
    }
  }

  // 3. FUNGSI AMBIL DATA STUDIO (NAMA BIOSKOP)
  Future<List<Studio>> fetchAllStudios() async {
    final url = Uri.parse('$_baseUrl/studio');
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

  // 🟢 FUNGSI BARU UNTUK MENGAMBIL DATA CINEMA (BIOSKOP)
  Future<List<Cinema>> fetchAllCinemas() async {
    final url = Uri.parse('$_baseUrl/cinema');
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

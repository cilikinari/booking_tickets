import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart'; // Sesuaikan path model city kamu

class CityService {
  // Samakan baseUrl dengan MovieService (Sesuaikan port backend Golang-mu, misal 3000 atau 8080)
  // Gunakan 10.0.2.2 jika kamu test menggunakan Emulator Android
  static const String _baseUrl = 'http://localhost:3000/api/v1';

  Future<List<City>> fetchAllCities() async {
    // Sesuai route Golang: api.Group("/city") -> Get("/")
    final url = Uri.parse('$_baseUrl/city');
    print("🔥 1. MENCOBA HIT API CITY: $url");

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> jsonList;

        // Validasi struktur JSON seperti di MovieService
        if (decodedData is List) {
          jsonList = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          jsonList = decodedData['data'] ?? [];
        } else {
          jsonList = [];
        }

        print("🔥 2. BANYAKNYA KOTA DI JSON: ${jsonList.length}");

        // Langsung return berupa List<City> objek utuh ke Repository
        return jsonList.map((jsonItem) => City.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Server merespon dengan kode: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      print("🚨 FATAL ERROR CITY: $e");
      print("🚨 STACKTRACE CITY: $stacktrace");
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}

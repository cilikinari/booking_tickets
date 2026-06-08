import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart'; 
import 'auth_services.dart'; 

class MovieService {

  Future<List<Movie>> fetchNowShowing() async {
    final url = Uri.parse('${AuthServices.baseUrl}/film');
    print("1. MENCOBA HIT API: $url"); 

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
        return jsonList.map((jsonItem) => Movie.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Server merespon dengan kode: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      print("🚨 FATAL ERROR: $e"); 
      print("🚨 STACKTRACE: $stacktrace");
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_services.dart';
import '../models/seat.dart';

class SeatServices {
  static Future<List<Seat>> getSeatsBySchedule(int scheduleId, String token) async {
    final url = Uri.parse('${AuthServices.baseUrl}/seat/schedule/$scheduleId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> seatList = [];

        if (decodedData is List) {
          seatList = decodedData; 
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          seatList = decodedData['data']; 
        }

        return seatList.map((json) => Seat.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat denah kursi');
      }
    } catch (e) {
      throw Exception('Error parsing data: $e');
    }
  }
}
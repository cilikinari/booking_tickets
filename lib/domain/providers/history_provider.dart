import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/models/booking.dart';
import '../../data/datasources/auth_services.dart'; // 🟢 Pakai AuthServices

class HistoryProvider extends ChangeNotifier {
  List<Booking> _bookingHistory = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Booking> get bookingHistory => _bookingHistory;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // 🟢 FUNGSI TARIK DATA DARI GOLANG (Jangan sampai hilang lagi ya! 🤣)
  Future<void> fetchHistory(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = Uri.parse('${AuthServices.baseUrl}/booking/my-history');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> data = [];

        if (decodedData is List) {
          data = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          data = decodedData['data'];
        }

        _bookingHistory = data.map((json) => Booking.fromJson(json)).toList();
      } else {
        _errorMessage = 'Gagal menarik histori dari server';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addBookingToHistory(Booking newBooking) {
    _bookingHistory.insert(0, newBooking);
    notifyListeners();
  }
}
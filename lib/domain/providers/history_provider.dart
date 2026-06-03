import 'package:flutter/material.dart';
import '../../data/models/booking.dart';

class HistoryProvider extends ChangeNotifier {
  // Menampung daftar tiket yang sukses dibeli
  final List<Booking> _bookingHistory = [];

  List<Booking> get bookingHistory => _bookingHistory;

  // 🟢 LOGIKA BISNIS: Memasukkan tiket sukses ke dalam daftar riwayat
  void addBookingToHistory(Booking newBooking) {
    _bookingHistory.insert(0, newBooking); // Masuk ke antrean paling atas
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../../data/models/booking.dart';

class HistoryProvider extends ChangeNotifier {
  // Menampung daftar tiket yang sukses dibeli
  final List<Booking> _bookingHistory = [];

//getter untuk booking history dikasi ke ui, tapi hanya bisa dibaca, tidak bisa diubah langsung dari luar provider. 
//ini buat nyimpen data booking yang sudah dilakukan, bisa digunakan untuk menampilkan riwayat booking.
  List<Booking> get bookingHistory => _bookingHistory;

//ini untuk add  history baru dan distack jadi yg paling atas
  void addBookingToHistory(Booking newBooking) {
    _bookingHistory.insert(0, newBooking); // Masuk ke antrean paling atas
    notifyListeners(); // Beritahu UI untuk update tampilan dengan data booking terbaru
  }
}
